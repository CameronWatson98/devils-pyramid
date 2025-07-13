import 'dart:math';

import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:devils_pyramid/styles/theme.dart';
import 'package:devils_pyramid/widgets/animated_size_container.dart';
import 'package:devils_pyramid/widgets/pyramid_layout.dart';
import 'package:devils_pyramid/widgets/rounded_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      home: Scaffold(
        body: BlocProvider(
          create: (context) => EquationPyramidCubit(),
          child: const MainView(),
        ),
      ),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<EquationPyramidCubit>(
      context,
    ).createNewGame(initialNumber: Random().nextInt(20));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 40,
      children: [
        BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
          builder: (context, state) {
            return AnimatedSizeContainer(
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
                              color: Theme.of(context).colorScheme.surfaceDim,
                              child: Center(
                                child: Text(
                                  'Target',
                                  style: Theme.of(context).textTheme.bodyLarge!
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
            );
          },
        ),
        BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
          builder: (context, state) {
            var options = state.options;
            return PyramidLayout(itemHeight: 100, options: options);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            RoundedTextButton(
              text: 'Shuffle',
              onPressed: () {
                BlocProvider.of<EquationPyramidCubit>(context).shuffleOptions();
              },
            ),
            BlocSelector<
              EquationPyramidCubit,
              EquationPyramidState,
              List<NumberWithSymbol>
            >(
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
            BlocSelector<
              EquationPyramidCubit,
              EquationPyramidState,
              List<NumberWithSymbol>
            >(
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
