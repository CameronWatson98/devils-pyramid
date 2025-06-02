import 'dart:math';

import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HexagonButton extends StatelessWidget {
  const HexagonButton({super.key, required this.height, required this.option});

  final double height;
  final NumberWithSymbol option;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquationPyramidCubit, EquationPyramidState>(
      builder: (context, state) {
        return SizedBox(
          height: height, // diagonal
          width:
              sqrt(3) * height / 2, // the ratio of height : diagonal is √3 : 2
          child: GestureDetector(
            onTap: () {
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
            child: CustomPaint(
              painter: HexagonPainter(),
              child: Center(child: Text(option.number.toString())),
            ),
          ),
        );
      },
    );
  }
}

class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // We'll draw here
    final paint = Paint();
    paint.color = Colors.teal;
    paint.style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0);
    path.lineTo(size.width * 1, size.height * 1 / 4);
    path.lineTo(size.width * 1, size.height * 3 / 4);
    path.lineTo(size.width * 0.5, size.height * 1);
    path.lineTo(size.width * 0, size.height * 3 / 4);
    path.lineTo(size.width * 0, size.height * 1 / 4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
