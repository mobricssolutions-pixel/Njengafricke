import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class BuilderMindsetSection extends StatelessWidget {
  final String quote;

  const BuilderMindsetSection({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Text(
            "Builder Mindset",
            style: TextStyle(
              color: AppColors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 15),

          AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 600,
            ),

            transitionBuilder:
                (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(
                      0.0,
                      0.15,
                    ),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },

            child: Container(
              key: ValueKey(quote),

              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: AppColors.card,

                borderRadius:
                    BorderRadius.circular(18),

                border: Border.all(
                  color: AppColors.maroon,
                ),
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.yellow,
                    size: 30,
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      quote,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}