import 'package:billing_app/helpers/alerts_helper.dart';
import 'package:billing_app/properties.dart';
import 'package:flutter/material.dart';

class OldFormWidget extends StatelessWidget {
  final String title;
  final Color color;
  final List<Widget> inputs;
  final dynamic Function() validate;
  final bool Function() check;

  const OldFormWidget({
    super.key,
    required this.title,
    required this.color,
    required this.inputs,
    required this.check,
    required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.only(bottom: 16),
      margin: const EdgeInsets.all(16).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
            color: color,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...inputs.map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: e,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      elevation: 8,
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  onPressed: () async {
                    if (check()) {
                      final result = await validate();
                      if (context.mounted) {
                        if (result == null) {
                          AlertsHelper.show(
                            context,
                            title: "Opération échouée",
                            description: "Une erreur s'est produite.",
                            color: Colors.red,
                          );
                          return;
                        }
                        Navigator.of(context).pop();
                        AlertsHelper.show(
                          context,
                          title: "Opération réussie",
                          description: "Opération effectuée avec succès.",
                          color: baseColor,
                        );
                      }
                    } else {
                      AlertsHelper.show(context);
                    }
                  },
                  child: const Text('Confirmer'),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  child: const Text(
                    'Annuler',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
