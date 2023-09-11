import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class BalanceBox extends StatefulWidget {
  const BalanceBox({super.key});

  @override
  State<BalanceBox> createState() => _BalanceBoxState();
}

class _BalanceBoxState extends State<BalanceBox> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).colorScheme.secondary,
            ),
            width: size.width,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Saldo konta",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16)),
                      const Text("11247109 zł",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Divider(color: Colors.white.withOpacity(0.2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Podsumowanie",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text("Ostatnie 7 dni",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: ClipPath(
              clipper: WaveClipperTwo(reverse: true),
              child: Container(
                color: const Color.fromARGB(136, 34, 81, 113),
                width: size.width,
                height: 120,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClipPath(
              clipper: WaveClipperOne(reverse: true),
              child: Container(
                height: 100,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(34.0)),
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
