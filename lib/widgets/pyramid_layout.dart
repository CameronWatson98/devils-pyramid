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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (rowIndex) => Transform.translate(
          offset: Offset(0, -10.0 * rowIndex),
          child: Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              rowIndex + 1,
              (buttonIndex) => HexagonButton(
                size: itemHeight,
                option: optionsRemaining.removeAt(0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
