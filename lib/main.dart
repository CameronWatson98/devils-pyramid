import 'dart:math';

import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:devils_pyramid/widgets/pyramid_layout.dart';
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
      theme: ThemeData.dark(),
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
      spacing: 20,
      children: [
        BlocSelector<EquationPyramidCubit, EquationPyramidState, int>(
          selector: (state) {
            return state.initialNumber;
          },
          builder: (context, state) {
            return Text(state.toString());
          },
        ),
        BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
          builder: (context, state) {
            var options = state.options;
            return PyramidLayout(itemHeight: 100, options: options);
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
            return Text(equationToString(selectedOptions));
          },
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<EquationPyramidCubit>(context).checkSolution();
          },
          child: Text('Check Solution'),
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
        concat += ' ${equation[i].symbol} ';
      }
      concat += equation[i].number.toString();
    }

    return concat;
  }
}
