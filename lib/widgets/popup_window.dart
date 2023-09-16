import 'package:flutter/material.dart';
import 'package:money_tracker/widgets/simple_button.dart';

class PopupWindow extends StatelessWidget {
  final String title;
  final String message;
  final Function() onPressed;
  const PopupWindow({
    super.key,
    required this.title,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            height: 0.5,
            color: Colors.white70),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SimpleButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: "Anuluj",
                  width: 125),
              const SizedBox(
                width: 5,
              ),
              SimpleButton(onPressed: onPressed, text: "Potwierdź", width: 125),
            ],
          ),
        ],
      ),
    );
  }
}
