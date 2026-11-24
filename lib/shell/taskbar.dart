import 'package:flutter/material.dart';

import '../apps/app_registry.dart';
import '../widgets/glass_panel.dart';
import '../windows/window_manager.dart';
import 'now_bar.dart';

class Taskbar extends StatelessWidget {
  const Taskbar({
    super.key,
    required this.wm,
    required this.desktop,
    required this.touch,
    required this.startOpen,
    required this.onStart,
  });

  final WindowManager wm;
  final Size desktop;
  final bool touch;
  final bool startOpen;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final size = touch ? 46.0 : 42.0;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: GlassPanel(
        radius: 22,
        blur: 30,
        opacity: 0.5,
        padding: const EdgeInsets.all(8),
        child: ListenableBuilder(
          listenable: wm,
          builder: (context, _) {
            final act = wm.active;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DockIcon(
                  size: size,
                  icon: Icons.apps_rounded,
                  colors: const [
                    Color(0xFFFF7EB3),
                    Color(0xFF9B5CFF),
                    Color(0xFF4DA3FF),
                  ],
                  focused: startOpen,
                  onTap: onStart,
                ),
                const SizedBox(width: 6),
                for (final app in appRegistry.where((a) => a.pinned))
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: DockIcon(
                      size: size,
                      icon: app.icon,
                      colors: app.colors,
                      running: wm.windowsFor(app).isNotEmpty,
                      focused: act?.app.id == app.id,
                      onTap: () => wm.toggleApp(app, desktop),
                    ),
                  ),
                Container(
                  width: 1,
                  height: size * 0.6,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                const SizedBox(width: 8),
                NowBar(compact: touch),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DockIcon extends StatefulWidget {
  const DockIcon({
    super.key,
    required this.size,
    required this.icon,
    required this.colors,
    required this.onTap,
    this.running = false,
    this.focused = false,
  });

  final double size;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
  final bool running;
  final bool focused;

  @override
  State<DockIcon> createState() => _DockIconState();
}

class _DockIconState extends State<DockIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 160),
          child: Container(
            width: s,
            height: s,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.colors.length == 1
                    ? [widget.colors.first, widget.colors.first]
                    : widget.colors,
              ),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(s * 0.62),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: s * 0.5),
                if (widget.running)
                  Positioned(
                    bottom: 3,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: widget.focused ? 14 : 5,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
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