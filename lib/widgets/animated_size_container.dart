import 'package:flutter/material.dart';

class AnimatedSizeContainer extends StatelessWidget {
  const AnimatedSizeContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
