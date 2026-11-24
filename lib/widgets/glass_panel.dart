import 'dart:ui';

import 'package:flutter/material.dart';

/// Frosted-glass squircle surface (Mica/Acrylic stand-in).
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.radius = 24,
    this.blur = 30,
    this.opacity = 0.55,
    this.tint = const Color(0xFF141A26),
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double radius;
  final double blur;
  final double opacity;
  final Color tint;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // ContinuousRectangleBorder needs ~2x radius to look like a squircle.
    final r = BorderRadius.circular(radius * 2);
    return RepaintBoundary(
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: ContinuousRectangleBorder(borderRadius: r),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: ShapeDecoration(
              color: tint.withValues(alpha: opacity),
              shape: ContinuousRectangleBorder(
                borderRadius: r,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}