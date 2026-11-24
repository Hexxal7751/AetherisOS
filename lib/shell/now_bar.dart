import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/aetheris_theme.dart';

enum NowState { clock, media, calendar, network }

class NowBar extends StatefulWidget {
  const NowBar({super.key, required this.compact});

  final bool compact;

  @override
  State<NowBar> createState() => _NowBarState();
}

class _NowBarState extends State<NowBar> with SingleTickerProviderStateMixin {
  NowState _state = NowState.clock;
  DateTime _now = DateTime.now();
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();
  Timer? _timer;
  int _ticks = 0;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
      if (++_ticks % 6 == 0) _next();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wave.dispose();
    super.dispose();
  }

  void _next() {
    setState(() {
      _state = NowState.values[(_state.index + 1) % NowState.values.length];
    });
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Widget _content() {
    const label = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
    switch (_state) {
      case NowState.clock:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${_two(_now.hour)}:${_two(_now.minute)}',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
            if (!widget.compact)
              Text('${_days[_now.weekday - 1]} ${_now.day}',
                  style: const TextStyle(fontSize: 10, color: Colors.white54)),
          ],
        );
      case NowState.media:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 20,
              child: CustomPaint(painter: _WavePainter(_wave)),
            ),
            if (!widget.compact) ...[
              const SizedBox(width: 8),
              const Text('Lo-fi Beats', style: label),
            ],
          ],
        );
      case NowState.calendar:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_rounded, size: 16, color: Color(0xFFFFB84D)),
            const SizedBox(width: 6),
            Text(widget.compact ? '5:00' : 'Standup in 5:00',
                style: label.copyWith(color: const Color(0xFFFFD08A))),
          ],
        );
      case NowState.network:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.network_check_rounded,
                size: 16, color: AetherisTheme.accent),
            const SizedBox(width: 6),
            Text(widget.compact ? '42' : '42 Mb/s · 12 ms', style: label),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgent = _state == NowState.calendar;
    return GestureDetector(
      onTap: _next,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: AetherisTheme.fluid,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        constraints: const BoxConstraints(minHeight: 42),
        decoration: ShapeDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(
              color: urgent
                  ? const Color(0xFFFFB84D).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          shadows: urgent
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFB84D).withValues(alpha: 0.35),
                    blurRadius: 16,
                  ),
                ]
              : const [],
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: AetherisTheme.fluid,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(key: ValueKey(_state), child: _content()),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.t) : super(repaint: t);

  final Animation<double> t;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AetherisTheme.accent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    const n = 5;
    for (var i = 0; i < n; i++) {
      final k = 0.5 + 0.5 * math.sin(t.value * 2 * math.pi + i * 1.1);
      final h = size.height * (0.3 + 0.7 * k);
      final x = 3 + i * (size.width - 6) / (n - 1);
      canvas.drawLine(
        Offset(x, (size.height - h) / 2),
        Offset(x, (size.height + h) / 2),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => false;
}