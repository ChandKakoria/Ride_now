import 'package:flutter/material.dart';
import 'dart:ui';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF003B4D), // Deep Navy
                  Color(0xFF00A3E0), // Sky Blue
                ],
              ),
            ),
          ),
          ..._buildCircles(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCircles() => [
    Positioned(
      top: -50,
      left: -50,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    ),
    Positioned(
      bottom: -50,
      right: -50,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    ),
  ];
}
