import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_handler.dart';
import '../../fundraising/models/fundraiser_model.dart';
import '../../fundraising/services/fundraising_service.dart';
import '../../fundraising/screens/fundraiser_details_screen.dart';

import 'database_card.dart';

class FundraiserSection extends StatelessWidget {
  const FundraiserSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(
                Icons.volunteer_activism,
                color: AppColors.yellow,
              ),
              SizedBox(width: 10),
              Text(
                "Featured Fundraisers",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          FutureBuilder<List<FundraiserModel>>(
            future: FundraisingService().getApprovedFundraisers(),
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

              final fundraisers = snapshot.data ?? [];

              // Empty state
              if (fundraisers.isEmpty) {
                return const SizedBox(
                  height: 185,
                  child: Center(
                    child: Text(
                      "No fundraisers available.",
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
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: fundraisers.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final fundraiser = fundraisers[index];

                    return DatabaseCard(
                      icon: Icons.volunteer_activism,
                      title: fundraiser.title,
                      description: fundraiser.description,
                      onView: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FundraiserDetailsScreen(
                              fundraiser: fundraiser,
                            ),
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