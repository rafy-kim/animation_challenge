import 'dart:async';

import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;
  final int _interval = 1;

  late Timer _timer;

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
      backgroundColor: _visible ? Colors.white : const Color(0xff222222),
      appBar: AppBar(
        title: const Text("Code Challenge #28"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius:
                    BorderRadius.circular(_visible ? size.width / 2 : 0),
              ),
              child: AnimatedAlign(
                // curve: Curves.elasticOut,
                duration: Duration(seconds: _interval),
                alignment: _visible ? Alignment.topLeft : Alignment.topRight,
                child: Container(
                  width: 15,
                  color: !_visible ? Colors.white : const Color(0xff222222),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // ElevatedButton(
            //   onPressed: _trigger,
            //   child: const Text("Go!"),
            // ),
          ],
        ),
      ),
    );
  }
}
