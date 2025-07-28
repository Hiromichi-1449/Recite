import 'dart:math';
import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
  static const int cycleTotal = 10;

  void _incrementCounter() {
    setState(() {
      _count = (_count + 1) % cycleTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _incrementCounter,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: CyclePainter(
                  count: _count,
                  cycleTotal: cycleTotal,
                  backgroundColor: Colors.deepOrange,
                  progressColor: Colors.lightGreen,
                ),
                size: const Size(250, 250),
              ),
              Text(
                '$_count',
                style: const TextStyle(color: Colors.black, fontSize: 36),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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