import 'package:devils_pyramid/bloc/equation_pyramid_cubit.dart';
import 'package:devils_pyramid/models/number_with_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        final Color containerColour = isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface;
        return SizedBox(
          height: size,
          width: size,
          child: ClipPath.shape(
            clipBehavior: Clip.antiAlias,
            shape: PolygonBorder(
              polygon: RegularConvexPolygon(vertexCount: 6),
              turn: 0.25,
              radius: 6,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color: containerColour,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  // Haptic feedback on tap
                  HapticFeedback.lightImpact();

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
                child: Text(
                  option.toString(),
                  style: TextStyle().copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        )
            .animate(
              key: ValueKey(isSelected),
            )
            .scale(
              duration: 200.ms,
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              curve: Curves.easeOutBack,
            )
            .then()
            .scale(
              duration: 150.ms,
              begin: const Offset(1.1, 1.1),
              end: const Offset(1.0, 1.0),
            );
      },
    );
  }
}
