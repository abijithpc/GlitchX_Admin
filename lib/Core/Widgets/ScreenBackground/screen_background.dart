// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ScreenBackGround extends StatelessWidget {
  ScreenBackGround({
    required this.widget,
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;
  Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.1, 0.9],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color.fromARGB(255, 102, 102, 102), Colors.black],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: widget,
        ),
      ),
    );
  }
}
