import 'dart:math';

import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/config/feature_flags.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:devils_pyramid/widgets/animated_size_container.dart';
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
        title: Text(widget.isDaily ? 'Daily Challenge' : 'Play'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
            builder: (context, state) {
              return Column(
                spacing: 12,
                children: [
                  AnimatedSizeContainer(
                    child: IntrinsicWidth(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    color:
                                        Theme.of(context).colorScheme.surfaceDim,
                                    child: Center(
                                      child: Text(
                                        'Target',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (state.selectedOptions.isNotEmpty)
                                    Text(
                                      equationToString(state.selectedOptions),
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  Text(
                                    state.initialNumber.toString(),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                ],
              );
            },
          ),
          BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
            builder: (context, state) {
              var options = state.options;
              return PyramidLayout(itemHeight: 100, options: options);
            },
          ),
          BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
            builder: (context, state) {
              final featureFlags = FeatureFlags.instance;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  if (featureFlags.shuffleEnabled)
                    RoundedTextButton(
                      text: 'Shuffle',
                      onPressed: () {
                        BlocProvider.of<EquationPyramidCubit>(context)
                            .shuffleOptions();
                      },
                    ),
                  BlocSelector<EquationPyramidCubit, EquationPyramidState,
                      List<NumberWithSymbol>>(
                    selector: (state) {
                      return state.selectedOptions;
                    },
                    builder: (context, selectedOptions) {
                      return RoundedTextButton(
                        text: 'Deselect All',
                        onPressed: selectedOptions.isNotEmpty
                            ? () {
                                BlocProvider.of<EquationPyramidCubit>(
                                  context,
                                ).resetSelections();
                              }
                            : null,
                      );
                    },
                  ),
                  BlocSelector<EquationPyramidCubit, EquationPyramidState,
                      List<NumberWithSymbol>>(
                    selector: (state) {
                      return state.selectedOptions;
                    },
                    builder: (context, selectedOptions) {
                      return RoundedTextButton(
                        text: 'Submit',
                        onPressed: selectedOptions.length == 3
                            ? () {
                                BlocProvider.of<EquationPyramidCubit>(
                                  context,
                                ).checkSolution();
                              }
                            : null,
                      );
                    },
                  ),
                ],
              );
            },
          ),
          BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Column(
                    children: state.attemptedSolutions.map((solution) {
                      return Text(equationToString(solution));
                    }).toList(),
                  ),
                  Column(
                    children: state.correctSolutions.map((solution) {
                      return Text(
                        equationToString(solution),
                        style: const TextStyle(color: Colors.green),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
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
