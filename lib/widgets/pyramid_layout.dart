import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:devils_pyramid/widgets/hexagon_button.dart';
import 'package:flutter/material.dart';

class PyramidLayout extends StatelessWidget {
  const PyramidLayout({super.key, required this.options});

  final List<NumberWithSymbol> options;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 4.0;
        const horizontalPadding = 32.0;
        // Bottom row has 4 hexagons — fit them within available width
        final hexSize =
            (constraints.maxWidth - horizontalPadding - (3 * spacing)) / 4;
        final overlap = hexSize * 0.10;

        var optionsRemaining = List.from(options);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            4,
            (rowIndex) => Transform.translate(
              offset: Offset(0, -overlap * rowIndex),
              child: Row(
                spacing: spacing,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  rowIndex + 1,
                  (buttonIndex) => HexagonButton(
                    size: hexSize,
                    option: optionsRemaining.removeAt(0),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
