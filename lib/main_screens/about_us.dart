import 'package:flutter/material.dart';
import 'package:money_tracker/about_us/app_details.dart';
import 'package:money_tracker/about_us/headliner.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 40),
        HeadlinerAboutUs(),
        SizedBox(height: 40),
        AppDetails(),
        SizedBox(height: 400)
      ],
    );
  }
}
