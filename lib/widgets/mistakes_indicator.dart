import 'package:flutter/material.dart';

/// Shows remaining mistakes as animated circles
class MistakesIndicator extends StatelessWidget {
  final int mistakesMade;
  final int maxMistakes;

  const MistakesIndicator({
    super.key,
    required this.mistakesMade,
    required this.maxMistakes,
  });

  @override
  Widget build(BuildContext context) {
    final mistakesRemaining = maxMistakes - mistakesMade;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Mistakes remaining: ',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(maxMistakes, (index) {
            final isRemaining = index < mistakesRemaining;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedScale(
                scale: isRemaining ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: isRemaining ? Curves.elasticOut : Curves.easeInBack,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
