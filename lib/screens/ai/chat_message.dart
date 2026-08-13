import 'package:flutter/foundation.dart';

class ChatMessage {
  final String id;

  final bool isUser;

  final bool isThinking;

  final String? text;

  final String? answerJson;

  final String? category;

  bool typingFinished;

  ChatMessage({
    required this.id,
    required this.isUser,
    this.isThinking = false,
    this.text,
    this.answerJson,
    this.category,
    this.typingFinished = false,
  });
}