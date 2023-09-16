import 'package:flutter/material.dart';

class TextInputForm extends StatelessWidget {
  final double width;
  final String hint;
  final TextEditingController controller;
  const TextInputForm({
    super.key,
    required this.width,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600),
          ),
          TextField(
            controller: controller,
            cursorColor: Theme.of(context).colorScheme.secondary,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary)),
                focusColor: Theme.of(context).colorScheme.secondary,
                border: const OutlineInputBorder(),
                hintText: hint),
          ),
        ],
      ),
    );
  }
}
