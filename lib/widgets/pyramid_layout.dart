import 'dart:math';

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
        const overlapRatio = 0.10;
        const rows = 4;

        // hexSize based on available width
        final hexSizeByWidth = (constraints.maxWidth - (3 * spacing)) / rows;

        // hexSize based on available height — layout height = hexSize * (rows - (rows-1)*overlapRatio)
        final heightRatio = rows - (rows - 1) * overlapRatio; // = 3.7
        final hexSizeByHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight / heightRatio
            : hexSizeByWidth;

        final hexSize = min(hexSizeByWidth, hexSizeByHeight);
        final overlap = hexSize * overlapRatio;

        var optionsRemaining = List.from(options);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(rows, (rowIndex) {
            final isLastRow = rowIndex == rows - 1;
            // Each row's layout height = hexSize - overlap, except the last.
            // Rows visually paint into the next row's space creating the overlap effect.
            return SizedBox(
              height: isLastRow ? hexSize : hexSize - overlap,
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
            );
          }),
        );
      },
    );
  }
}
