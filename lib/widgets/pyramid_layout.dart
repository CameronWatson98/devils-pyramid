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
    final double totalHeight = 3 * (sqrt(3) * itemHeight / 2) + itemHeight;
    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: List.generate(
          4,
          (i) => Transform.translate(
            offset: Offset(0, i * (itemHeight - 10)),
            child: Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                i + 1,
                (i) => HexagonButton(
                  size: itemHeight,
                  option: optionsRemaining.removeAt(0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
