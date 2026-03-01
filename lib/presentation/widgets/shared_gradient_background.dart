import 'package:flutter/material.dart';

class SharedGradientBackground extends StatelessWidget {
  final Widget child;
  const SharedGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE0F2F1), // Very Light Teal/Blue
            Colors.white,
          ],
        ),
      ),
      child: child,
    );
  }
}
