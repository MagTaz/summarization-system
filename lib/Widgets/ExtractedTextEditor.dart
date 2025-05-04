// lib/widgets/ExtractedTextEditor.dart
import 'package:flutter/material.dart';

class ExtractedTextEditor extends StatelessWidget {
  final TextEditingController controller;
  final double maxHeight;
  final double bottomPadding;

  const ExtractedTextEditor({
    super.key,
    required this.controller,
    required this.maxHeight,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return controller.text.isEmpty
        ? const Center(child: Text('No extracted text yet'))
        : Container(
            margin: EdgeInsets.only(bottom: bottomPadding),
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Extracted text...'),
            ),
          );
  }
}
