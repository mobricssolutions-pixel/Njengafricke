import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'animated_answer.dart';

class AiBubble extends StatelessWidget {
  final String answerJson;
  final String category;

  final bool typingFinished;
  final VoidCallback onTypingFinished;

  const AiBubble({
    super.key,
    required this.answerJson,
    required this.category,
    required this.typingFinished,
    required this.onTypingFinished,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 340,
        ),
        margin: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          right: 40,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.maroon,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Row(
              children: [

                Icon(
                  Icons.smart_toy,
                  color: AppColors.yellow,
                  size: 20,
                ),

                SizedBox(width: 8),

                Text(
                  "Njengafricke AI",
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            AnimatedAnswer(
              answerJson: answerJson,
              typingFinished: typingFinished,
              onTypingFinished: onTypingFinished,
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.maroon,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}