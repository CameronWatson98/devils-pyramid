import 'dart:math';

import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/config/feature_flags.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:devils_pyramid/widgets/animated_size_container.dart';
import 'package:devils_pyramid/widgets/live_calculation.dart';
import 'package:devils_pyramid/widgets/mistakes_indicator.dart';
import 'package:devils_pyramid/widgets/pyramid_layout.dart';
import 'package:devils_pyramid/widgets/rounded_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, this.isDaily = false});

  final bool isDaily;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();

    if (widget.isDaily) {
      _initializeDailyMode();
    } else {
      _initializePlayMode();
    }
  }

  Future<void> _initializeDailyMode() async {
    // Storage is now injected into the cubit
    await context.read<EquationPyramidCubit>().initializeDailyChallenge();
  }

  void _initializePlayMode() {
    context.read<EquationPyramidCubit>().createNewGame(
      initialNumber: Random().nextInt(20) + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isDaily
            ? Row(
                children: [
                  const Text('Devil\'s Pyramid '),
                  Text(
                    _formatDate(DateTime.now()),
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              )
            : Text('Devil\'s Pyramid'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
                builder: (context, state) {
                  return Column(
                    spacing: 12,
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AnimatedSizeContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Target number
                                      Text(
                                        'Target: ${state.initialNumber}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.7),
                                            ),
                                      ),
                                      // Live calculation display
                                      LiveCalculation(
                                        selectedOptions: state.selectedOptions,
                                        targetNumber: state.initialNumber,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Show completion indicator for daily challenge
                      if (state.isDaily && state.correctSolutions.length >= 3)
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '🎉 Daily Challenge Complete! ${state.correctSolutions.length}/3 solutions found in ${state.totalAttempts} attempts',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      // Show game over message when out of attempts
                      if (state.isGameOver)
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '❌ Game Over! You found ${state.correctSolutions.length}/3 solutions',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
                  builder: (context, state) =>
                      PyramidLayout(options: state.options),
                ),
              ),

              BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
                builder: (context, state) => MistakesIndicator(
                  mistakesMade:
                      state.totalAttempts - state.correctSolutions.length,
                  maxMistakes: state.maxAttempts,
                ),
              ),

              BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
                builder: (context, state) {
                  final featureFlags = FeatureFlags.instance;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      if (featureFlags.shuffleEnabled)
                        Expanded(
                          child: RoundedTextButton(
                            text: 'Shuffle',
                            onPressed: () {
                              BlocProvider.of<EquationPyramidCubit>(
                                context,
                              ).shuffleOptions();
                            },
                          ),
                        ),
                      BlocSelector<
                        EquationPyramidCubit,
                        EquationPyramidState,
                        List<NumberWithSymbol>
                      >(
                        selector: (state) => state.selectedOptions,
                        builder: (context, selectedOptions) {
                          return Expanded(
                            child: RoundedTextButton(
                              text: 'Deselect All',
                              onPressed: selectedOptions.isNotEmpty
                                  ? () => BlocProvider.of<EquationPyramidCubit>(
                                      context,
                                    ).resetSelections()
                                  : null,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
                        builder: (context, state) {
                          final canSubmit =
                              state.selectedOptions.length == 3 &&
                              !state.isGameOver;
                          return Expanded(
                            child: RoundedTextButton(
                              text: 'Submit',
                              onPressed: canSubmit
                                  ? () => BlocProvider.of<EquationPyramidCubit>(
                                      context,
                                    ).checkSolution()
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String equationToString(List<NumberWithSymbol> equation) {
    String concat = '';
    for (int i = 0; i < equation.length; i++) {
      if (i > 0) {
        concat += ' ${equation[i].toString()} ';
      } else {
        concat += equation[i].number.toString();
      }
    }

    return concat;
  }
}
