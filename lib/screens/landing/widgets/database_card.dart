import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DatabaseCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onView;

  const DatabaseCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.maroon,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: AppColors.yellow,
            size: 32,
          ),

          const SizedBox(height: 16),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Text(
              description,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
              onPressed: onView,
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              label: const Text("View"),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}