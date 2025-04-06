import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final void Function(String)? onChanged;
  final String labelText;
  final TextInputType? keyboardType;
  final bool autofocus;
  final TextEditingController? controller;
  final int maxLines;
  const InputWidget({
    super.key,
    this.onChanged,
    required this.labelText,
    this.keyboardType,
    this.autofocus = false,
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
      child: TextField(
        autofocus: autofocus,
        keyboardType: keyboardType,
        controller: controller,
        maxLines: maxLines,
        minLines: maxLines,
        decoration: InputDecoration(
          constraints:
              maxLines == 1 ? const BoxConstraints(maxHeight: 52) : null,
          labelText: labelText,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 0.0),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
