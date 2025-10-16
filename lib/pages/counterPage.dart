import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

/// ------------------------------------------------------------
/// Shared state for recitation target/current/cycles (Riverpod)
/// ------------------------------------------------------------
class Recitation {
  final int target;   // goal for one cycle
  final int current;  // current count in the cycle
  final int cycles;   // completed cycles
  const Recitation({required this.target, this.current = 0, this.cycles = 0});

  Recitation copyWith({int? target, int? current, int? cycles}) => Recitation(
        target: target ?? this.target,
        current: current ?? this.current,
        cycles: cycles ?? this.cycles,
      );
}

class RecitationController extends StateNotifier<Recitation> {
  RecitationController() : super(const Recitation(target: 108));

  void setTarget(int newTarget) {
    // Reset current when target changes; keep cycles history.
    state = state.copyWith(target: newTarget, current: 0);
  }

  void increment() {
    final next = state.current + 1;
    if (next >= state.target) {
      state = state.copyWith(current: 0, cycles: state.cycles + 1);
    } else {
      state = state.copyWith(current: next);
    }
  }
}

final recitationProvider =
    StateNotifierProvider<RecitationController, Recitation>(
        (ref) => RecitationController());

/// ------------------------------------------------------------
/// Counter Page (uses the shared provider above)
/// ------------------------------------------------------------
class CounterPage extends ConsumerStatefulWidget {
  const CounterPage({super.key});

  @override
  ConsumerState<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends ConsumerState<CounterPage> {
  void _incrementCounter() {
    ref.read(recitationProvider.notifier).increment();
  }

  @override
  Widget build(BuildContext context) {
    final recite = ref.watch(recitationProvider);
    final int cycleTotal = recite.target;
    final int count = recite.current;
    final int completedCycles = recite.cycles;

    return Scaffold(
      backgroundColor: const Color(0xFF555B6E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("COUNTER"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _incrementCounter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: CyclePainter(
                      count: count,
                      cycleTotal: cycleTotal,
                      backgroundColor: Colors.deepOrange,
                      progressColor: Colors.lightGreen,
                    ),
                    size: const Size(250, 250),
                  ),
                  Text(
                    '$count',
                    style: const TextStyle(color: Colors.white, fontSize: 36),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Target: $cycleTotal   •   Cycles: $completedCycles',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Painter for the ring + progress arc (unchanged behavior)
class CyclePainter extends CustomPainter {
  final int count;
  final int cycleTotal;
  final Color backgroundColor;
  final Color progressColor;

  CyclePainter({
    required this.count,
    required this.cycleTotal,
    this.backgroundColor = Colors.deepOrange,
    this.progressColor = Colors.lightGreen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * (count / cycleTotal);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CyclePainter oldDelegate) =>
      oldDelegate.count != count || oldDelegate.cycleTotal != cycleTotal;
}