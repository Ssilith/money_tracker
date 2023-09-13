import 'package:flutter/material.dart';
import 'package:motion/motion.dart';
import 'package:neon_widgets/neon_widgets.dart';
import 'package:random_text_reveal/random_text_reveal.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class HeadlinerAboutUs extends StatefulWidget {
  const HeadlinerAboutUs({super.key});

  @override
  State<HeadlinerAboutUs> createState() => _HeadlinerAboutUsState();
}

class _HeadlinerAboutUsState extends State<HeadlinerAboutUs> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const NeonContainer(),
      const SizedBox(width: 20),
      SizedBox(
        width: ((size.width - 200) * 0.3) - 20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PeopleAnimationWidget(
                  image: const AssetImage('assets/MF_FINAL.jpg'),
                  color: Theme.of(context).colorScheme.secondary,
                  imageWidth: (size.width - 200) * 0.14,
                ),
                const PeopleAnimatedText(
                    name: "MARCO FERRARA", desc: "Company co-founder")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PeopleAnimatedText(
                    name: "MAŁGORZATA ŻYREK", desc: "Company co-founder"),
                PeopleAnimationWidget(
                  image: const AssetImage('assets/default_person.jpg'),
                  color: Theme.of(context).colorScheme.secondary,
                  imageWidth: (size.width - 200) * 0.14,
                )
              ],
            ),
          ],
        ),
      )
    ]);
  }
}

class NeonContainer extends StatelessWidget {
  const NeonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Motion(
        child: Container(
      height: 500,
      width: (size.width - 200) * 0.7,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 36, 36),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 107, 107, 107),
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Image(image: AssetImage('assets/logo.png')),
          NeonText(
            text: 'DORADZTWO PODATKOWE I KSIĘGOWOŚĆ W NAJLEPSZEJ JAKOŚCI',
            textSize: 40,
            blurRadius: 10,
            textColor: Color.fromARGB(255, 11, 253, 233),
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    ));
  }
}

class PeopleAnimationWidget extends StatelessWidget {
  final AssetImage image;
  final double imageWidth;
  final Color color;

  const PeopleAnimationWidget(
      {super.key,
      required this.image,
      required this.color,
      required this.imageWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: imageWidth,
      child: RippleAnimation(
        minRadius: 85,
        color: color,
        delay: const Duration(milliseconds: 10),
        repeat: true,
        ripplesCount: 6,
        duration: const Duration(milliseconds: 3000),
        child: CircleAvatar(
          radius: 87,
          backgroundColor: color,
          child: CircleAvatar(
            minRadius: 85,
            maxRadius: 85,
            backgroundImage: image,
          ),
        ),
      ),
    );
  }
}

class PeopleAnimatedText extends StatelessWidget {
  final String name;
  final String desc;
  const PeopleAnimatedText({super.key, required this.name, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RandomTextReveal(
          text: name,
          duration: const Duration(seconds: 3),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          curve: Curves.easeIn,
        ),
        Text(desc)
      ],
    );
  }
}
