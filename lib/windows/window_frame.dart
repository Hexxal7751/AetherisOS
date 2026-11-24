import 'package:flutter/material.dart';

import '../widgets/glass_panel.dart';
import 'window_manager.dart';

class WindowFrame extends StatelessWidget {
  const WindowFrame({
    super.key,
    required this.win,
    required this.wm,
    required this.desktop,
    required this.focused,
  });

  final OsWindow win;
  final WindowManager wm;
  final Size desktop;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final r = win.rect;
    return Positioned(
      left: r.left,
      top: r.top,
      width: r.width,
      height: r.height,
      child: Listener(
        onPointerDown: (_) {
          if (!focused) wm.focus(win);
        },
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: focused ? 0.5 : 0.25),
                blurRadius: focused ? 40 : 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: GlassPanel(
            radius: 18,
            blur: 28,
            opacity: focused ? 0.82 : 0.7,
            child: Stack(
              children: [
                Column(
                  children: [
                    _TitleBar(win: win, wm: wm, desktop: desktop),
                    Expanded(
                      child: ClipRect(
                        child: Material(
                          type: MaterialType.transparency,
                          child: win.app.builder(context),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!win.maximized)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanUpdate: (d) => wm.resize(win, d.delta),
                      child: const SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(Icons.south_east,
                            size: 14, color: Colors.white38),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({
    required this.win,
    required this.wm,
    required this.desktop,
  });

  final OsWindow win;
  final WindowManager wm;
  final Size desktop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate:
          win.maximized ? null : (d) => wm.move(win, d.delta, desktop),
      onDoubleTap: () => wm.toggleMax(win, desktop),
      child: SizedBox(
        height: 42,
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(win.app.icon, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                win.app.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),
            _WinButton(Icons.remove, () => wm.minimize(win)),
            _WinButton(
              win.maximized ? Icons.filter_none : Icons.crop_square,
              () => wm.toggleMax(win, desktop),
            ),
            _WinButton(Icons.close, () => wm.close(win), danger: true),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}

class _WinButton extends StatelessWidget {
  const _WinButton(this.icon, this.onTap, {this.danger = false});

  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 42,
        child: Icon(
          icon,
          size: 16,
          color: danger ? const Color(0xFFFF6B6B) : Colors.white60,
        ),
      ),
    );
  }
}