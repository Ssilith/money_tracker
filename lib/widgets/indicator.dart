import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
            height: 60,
            child: Image(
              image: AssetImage('assets/moneta-opoznienie-01.gif'),
            )));
  }
}
