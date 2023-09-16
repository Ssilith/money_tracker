import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Foot extends StatefulWidget {
  const Foot({super.key});

  @override
  State<Foot> createState() => _FootState();
}

class _FootState extends State<Foot> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
      height: 160,
      width: size.width,
      color: Theme.of(context).colorScheme.secondary,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SvgPicture.asset('assets/logo.svg'),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Żyrek Ferrara Consulting - Panel Klienta",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      ]),
    );
  }
}
