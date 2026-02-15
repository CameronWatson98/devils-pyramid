import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shows a celebration overlay when a correct solution is found
class CelebrationOverlay extends StatelessWidget {
  final bool show;
  final VoidCallback onComplete;

  const CelebrationOverlay({
    super.key,
    required this.show,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return IgnorePointer(
      child: Stack(
        children: [
          // Success message
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Correct!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            )
                .animate(onComplete: (controller) => onComplete())
                .scale(
                  duration: 300.ms,
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.1, 1.1),
                  curve: Curves.elasticOut,
                )
                .then()
                .scale(
                  duration: 150.ms,
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1.0, 1.0),
                )
                .fadeOut(
                  duration: 200.ms,
                  delay: 800.ms,
                ),
          ),

          // Confetti particles
          ...List.generate(20, (index) {
            final random = index * 17; // Pseudo-random for consistent animation
            final startX = (random % 100) / 100.0;
            final endY = 1.0 + (random % 50) / 100.0;
            final rotation = (random % 360) * 3.14159 / 180;
            final color = [
              Colors.yellow,
              Colors.orange,
              Colors.pink,
              Colors.purple,
              Colors.blue,
              Colors.green,
            ][random % 6];

            return Positioned(
              left: MediaQuery.of(context).size.width * startX,
              top: -20,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              )
                  .animate()
                  .moveY(
                    duration: (1000 + random % 500).ms,
                    begin: 0,
                    end: MediaQuery.of(context).size.height * endY,
                    curve: Curves.easeIn,
                  )
                  .rotate(
                    duration: (800 + random % 400).ms,
                    begin: 0,
                    end: rotation,
                  )
                  .fadeOut(
                    duration: 200.ms,
                    delay: (800 + random % 300).ms,
                  ),
            );
          }),
        ],
      ),
    );
  }
}
