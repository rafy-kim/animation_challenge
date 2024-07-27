import 'package:animation_challenge/screens/custom_paint_screen.dart';
import 'package:animation_challenge/screens/explicit_animations_screen.dart';
import 'package:animation_challenge/final/views/final_screen.dart';
import 'package:animation_challenge/screens/implicit_animations_screen.dart';
import 'package:animation_challenge/screens/swiping_cards_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Animations"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ImplicitAnimationsScreen(),
                );
              },
              child: const Text("Code Challenge #28"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ExplicitAnimationsScreen(),
                );
              },
              child: const Text("Code Challenge #29"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const CustomPaintScreen(),
                );
              },
              child: const Text("Code Challenge #30"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const SwipingCardsScreen(),
                );
              },
              child: const Text("Code Challenge #31"),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const FinalScreen(),
                );
              },
              child: const Text("Final Code Challenge"),
            ),
          ],
        ),
      ),
    );
  }
}
