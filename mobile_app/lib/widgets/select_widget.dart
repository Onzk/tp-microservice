import 'package:billing_app/properties.dart';
import 'package:flutter/material.dart';

class SelectWidget extends StatefulWidget {
  final String labelText;
  final String? value;
  final List<dynamic>? items;
  final void Function(String?)? onChanged;
  final String Function(dynamic) itemValue;
  final String Function(dynamic) itemText;
  const SelectWidget(
      {super.key,
      required this.labelText,
      required this.value,
      required this.items,
      required this.onChanged,
      required this.itemValue,
      required this.itemText});

  @override
  State<SelectWidget> createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
      child: Builder(builder: (context) {
        if (widget.items?.isEmpty == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return DropdownButtonFormField<String>(
          value: widget.value,
          decoration: InputDecoration(
            constraints: const BoxConstraints(maxHeight: 52),
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 0.0),
            ),
          ),
          icon: Transform.rotate(
              angle: 33,
              child: const Icon(
                Icons.chevron_right,
                color: baseColor,
              )),
          elevation: 16,
          onChanged: widget.onChanged,
          items: (widget.items ?? []).map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: widget.itemValue(item),
              child: Text(widget.itemText(item)),
            );
          }).toList(),
        );
      }),
    );
  }
}
