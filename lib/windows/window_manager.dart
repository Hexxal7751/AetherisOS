import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../apps/app_registry.dart';

class OsWindow {
  OsWindow({required this.id, required this.app, required this.rect});

  final int id;
  final AppDef app;
  Rect rect;
  Rect? restoreRect;
  bool minimized = false;
  bool maximized = false;
}

class WindowManager extends ChangeNotifier {
  /// Order in this list is the z-order (last = top).
  final List<OsWindow> windows = [];
  int _nextId = 1;

  OsWindow? get active {
    for (final w in windows.reversed) {
      if (!w.minimized) return w;
    }
    return null;
  }

  List<OsWindow> windowsFor(AppDef app) =>
      windows.where((w) => w.app.id == app.id).toList();

  void open(AppDef app, Size desktop) {
    final w = math.min(560.0, desktop.width - 24);
    final h = math.min(380.0, desktop.height - 150);
    final offset = (windows.length % 6) * 28.0;
    final left = ((desktop.width - w) / 2 + offset - 60)
        .clamp(12.0, math.max(12.0, desktop.width - w - 12))
        .toDouble();
    final top = (40 + offset)
        .clamp(24.0, math.max(24.0, desktop.height - h - 110))
        .toDouble();
    windows.add(OsWindow(
      id: _nextId++,
      app: app,
      rect: Rect.fromLTWH(left, top, w, h),
    ));
    notifyListeners();
  }

  /// Open if closed, otherwise bring the top window to front.
  void launch(AppDef app, Size desktop) {
    final list = windowsFor(app);
    if (list.isEmpty) {
      open(app, desktop);
    } else {
      focus(list.last);
    }
  }

  /// Taskbar click: open, focus, or minimize if already focused.
  void toggleApp(AppDef app, Size desktop) {
    final list = windowsFor(app);
    if (list.isEmpty) {
      open(app, desktop);
      return;
    }
    final top = list.last;
    if (top == active) {
      minimize(top);
    } else {
      focus(top);
    }
  }

  void focus(OsWindow w) {
    windows.remove(w);
    windows.add(w);
    w.minimized = false;
    notifyListeners();
  }

  void close(OsWindow w) {
    windows.remove(w);
    notifyListeners();
  }

  void minimize(OsWindow w) {
    w.minimized = true;
    notifyListeners();
  }

  void toggleMax(OsWindow w, Size desktop) {
    if (w.maximized) {
      w.rect = w.restoreRect ?? w.rect;
      w.maximized = false;
    } else {
      w.restoreRect = w.rect;
      w.rect = Rect.fromLTWH(8, 8, desktop.width - 16, desktop.height - 100);
      w.maximized = true;
    }
    notifyListeners();
  }

  void move(OsWindow w, Offset d, Size desktop) {
    final nl = (w.rect.left + d.dx)
        .clamp(-w.rect.width + 80, desktop.width - 80)
        .toDouble();
    final nt = (w.rect.top + d.dy).clamp(0.0, desktop.height - 60).toDouble();
    w.rect = Rect.fromLTWH(nl, nt, w.rect.width, w.rect.height);
    notifyListeners();
  }

  void resize(OsWindow w, Offset d) {
    final nw = math.max(280.0, w.rect.width + d.dx);
    final nh = math.max(200.0, w.rect.height + d.dy);
    w.rect = Rect.fromLTWH(w.rect.left, w.rect.top, nw, nh);
    notifyListeners();
  }
}