import 'package:flutter/material.dart';

class RoundedTextButton extends StatelessWidget {
  const RoundedTextButton({super.key, this.onPressed, required this.text});

  final Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: onPressed == null
            ? Theme.of(context).colorScheme.surfaceDim
            : Theme.of(context).colorScheme.onSurface,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: onPressed == null
                ? Theme.of(context).colorScheme.surfaceDim
                : Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadiusGeometry.circular(40),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
