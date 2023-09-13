import 'package:flutter/material.dart';

class ChipFilter extends StatelessWidget {
  final VoidCallback callback;
  final bool isSelected;
  final Map filterData;
  const ChipFilter(
      {super.key,
      required this.filterData,
      required this.callback,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: () => callback(),
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary, width: 2)),
            child: Text(filterData['name'],
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary))),
      ),
    );
  }
}
