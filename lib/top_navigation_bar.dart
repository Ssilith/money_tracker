import 'package:flutter/material.dart';
import 'package:money_tracker/main.dart';

class TopNavigationBar extends StatefulWidget {
  final Function(Screens) changeView;
  final Screens chosenView;
  const TopNavigationBar(
      {super.key, required this.changeView, required this.chosenView});

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  Widget switchScreenButton(String name, Screens screen) {
    return TextButton(
        onPressed: () => widget.changeView(screen),
        child: Text(
          name,
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
              fontWeight: widget.chosenView == screen
                  ? FontWeight.w900
                  : FontWeight.w500),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
      decoration: const BoxDecoration(
        //color: Theme.of(context).colorScheme.secondary,
        color: Color.fromARGB(255, 236, 236, 236),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(244, 134, 134, 134),
            offset: Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Image(
              image: AssetImage('assets/long_logo_gold.png'),
            ),
            const SizedBox(width: 30),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                Theme.of(context).colorScheme.secondary
              ]).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: const Text(
                "Panel klienta - RenX Polska",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            switchScreenButton("Strona główna", Screens.summaryScreen),
            switchScreenButton("Baza dokumentów", Screens.documents),
            switchScreenButton("Sprawozdania finansowe", Screens.financial),
            switchScreenButton("Konto", Screens.account),
            switchScreenButton("O nas", Screens.aboutUs),
          ])
        ],
      ),
    );
  }
}
