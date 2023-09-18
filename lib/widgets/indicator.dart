import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Indicator extends StatelessWidget {
  const Indicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        LoadingAnimationWidget.discreteCircle(
            color: Theme.of(context).colorScheme.secondary,
            size: 60,
            secondRingColor: const Color.fromARGB(255, 0, 184, 121),
            thirdRingColor: const Color.fromARGB(255, 0, 181, 212)),
      ],
    );
  }
}
