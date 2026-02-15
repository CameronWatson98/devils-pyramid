import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wraps a widget with visual feedback animations based on state
class FeedbackWrapper extends StatelessWidget {
  final Widget child;
  final bool triggerShake;
  final bool triggerCelebrate;

  const FeedbackWrapper({
    super.key,
    required this.child,
    this.triggerShake = false,
    this.triggerCelebrate = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    // Add shake animation for errors
    if (triggerShake) {
      result = result
          .animate(key: ValueKey('shake_$triggerShake'))
          .shake(
            duration: 400.ms,
            hz: 4,
            curve: Curves.easeInOut,
          )
          .tint(
            duration: 300.ms,
            color: Colors.red.withOpacity(0.3),
          );
    }

    // Add celebration pulse for success
    if (triggerCelebrate) {
      result = result
          .animate(key: ValueKey('celebrate_$triggerCelebrate'))
          .scale(
            duration: 200.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            curve: Curves.easeOut,
          )
          .then()
          .scale(
            duration: 150.ms,
            begin: const Offset(1.05, 1.05),
            end: const Offset(1.0, 1.0),
          )
          .shimmer(
            duration: 600.ms,
            color: Colors.green.withOpacity(0.5),
          );
    }

    return result;
  }
}
