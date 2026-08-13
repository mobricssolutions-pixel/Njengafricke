import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'typewriter_answer.dart';

class AnimatedAnswer extends StatelessWidget {
  final String answerJson;
  final bool typingFinished;
  final VoidCallback onTypingFinished;

  const AnimatedAnswer({
    super.key,
    required this.answerJson,
    required this.typingFinished,
    required this.onTypingFinished,
  });

  @override
  Widget build(BuildContext context) {
    late quill.Document document;
    late String plainText;

    try {
      document = quill.Document.fromJson(
        jsonDecode(answerJson),
      );

      plainText = document.toPlainText();
    } catch (_) {
      plainText = answerJson;

      document = quill.Document()
        ..insert(0, plainText);
    }

    if (!typingFinished) {
      return TypewriterAnswer(
        text: plainText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.7,
        ),
        onFinished: onTypingFinished,
      );
    }

    final controller = quill.QuillController(
      document: document,
      selection: const TextSelection.collapsed(
        offset: 0,
      ),
    );

    return IgnorePointer(
      child: quill.QuillEditor.basic(
        controller: controller,
        config: const quill.QuillEditorConfig(
          scrollable: false,
          expands: false,
          padding: EdgeInsets.zero,
          autoFocus: false,
        ),
      ),
    );
  }
}