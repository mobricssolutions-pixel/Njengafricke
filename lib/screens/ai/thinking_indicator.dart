import 'dart:async';

import 'package:flutter/material.dart';

class ThinkingIndicator extends StatefulWidget {
  const ThinkingIndicator({super.key});

  @override
  State<ThinkingIndicator> createState() =>
      _ThinkingIndicatorState();
}

class _ThinkingIndicatorState
    extends State<ThinkingIndicator> {

  int dots = 1;

  Timer? timer;

  final List<String> messages = [
    "Thinking",
    "Searching knowledge",
    "Analyzing",
    "Preparing answer",
  ];

  int messageIndex = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {
        if (!mounted) return;

        setState(() {
          dots++;

          if (dots > 3) {
            dots = 1;

            messageIndex++;

            if (messageIndex >= messages.length) {
              messageIndex = 0;
            }
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final dotText = "." * dots;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Icon(
            Icons.psychology,
            color: Colors.amber,
            size: 60,
          ),

          const SizedBox(height: 20),

          Text(
            messages[messageIndex] + dotText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Njengafricke AI Mentor",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}