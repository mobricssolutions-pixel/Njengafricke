import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

import '../../../core/services/appwrite_service.dart';

import '../../../core/theme/app_colors.dart';

class AdminAnalyticsScreen
    extends StatefulWidget {

  const AdminAnalyticsScreen({
    super.key,
  });

  @override
  State<AdminAnalyticsScreen>
      createState() =>
          _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState
    extends State<AdminAnalyticsScreen> {

  bool loading = true;

  int totalUsers = 0;

  int paidUsers = 0;

  int unpaidUsers = 0;

  int totalProblems = 0;

  int totalOpportunities = 0;

  @override
  void initState() {
    super.initState();

    loadAnalytics();
  }

  Future<void> loadAnalytics() async {

    final users =
        await AppwriteService.databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.usersCollectionId,
    );

    final problems =
        await AppwriteService.databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.problemsCollectionId,
    );

    final opportunities =
        await AppwriteService.databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants
              .opportunitiesCollectionId,
    );

    int paid = 0;

    int unpaid = 0;

        for (var user in users.documents) {

        final isPaid =
        user.data['paidMember'] == true ||
        user.data['paidMember'] == 'true';

        if (isPaid) {

        paid++;

        } else {

        unpaid++;

        }
        }

    setState(() {

      totalUsers =
          users.documents.length;

      paidUsers = paid;

      unpaidUsers = unpaid;

      totalProblems =
          problems.documents.length;

      totalOpportunities =
          opportunities.documents.length;

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title:
            const Text(
              'Platform Analytics',
            ),
      ),

      body:
          loading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : SingleChildScrollView(

                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  child: Column(

                    children: [

                      buildAnalyticsCard(
                        'Total Users',
                        totalUsers.toString(),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      buildAnalyticsCard(
                        'Paid Users',
                        paidUsers.toString(),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      buildAnalyticsCard(
                        'Unpaid Users',
                        unpaidUsers.toString(),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      buildAnalyticsCard(
                        'Reported Problems',
                        totalProblems
                            .toString(),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      buildAnalyticsCard(
                        'Opportunities',
                        totalOpportunities
                            .toString(),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget buildAnalyticsCard(
    String title,
    String value,
  ) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(

        color: AppColors.card,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border: Border.all(
          color: AppColors.maroon,
        ),
      ),

      child: Column(

        children: [

          Text(
            value,

            style: const TextStyle(
              fontSize: 40,
              fontWeight:
                  FontWeight.bold,

              color:
                  AppColors.yellow,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            title,

            style: const TextStyle(
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}