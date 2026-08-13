import 'package:flutter/material.dart';

import '../../core/services/problem_matching_service.dart';

import '../../core/theme/app_colors.dart';

class MatchedProblemsScreen
    extends StatefulWidget {

  const MatchedProblemsScreen({
    super.key,
  });

  @override
  State<MatchedProblemsScreen>
      createState() =>
          _MatchedProblemsScreenState();
}

class _MatchedProblemsScreenState
    extends State<MatchedProblemsScreen> {

  List<dynamic> problems = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadProblems();
  }

  Future<void> loadProblems() async {

    final data =
        await ProblemMatchingService
            .getMatchedProblems();

    setState(() {

      problems = data;

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
              'Problems You Can Solve',
            ),
      ),

      body:
          loading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : problems.isEmpty

                  ? const Center(
                      child: Text(
                        'No matching problems yet.',
                      ),
                    )

                  : ListView.builder(

                      padding:
                          const EdgeInsets.all(16),

                      itemCount:
                          problems.length,

                      itemBuilder:
                          (context, index) {

                        final item =
                            problems[index];

                        return Container(

                          margin:
                              const EdgeInsets.only(
                            bottom: 16,
                          ),

                          padding:
                              const EdgeInsets.all(
                            16,
                          ),

                          decoration:
                              BoxDecoration(

                            color:
                                AppColors.card,

                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            border: Border.all(
                              color:
                                  AppColors.maroon,
                            ),
                          ),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                item['title'],

                                style:
                                    const TextStyle(
                                  fontSize: 20,
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
                                item['description'],
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              Row(

                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,

                                children: [

                                  Text(
                                    item['category'],
                                  ),

                                  CircleAvatar(

                                    backgroundColor:
                                        AppColors
                                            .maroon,

                                    child: Text(
                                      item['score']
                                          .toString(),
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