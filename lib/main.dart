import 'dart:math';

import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
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
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: options.map((option) {
                return TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: state.selectedOptions.contains(option)
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  onPressed: () {
                    if (state.selectedOptions.contains(option)) {
                      // If already selected, remove it
                      BlocProvider.of<EquationPyramidCubit>(
                        context,
                      ).removeSelection(option);
                    } else if (state.selectedOptions.length < 3) {
                      // If not selected and less than 3 options, add it
                      BlocProvider.of<EquationPyramidCubit>(
                        context,
                      ).addSelection(option);
                    }
                  },
                  child: Text(option.symbol + option.number.toString()),
                );
              }).toList(),
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
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: state.asMap().entries.map((entry) {
                int index = entry.key;
                NumberWithSymbol option = entry.value;
                return Text(
                  index == 0
                      ? option.number.toString()
                      : ' ${option.symbol} ${option.number}',
                );
              }).toList(),
            );
          },
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<EquationPyramidCubit>(context).checkSolution();
          },
          child: Text('Check Solution'),
        ),
      ],
    );
  }
}
