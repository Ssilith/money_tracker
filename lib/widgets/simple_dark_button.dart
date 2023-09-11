import 'package:flutter/material.dart';

class SimpleDarkButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Color? buttonColor;
  final Color textColor;
  final double width;
  const SimpleDarkButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.buttonColor,
      this.textColor = Colors.white,
      this.width = 130});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  buttonColor ?? Theme.of(context).colorScheme.secondary,
            ),
            onPressed: onPressed,
            child: Text(title, style: TextStyle(color: textColor))));
  }
}
