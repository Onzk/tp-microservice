import 'package:flutter/material.dart';

class Statewidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color color;
  final FontWeight fontWeight;
  const Statewidget({
    super.key,
    required this.iconData,
    required this.text,
    required this.color,
    this.fontWeight = FontWeight.w900,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: color,
          size: 128,
        ),
        const SizedBox(height: 38),
        Text("- $text -",
            style: TextStyle(
              color: color,
              fontWeight: fontWeight,
            )),
      ],
    ));
  }
}
