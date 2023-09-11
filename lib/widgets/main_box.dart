import 'package:flutter/material.dart';

class MainBox extends StatelessWidget {
  final Widget? child;
  final bool isShadow;
  final double? width;
  final double? height;
  const MainBox(
      {super.key,
      this.child,
      this.isShadow = true,
      this.width,
      this.height = 380});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white24,
          // boxShadow: isShadow
          //     ? const [
          //         BoxShadow(
          //           color: Color.fromARGB(255, 107, 107, 107),
          //           offset: Offset(5, 5),
          //           blurRadius: 10,
          //         ),
          //       ]
          //     : null,
          borderRadius: BorderRadius.circular(8),
        ),
        height: height,
        width: width,
        child: child);
  }
}
