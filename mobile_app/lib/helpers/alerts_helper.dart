import 'package:flutter/material.dart';

class AlertsHelper {
  static void show(
    BuildContext context, {
    String title = "Saisies incorrectes !",
    String description = "Veuillez remplir correctement tous les champs",
    Color color = Colors.amber,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color, width: 2),
        ),
        title: Text(title),
        icon: const Icon(Icons.error, size: 54),
        iconColor: color,
        content: Text(
          description,
          textAlign: TextAlign.center,
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12)
                  .copyWith(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(.2),
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              child: Text(
                'Fermer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: color,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
