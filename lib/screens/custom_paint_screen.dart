import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CustomPaintScreen extends StatefulWidget {
  const CustomPaintScreen({super.key});

  @override
  State<CustomPaintScreen> createState() => _CustomPaintScreenState();
}

class _CustomPaintScreenState extends State<CustomPaintScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..forward();

  static const twentyFiveMinutes = 25;
  final int initTotalSeconds = twentyFiveMinutes * 60;
  int totalSeconds = twentyFiveMinutes * 60;

  bool isRunning = false;
  late Timer timer;

  void onTick(Timer timer) {
    _animateValues();
    if (totalSeconds == 0) {
      timer.cancel();

      setState(() {
        isRunning = false;
      });
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    if (isRunning) return;

    timer = Timer.periodic(
      // const Duration(seconds: 1),
      const Duration(milliseconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onStopPressed() {
    if (isRunning) {
      timer.cancel();
    }
    setState(() {
      isRunning = false;
      totalSeconds = initTotalSeconds;
    });
    _animateValues();
  }

  void onReplayPressed() {
    onStopPressed();

    onStartPressed();
  }

  String formatMinute(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 4);
  }

  String formatSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(5, 7);
  }

  late Animation<double> _progress = Tween(
    begin: 0.005,
    end: 0.005,
  ).animate(_animationController);

  void _animateValues() {
    setState(() {
      _progress = Tween(
        begin: _progress.value,
        end: max(
            0.005, (initTotalSeconds - totalSeconds) * 2.0 / initTotalSeconds),
      ).animate(_animationController);
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Code Challenge #30"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatMinute(totalSeconds),
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        " : ",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        formatSeconds(totalSeconds),
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _progress,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CircleTimerPainter(
                        progress: _progress.value,
                      ),
                      size: const Size(300, 300),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onReplayPressed,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.replay_outlined,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: isRunning ? onPausePressed : onStartPressed,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade400,
                  ),
                  width: 100,
                  height: 100,
                  child: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: onStopPressed,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.stop,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircleTimerPainter extends CustomPainter {
  final double progress;

  CircleTimerPainter({
    super.repaint,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const startingAngle = -0.5 * pi;

    // draw circle
    final circlePaint = Paint()
      ..color = Colors.grey.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final circleRadius = (size.width / 2) * 0.9;

    canvas.drawCircle(
      center,
      circleRadius,
      circlePaint,
    );

    // red arc
    final redArcRect = Rect.fromCircle(
      center: center,
      radius: circleRadius,
    );

    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      progress * pi,
      false,
      redArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircleTimerPainter oldDelegate) {
    // 이전에 그릴 때의 progress 값과 지금 받은 progress값이 다른 경우에만 다시 그리기
    return oldDelegate.progress != progress;
  }
}
