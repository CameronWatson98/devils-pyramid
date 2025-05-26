import 'dart:math';

import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:devils_pyramid/widgets/hexagon_button.dart';
import 'package:flutter/material.dart';

class PyramidLayout extends StatelessWidget {
  const PyramidLayout({
    super.key,
    required this.itemHeight,
    required this.options,
  });

  final double itemHeight;
  final List<NumberWithSymbol> options;

  @override
  Widget build(BuildContext context) {
    var optionsRemaining = List.from(options);
    return Stack(
      children: List.generate(
        4,
        (i) => Transform.translate(
          offset: Offset(0, i * (sqrt(3) * itemHeight / 2)),
          child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.filled(
              i + 1,
              HexagonButton(
                height: itemHeight,
                option: optionsRemaining.removeAt(0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
