import 'package:flutter/material.dart';
import 'dart:math';


class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
  int _completedCycles = 0;
  static const int cycleTotal = 10;

  void _incrementCounter() {
    setState(() {
      _count = (_count + 1) % cycleTotal;
      if (_count == 0) {
        _completedCycles++;
      }
    });
  }

  Widget _buildTallyDisplay(int completedCycles) {
    List<Row> rows = [];

    int fiveCycles = completedCycles ~/ 5;
    int oneCycle = completedCycles % 5;

    // Group of full tally marks (正)
    for (int i = 0; i < fiveCycles; i += 5) {
      int chunkSize = (i + 5 < fiveCycles) ? 5 : fiveCycles - i;
      List<Widget> completedRow = [];
      for (int j = 0; j < chunkSize; j++) {
        completedRow.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            '正',
            style: TextStyle(fontSize: 30, color: Colors.orange),
          ),
        ));
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: completedRow,
      ));
    }

    // Remaining single marks ('|')
    if (oneCycle > 0) {
      List<Widget> lineRow = [];
      for (int i = 0; i < oneCycle; i++) {
        lineRow.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            '|',
            style: TextStyle(fontSize: 30, color: Colors.orange),
          ),
        ));
      }
      if (rows.isNotEmpty) {
        rows[rows.length - 1] = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...rows.last.children,
            ...lineRow,
          ],
        );
      } else {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: lineRow,
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 101, 49, 49),
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
                    count: _count,
                    cycleTotal: cycleTotal,
                    backgroundColor: Colors.deepOrange,
                    progressColor: Colors.lightGreen,
                  ),
                  size: const Size(250, 250),
                ),
                Text(
                  '$_count',
                  style: const TextStyle(color: Colors.white, fontSize: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildTallyDisplay(_completedCycles),
          ],
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