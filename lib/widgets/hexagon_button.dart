import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygon/polygon.dart';

class HexagonButton extends StatelessWidget {
  const HexagonButton({super.key, required this.size, required this.option});

  final double size;
  final NumberWithSymbol option;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
      builder: (context, state) {
        var isSelected = state.selectedOptions.contains(option);
        return SizedBox(
          height: size,
          width: size,
          child: ClipPath.shape(
            shape: PolygonBorder(
              polygon: RegularConvexPolygon(vertexCount: 6),
              turn: 0.25,
              radius: 6,
            ),
            child: ElevatedButton(
              onPressed: () {
                if (isSelected) {
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
              child: Text(option.toString()),
            ),
          ),
        );
      },
    );
  }
}
