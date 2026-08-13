import 'package:flutter/material.dart';

import '../../core/services/opportunity_service.dart';

import '../../core/theme/app_colors.dart';

class OpportunitiesScreen
    extends StatefulWidget {

  const OpportunitiesScreen({
    super.key,
  });

  @override
  State<OpportunitiesScreen>
      createState() =>
          _OpportunitiesScreenState();
}

class _OpportunitiesScreenState
    extends State<OpportunitiesScreen> {

  List<dynamic> opportunities = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadOpportunities();
  }

  Future<void> loadOpportunities() async {

    final data =
        await OpportunityService
            .getMatchedOpportunities();

    setState(() {

      opportunities = data;

      loading = false;
    });
  }

  Color getScoreColor(
    int score,
  ) {

    if (score >= 80) {
      return Colors.green;
    }

    if (score >= 50) {
      return Colors.orange;
    }

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(

        backgroundColor:
            AppColors.background,

        title: const Text(
          'Your Opportunities',
        ),
      ),

      body:
          loading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : opportunities.isEmpty

                  ? const Center(

                      child: Text(

                        'No opportunities found yet.',

                        style: TextStyle(
                          color:
                              Colors.white70,
                        ),
                      ),
                    )

                  : ListView.builder(

                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      itemCount:
                          opportunities.length,

                      itemBuilder:
                          (context, index) {

                        final item =
                            opportunities[
                                index];

                        final score =
                            item['score'] ?? 0;

                        return Container(

                          margin:
                              const EdgeInsets.only(
                            bottom: 18,
                          ),

                          padding:
                              const EdgeInsets.all(
                            18,
                          ),

                          decoration:
                              BoxDecoration(

                            color:
                                AppColors.card,

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),

                            border: Border.all(
                              color:
                                  AppColors
                                      .maroon,
                            ),

                            boxShadow: [

                              BoxShadow(

                                color:
                                    Colors.black
                                        .withOpacity(
                                  0.3,
                                ),

                                blurRadius:
                                    8,

                                offset:
                                    const Offset(
                                  0,
                                  5,
                                ),
                              )
                            ],
                          ),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Row(

                                children: [

                                  Expanded(

                                    child: Text(

                                      item['title'],

                                      style:
                                          const TextStyle(

                                        fontSize:
                                            22,

                                        fontWeight:
                                            FontWeight
                                                .bold,

                                        color:
                                            AppColors
                                                .yellow,
                                      ),
                                    ),
                                  ),

                                  Container(

                                    padding:
                                        const EdgeInsets.symmetric(

                                      horizontal:
                                          14,

                                      vertical:
                                          10,
                                    ),

                                    decoration:
                                        BoxDecoration(

                                      color:
                                          getScoreColor(
                                        score,
                                      ),

                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                    ),

                                    child: Text(

                                      '$score%',

                                      style:
                                          const TextStyle(

                                        color:
                                            Colors.white,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              Text(

                                item['description'],

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white70,

                                  fontSize:
                                      15,
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Row(

                                children: [

                                  const Icon(

                                    Icons
                                        .trending_up,

                                    color:
                                        AppColors.yellow,
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  Text(

                                    score >= 80

                                        ? 'High Opportunity Potential'

                                        : score >= 50

                                            ? 'Medium Opportunity Potential'

                                            : 'Low Opportunity Potential',

                                    style:
                                        const TextStyle(

                                      color:
                                          Colors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}