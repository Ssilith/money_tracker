import 'package:flutter/material.dart';
import 'package:money_tracker/widgets/simple_button.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final List<String> hint;
  final List<TextEditingController> controller;
  final Function() onPressed;
  final bool changeLayout;

  const InputDialog({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.title,
    required this.hint,
    this.changeLayout = false,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          if (widget.changeLayout)
            Column(
              children: [
                RowTextField(
                    nameIndex: 0,
                    surnameIndex: 1,
                    controller: widget.controller,
                    hint: widget.hint),
                const SizedBox(height: 8),
                MyTextField(
                    controller: widget.controller[2], hint: widget.hint[2]),
                const SizedBox(height: 8),
              ],
            )
          else
            for (var i = 0; i < widget.hint.length; i++)
              Column(
                children: [
                  MyTextField(
                      controller: widget.controller[i], hint: widget.hint[i]),
                  const SizedBox(height: 8),
                ],
              ),
          SimpleButton(onPressed: widget.onPressed, text: "Potwierdź"),
        ],
      ),
    );
  }
}

class RowTextField extends StatelessWidget {
  final int nameIndex;
  final int surnameIndex;
  final List<String> hint;
  final List<TextEditingController> controller;
  const RowTextField(
      {super.key,
      required this.nameIndex,
      required this.surnameIndex,
      required this.hint,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * 0.32,
            child: MyTextField(
                controller: controller[nameIndex], hint: hint[nameIndex]),
          ),
          SizedBox(
            width: size.width * 0.32,
            child: MyTextField(
                controller: controller[surnameIndex], hint: hint[surnameIndex]),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const MyTextField({super.key, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.white70)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
