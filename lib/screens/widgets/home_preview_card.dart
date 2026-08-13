import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HomePreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const HomePreviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 270,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.maroon,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            CircleAvatar(
              backgroundColor:
                  AppColors.maroon,
              child: Icon(
                icon,
                color: AppColors.yellow,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Text(
                subtitle,
                maxLines: 4,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Row(
              children: [

                Text(
                  "View",
                  style: TextStyle(
                    color:
                        AppColors.yellow,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(width: 6),

                Icon(
                  Icons.arrow_forward,
                  color:
                      AppColors.yellow,
                  size: 18,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}