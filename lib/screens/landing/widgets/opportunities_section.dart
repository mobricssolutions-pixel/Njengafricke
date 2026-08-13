import 'package:flutter/material.dart';

import '../../opportunities/opportunities_screen.dart';
import '../../../core/services/opportunity_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';

import 'database_card.dart';

class OpportunitiesSection extends StatelessWidget {
  const OpportunitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================
          // HEADER
          // ==========================

          const Row(
            children: [
              Icon(
                Icons.work_outline,
                color: AppColors.yellow,
              ),
              SizedBox(width: 10),
              Text(
                "Latest Opportunities",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          FutureBuilder<List<dynamic>>(
            future: OpportunityService.getLatestOpportunities(),
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const SizedBox(
                  height: 185,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Error
              if (snapshot.hasError) {
                return SizedBox(
                  height: 185,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        ErrorHandler.getMessage(snapshot.error),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }

              final opportunities = snapshot.data ?? [];

              // Empty state
              if (opportunities.isEmpty) {
                return const SizedBox(
                  height: 185,
                  child: Center(
                    child: Text(
                      "No opportunities available.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }

              // Success
              return SizedBox(
                height: 185,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: opportunities.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final opportunity = opportunities[index];

                    return DatabaseCard(
                      icon: Icons.work_outline,
                      title: opportunity.data["title"] ?? "Untitled",
                      description:
                          opportunity.data["description"] ?? "",
                      onView: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const OpportunitiesScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}