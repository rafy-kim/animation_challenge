import 'dart:async';

import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 5,
    ),
  );

  final Tween<Offset> _ltrOffsetTween = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(8.0, 0.0),
  );
  final Tween<Offset> _rtlOffsetTween = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-8.0, 0.0),
  );

  late final Animation<Offset> _ltrOffsetAnimation =
      _ltrOffsetTween.animate(CurvedAnimation(
    parent: _animationController,
    curve: const Interval(
      0.0,
      0.7,
      curve: Curves.linear,
    ),
  ));
  late final Animation<Offset> _rtlOffsetAnimation =
      _rtlOffsetTween.animate(CurvedAnimation(
    parent: _animationController,
    curve: const Interval(
      0.0,
      0.7,
      curve: Curves.linear,
    ),
  ));

  late final Animation<double> _sizeAnimation = CurvedAnimation(
    parent: _animationController,
    curve: const Interval(
      0.3,
      1.0,
      curve: Curves.linear,
    ),
  );
  late final Animation<double> _fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.3,
        1.0,
        curve: Curves.linear,
      ),
    ),
  );

  bool _visible = true;
  final int _interval = 1;

  late Timer _timer;

  void _onGo() {
    _animationController.forward();
  }

  void _onReset() {
    _animationController.reset();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: _interval), (timer) {
      setState(() {
        _visible = !_visible;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Code Challenge #29"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Column(
            children: [
              BlinkRow(
                reverse: true,
                fadeAnimation: _fadeAnimation,
                sizeAnimation: _sizeAnimation,
                offsetAnimation: _rtlOffsetAnimation,
              ),
              const SizedBox(
                height: 40,
              ),
              BlinkRow(
                reverse: false,
                fadeAnimation: _fadeAnimation,
                sizeAnimation: _sizeAnimation,
                offsetAnimation: _ltrOffsetAnimation,
              ),
              const SizedBox(
                height: 40,
              ),
              BlinkRow(
                reverse: true,
                fadeAnimation: _fadeAnimation,
                sizeAnimation: _sizeAnimation,
                offsetAnimation: _rtlOffsetAnimation,
              ),
              const SizedBox(
                height: 40,
              ),
              BlinkRow(
                reverse: false,
                fadeAnimation: _fadeAnimation,
                sizeAnimation: _sizeAnimation,
                offsetAnimation: _ltrOffsetAnimation,
              ),
              const SizedBox(
                height: 40,
              ),
              BlinkRow(
                reverse: true,
                fadeAnimation: _fadeAnimation,
                sizeAnimation: _sizeAnimation,
                offsetAnimation: _rtlOffsetAnimation,
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          ElevatedButton(
            onPressed: _onGo,
            child: const Text("Go!"),
          ),
          ElevatedButton(
            onPressed: _onReset,
            child: const Text("reset"),
          ),
        ],
      ),
    );
  }
}

class BlinkRow extends StatelessWidget {
  final bool reverse;
  const BlinkRow({
    super.key,
    required Animation<double> fadeAnimation,
    required Animation<double> sizeAnimation,
    required Animation<Offset> offsetAnimation,
    required this.reverse,
  })  : _fadeAnimation = fadeAnimation,
        _sizeAnimation = sizeAnimation,
        _offsetAnimation = offsetAnimation;

  final Animation<double> _fadeAnimation;
  final Animation<double> _sizeAnimation;
  final Animation<Offset> _offsetAnimation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            color: const Color.fromARGB(255, 55, 9, 9),
            width: 360,
            height: 40,
            child: Align(
              alignment: reverse ? Alignment.topRight : Alignment.topLeft,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SizeTransition(
                  sizeFactor: _sizeAnimation,
                  axis: Axis.horizontal,
                  axisAlignment: reverse ? 1.0 : -1.0,
                  child: Container(
                    width: 360,
                    height: 40,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            color: Colors.transparent,
            width: 360,
            height: 40,
            child: Align(
              alignment: reverse ? Alignment.topRight : Alignment.topLeft,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  9,
                  (index) {
                    if (index % 2 == 0) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.transparent,
                        child: Text(index.toString()),
                      );
                    } else {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.black,
                        child: Text(index.toString()),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
