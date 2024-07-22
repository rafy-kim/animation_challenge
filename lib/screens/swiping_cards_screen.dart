import 'dart:math';
import 'package:flutter/material.dart';

List<String> questions = [
  "Who created Helvetica?",
  "What year was Helvetica released?",
  "Q3",
  "Q4",
  "Q5",
  "Q6",
  "Q7",
  "Q8",
  "Q9",
  "Q10",
];

List<String> answers = [
  "Max Miedinger with Eduard Hoffmann",
  "1957",
  "A3",
  "A4",
  "A5",
  "A6",
  "A7",
  "A8",
  "A9",
  "A10",
];

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with TickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  late final Tween<double> _opacity = Tween(
    begin: 0,
    end: 1,
  );

  late final _colorLeft = ColorTween(
    begin: Colors.blue.shade300,
    end: Colors.red.shade300,
  );
  late final _colorRight = ColorTween(
    begin: Colors.blue.shade300,
    end: Colors.green.shade300,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _whenComplete() {
    _position.value = 0;
    _progressController.animateTo(_progressController.value + 0.1);
    // TODO: answer mode에서 넘어갈 경우, 다시 flip
    setState(() {
      _index = _index == 10 ? 1 : _index + 1;
      _isQ = true;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;

    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(
            dropZone * factor,
            curve: Curves.easeOut,
          )
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    _progressController.dispose();
    super.dispose();
  }

  int _index = 1;
  bool _isQ = true;
  bool _isFlip = true;
  bool _isVisible = true;

  void _toggleQ() {
    setState(() {
      _isVisible = false;
      _isQ = !_isQ;
      _isFlip = !_isFlip;
    });
  }

  Color _clampedColor(ColorTween tween, double value) {
    final clampedValue = value.clamp(0.0, 1.0);
    return tween.transform(clampedValue)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swiping Cards"),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation
                  .transform((_position.value + size.width / 2) / size.width) *
              pi /
              180;
          final scale = _scale.transform(_position.value.abs() / size.width);
          final opacity =
              _opacity.transform(_position.value.abs() * 3 / size.width);

          final normalizedValue = _position.value.abs() * 10 / size.width;
          final color = _position.value < 0
              ? _clampedColor(_colorLeft, normalizedValue)
              : _clampedColor(_colorRight, normalizedValue);

          final desc = _position.value == 0
              ? ""
              : _position.value < 0
                  ? "Need to review"
                  : "I got it right";
          print(_isQ);

          return Container(
            color: color,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 50,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: min(opacity * 3, 1.0),
                    child: Text(
                      desc,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: min(opacity, 1.0),
                      child: Card(
                        index: _index == 10 ? 1 : _index + 1,
                        isQ: true,
                        isVisible: true,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: GestureDetector(
                    onTap: _toggleQ,
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: Transform.translate(
                      offset: Offset(_position.value, 0),
                      child: Transform.rotate(
                        angle: angle,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          transform: Matrix4.rotationY(_isFlip ? pi : 0),
                          transformAlignment: Alignment.center,
                          child: Transform(
                            transform: Matrix4.rotationY(_isFlip ? pi : 0),
                            alignment: Alignment.center,
                            child: Card(
                              key: ValueKey("$_index-$_isQ"),
                              index: _index,
                              isQ: _isQ,
                              isVisible: _isVisible,
                            ),
                          ),
                          onEnd: () {
                            setState(() {
                              _isVisible = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) => CustomPaint(
                      size: Size(size.width - 80, 10),
                      painter: ProgressBar(
                        progressValue: _progressController.value,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;
  final bool isQ;
  final bool isVisible;

  const Card({
    super.key,
    required this.index,
    required this.isQ,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.hardEdge,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isVisible ? 1.0 : 0,
          child: Text(
            isQ ? questions[index - 1] : answers[index - 1],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({
    super.repaint,
    required this.progressValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;
    // track
    final trackPaint = Paint()
      ..color = Colors.grey.shade800.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );
    canvas.drawRRect(trackRRect, trackPaint);

    // progress
    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final progressRRrect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );
    canvas.drawRRect(progressRRrect, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}
