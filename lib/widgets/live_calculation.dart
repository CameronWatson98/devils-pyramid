import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shows live calculation as the user builds their equation
class LiveCalculation extends StatelessWidget {
  final List<NumberWithSymbol> selectedOptions;
  final int targetNumber;

  const LiveCalculation({
    super.key,
    required this.selectedOptions,
    required this.targetNumber,
  });

  /// Calculate the current result based on selected options
  int? get currentResult {
    if (selectedOptions.isEmpty) return null;

    int result = selectedOptions[0].number;
    for (int i = 1; i < selectedOptions.length; i++) {
      switch (selectedOptions[i].symbol) {
        case '+':
          result += selectedOptions[i].number;
          break;
        case '-':
          result -= selectedOptions[i].number;
          break;
        case 'x':
          result *= selectedOptions[i].number;
          break;
        case '/':
          if (selectedOptions[i].number == 0) return null;
          result ~/= selectedOptions[i].number;
          break;
      }
    }
    return result;
  }

  /// Get color based on how close we are to the target
  Color _getResultColor(BuildContext context, int result) {
    if (selectedOptions.length < 3) {
      return Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
    }

    final difference = (result - targetNumber).abs();
    if (difference == 0) {
      return Colors.green;
    } else if (difference <= 3) {
      return Colors.orange;
    } else {
      return Colors.red.shade300;
    }
  }

  /// Build the equation string with intermediate results
  String _buildEquationString() {
    if (selectedOptions.isEmpty) return '';

    String equation = selectedOptions[0].number.toString();

    int runningTotal = selectedOptions[0].number;
    for (int i = 1; i < selectedOptions.length; i++) {
      final symbol = selectedOptions[i].symbol;
      final num = selectedOptions[i].number;

      // Add the operation
      String prettySymbol = symbol == 'x'
          ? '×'
          : (symbol == '/' ? '÷' : symbol);
      equation += ' $prettySymbol $num';

      // Calculate new total
      switch (symbol) {
        case '+':
          runningTotal += num;
          break;
        case '-':
          runningTotal -= num;
          break;
        case 'x':
          runningTotal *= num;
          break;
        case '/':
          if (num != 0) runningTotal ~/= num;
          break;
      }

      // Show intermediate result if not the last operation
      if (i < selectedOptions.length - 1) {
        equation += ' = $runningTotal';
      }
    }

    return equation;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    final result = currentResult;
    final equationString = _buildEquationString();

    return Column(
      children: [
        // Equation string
        Text(
              equationString,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 200.ms)
            .slideY(begin: -0.3, end: 0, curve: Curves.easeOut),

        const SizedBox(height: 8),

        // Current result (if we have 2+ selections)
        if (result != null && selectedOptions.length >= 2)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                    '= $result',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: _getResultColor(context, result),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(
                    duration: 300.ms,
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(width: 12),
            ],
          ),
      ],
    );
  }
}
