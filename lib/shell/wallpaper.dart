import 'package:flutter/material.dart';

/// Static gradient wallpaper (cheap to render; no asset needed).
class Wallpaper extends StatelessWidget {
  const Wallpaper({super.key});

  static Widget _blob(Alignment at, Color c, double a) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: at,
            radius: 0.75,
            colors: [c.withValues(alpha: a), Colors.transparent],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1026), Color(0xFF1B1146), Color(0xFF0B2A4A)],
          ),
        ),
        child: Stack(
          children: [
            _blob(const Alignment(-0.8, -0.6), const Color(0xFF4DA3FF), 0.35),
            _blob(const Alignment(0.9, 0.2), const Color(0xFF9B5CFF), 0.30),
            _blob(const Alignment(-0.2, 0.9), const Color(0xFF22D3A6), 0.20),
          ],
        ),
      ),
    );
  }
}