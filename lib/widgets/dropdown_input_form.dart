import 'package:flutter/material.dart';

class DropdownInputForm extends StatefulWidget {
  final double width;
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;
  final String? selectedValue;

  const DropdownInputForm({
    super.key,
    required this.width,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.selectedValue,
  });

  @override
  State<DropdownInputForm> createState() => _DropdownInputFormState();
}

class _DropdownInputFormState extends State<DropdownInputForm> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hint,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600),
          ),
          Container(
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.selectedValue,
                isExpanded: true,
                onChanged: widget.onChanged,
                items: widget.items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(widget.hint),
                dropdownColor: Theme.of(context).canvasColor,
                iconEnabledColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
