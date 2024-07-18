import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _durationEditingController =
      TextEditingController();
  int _duration = 500;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: _duration,
    ),
  )..addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _toggleVisible();
          _animationController.reset();
          _animationController.forward();
        }
      },
    );

  late bool _visible = false;

  void _toggleVisible() {
    setState(() {
      _visible = !_visible;
    });
  }

  void _reset() {
    setState(() {
      _playing = false;
    });
    _animationController.reset();
  }

  bool _playing = false;
  void _togglePlay() {
    if (_playing) {
      _animationController.stop();
    } else {
      _animationController.forward();
    }
    setState(() {
      _playing = !_playing;
    });
  }

  @override
  void initState() {
    super.initState();
    _durationEditingController.text = "500";
    _durationEditingController.addListener(() {
      setState(() {
        try {
          _duration = int.parse(_durationEditingController.text);
        } catch (e) {
          _duration = 500;
        }
      });
      // _animationController.reset();
      _animationController.duration = Duration(milliseconds: _duration);
      print(_duration);
    });
  }

  @override
  void dispose() {
    _durationEditingController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                visible: _visible,
                reverse: true,
                animationController: _animationController,
                start: 0.8,
                end: 1.0,
              ),
              const SizedBox(
                height: 40,
              ),
              BlinkRow(
                visible: _visible,
                reverse: false,
                animationController: _animationController,
                start: 0.6,
                end: 0.8,
              ),
              const SizedBox(
                height: 40,
              ),
              BlinkRow(
                visible: _visible,
                reverse: true,
                animationController: _animationController,
                start: 0.4,
                end: 0.6,
              ),
              const SizedBox(
                height: 40,
              ),
              BlinkRow(
                visible: _visible,
                reverse: false,
                animationController: _animationController,
                start: 0.2,
                end: 0.4,
              ),
              const SizedBox(
                height: 40,
              ),
              BlinkRow(
                visible: _visible,
                reverse: true,
                animationController: _animationController,
                start: 0.0,
                end: 0.2,
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 160,
            child: TextField(
              controller: _durationEditingController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 5,
              decoration: const InputDecoration(
                labelText: "Duration (milliseconds)",
                labelStyle: TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _togglePlay,
                child: Text(!_playing ? "Play" : "Stop"),
              ),
              ElevatedButton(
                onPressed: _reset,
                child: const Text("Reset"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BlinkRow extends StatefulWidget {
  final bool visible;
  final bool reverse;
  final double start;
  final double end;

  const BlinkRow({
    super.key,
    required AnimationController animationController,
    required this.reverse,
    required this.start,
    required this.end,
    required this.visible,
  }) : _animationController = animationController;

  final AnimationController _animationController;

  @override
  State<BlinkRow> createState() => _BlinkRowState();
}

class _BlinkRowState extends State<BlinkRow> {
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(widget.reverse ? -1.0 : 1.0, 0),
    end: Offset(widget.reverse ? -8.0 : 8.0, 0.0),
  ).animate(CurvedAnimation(
    parent: widget._animationController,
    curve: Interval(
      widget.start,
      widget.end,
      curve: Curves.linear,
    ),
  ));

  late final Animation<double> _sizeAnimation = CurvedAnimation(
    parent: widget._animationController,
    curve: Interval(
      widget.start,
      widget.end,
      curve: Curves.linear,
    ),
  );
  late final Animation<double> _fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: widget._animationController,
      curve: Interval(
        widget.start,
        widget.end,
        curve: Curves.linear,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            color: widget.visible
                ? Colors.red.shade400
                : const Color.fromARGB(255, 40, 8, 8),
            width: 360,
            height: 40,
            child: Align(
              alignment:
                  widget.reverse ? Alignment.topRight : Alignment.topLeft,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SizeTransition(
                  sizeFactor: _sizeAnimation,
                  axis: Axis.horizontal,
                  axisAlignment: widget.reverse ? 1.0 : -1.0,
                  child: Container(
                    width: 360,
                    height: 40,
                    color: !widget.visible
                        ? Colors.red.shade400
                        : const Color.fromARGB(255, 40, 8, 8),
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
              alignment:
                  widget.reverse ? Alignment.topRight : Alignment.topLeft,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  width: 40,
                  height: 40,
                  color: !widget.visible
                      ? Colors.red.shade400
                      : const Color.fromARGB(255, 40, 8, 8),
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
                        // child: Text(index.toString()),
                      );
                    } else {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.black,
                        // child: Text(index.toString()),
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
