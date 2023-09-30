import 'package:flutter/material.dart';

class TilesTitle extends StatefulWidget {
  const TilesTitle({super.key});

  @override
  State<TilesTitle> createState() => _TilesTitleState();
}

class _TilesTitleState extends State<TilesTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Tablica",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary)),
          TextButton(
              onPressed: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (_) => const OnboardingPages()),
                // );
              },
              child: const Text(
                "Dostosuj",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ))
        ],
      ),
    );
  }
}
