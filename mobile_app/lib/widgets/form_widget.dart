import 'package:billing_app/helpers/alerts_helper.dart';
import 'package:billing_app/properties.dart';
import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final String title;
  final Color color;
  final List<Widget> inputs;
  final dynamic Function() validate;
  final bool Function() check;

  const FormWidget({
    super.key,
    required this.title,
    required this.color,
    required this.inputs,
    required this.check,
    required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: color,
          elevation: 0,
          title: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        body: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const SizedBox(height: 16),
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
          ),
        ),
      ),
    );
  }
}
