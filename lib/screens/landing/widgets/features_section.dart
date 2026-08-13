import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  static const List<Map<String, dynamic>> features = [
    {
      "icon": Icons.smart_toy,
      "title": "AI Assistant",
      "description":
          "Receive AI guidance on careers, opportunities and entrepreneurship.",
    },
    {
      "icon": Icons.volunteer_activism,
      "title": "Fundraising",
      "description":
          "Raise funds for verified community projects and support others.",
    },
    {
      "icon": Icons.rocket_launch,
      "title": "Projects",
      "description":
          "Create projects and recruit collaborators from across Kenya.",
    },
    {
      "icon": Icons.work_outline,
      "title": "Opportunities",
      "description":
          "Find jobs, grants, competitions and scholarships.",
    },
    {
      "icon": Icons.groups,
      "title": "Community",
      "description":
          "Meet innovators, professionals and builders.",
    },
    {
      "icon": Icons.school,
      "title": "Learning",
      "description":
          "Learn practical skills that create income and impact.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive layout
    final bool isTablet = screenWidth >= 700;

    final int crossAxisCount = isTablet ? 3 : 2;

    final double childAspectRatio =
        isTablet ? 0.95 : 0.72;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "What You Can Do",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Everything you need to build, collaborate and grow.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final feature = features[index];

              return Container(
                padding:
                    const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.maroon,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      feature["icon"]
                          as IconData,
                      color: AppColors.yellow,
                      size: 30,
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    Text(
                      feature["title"]
                          as String,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Expanded(
                      child: Text(
                        feature[
                                "description"]
                            as String,
                        style:
                            const TextStyle(
                          color:
                              Colors.white70,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}