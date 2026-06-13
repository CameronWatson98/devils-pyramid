import 'package:flutter/material.dart';

class RoundedTextButton extends StatelessWidget {
  const RoundedTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.inverted = false,
  });

  final Function()? onPressed;
  final String text;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final borderColor = isDisabled
        ? Theme.of(context).colorScheme.surfaceDim
        : Theme.of(context).colorScheme.onSurface;

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: inverted && !isDisabled
            ? Theme.of(context).colorScheme.surface
            : borderColor,
        backgroundColor: inverted && !isDisabled
            ? Theme.of(context).colorScheme.onSurface
            : null,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: borderColor),
          borderRadius: BorderRadiusGeometry.circular(40),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
