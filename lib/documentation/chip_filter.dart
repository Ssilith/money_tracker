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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => callback(),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 236, 242, 254)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: isSelected ? 2 : 1)),
          child: Row(
            children: [
              Text(filterData['name'],
                  style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary))
            ],
          ),
        ),
      ),
    );
  }
}

List chipFilterList = [
  {"name": "Wystawca"},
  {"name": "Miesiąc"},
  {"name": "Rodzaj"},
  {"name": "Pożyczki"},
  {"name": "Podatki"},
];
