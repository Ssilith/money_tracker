import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double width;
  const SimpleButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width = 130});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ));
  }
}
