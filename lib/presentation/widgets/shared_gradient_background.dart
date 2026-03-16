import 'package:flutter/material.dart';

class SharedGradientBackground extends StatelessWidget {
  final Widget child;
  const SharedGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : null,
        gradient: Theme.of(context).brightness == Brightness.dark
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFCE4EC), // Solid light pink
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
      ),
      child: child,
    );
  }
}
