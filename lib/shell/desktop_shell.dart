import 'package:flutter/material.dart';

import '../apps/app_registry.dart';
import '../theme/aetheris_theme.dart';
import '../windows/window_frame.dart';
import '../windows/window_manager.dart';
import 'start_menu.dart';
import 'taskbar.dart';
import 'wallpaper.dart';

class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key});

  @override
  State<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<DesktopShell> {
  final WindowManager _wm = WindowManager();
  bool _startOpen = false;

  @override
  void dispose() {
    _wm.dispose();
    super.dispose();
  }

  void _launch(AppDef app, Size size) {
    setState(() => _startOpen = false);
    _wm.launch(app, size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AetherisTheme.bg,
      body: Stack(
        children: [
          const Positioned.fill(child: Wallpaper()),
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, c) {
                final size = c.biggest;
                final touch = size.width < 700;
                final bottom = MediaQuery.of(context).padding.bottom;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ListenableBuilder(
                        listenable: _wm,
                        builder: (context, _) {
                          final act = _wm.active;
                          return Stack(
                            children: [
                              for (final w in _wm.windows)
                                if (!w.minimized)
                                  WindowFrame(
                                    key: ValueKey(w.id),
                                    win: w,
                                    wm: _wm,
                                    desktop: size,
                                    focused: w == act,
                                  ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (_startOpen)
                      Positioned.fill(
                        child: StartMenu(
                          bottomInset: 96 + bottom,
                          onLaunch: (a) => _launch(a, size),
                          onClose: () => setState(() => _startOpen = false),
                        ),
                      ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12 + bottom,
                      child: Center(
                        child: Taskbar(
                          wm: _wm,
                          desktop: size,
                          touch: touch,
                          startOpen: _startOpen,
                          onStart: () =>
                              setState(() => _startOpen = !_startOpen),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}