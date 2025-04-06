import 'package:billing_app/properties.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final Color color;
  final String text;
  const TagWidget({super.key, this.color = baseColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
