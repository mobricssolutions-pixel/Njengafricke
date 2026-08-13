import 'package:flutter/material.dart';

import '../../core/services/business_idea_service.dart';

import '../../core/theme/app_colors.dart';

class BusinessIdeasScreen
    extends StatefulWidget {

  const BusinessIdeasScreen({
    super.key,
  });

  @override
  State<BusinessIdeasScreen>
      createState() =>
          _BusinessIdeasScreenState();
}

class _BusinessIdeasScreenState
    extends State<BusinessIdeasScreen> {

  List<dynamic> ideas = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadIdeas();
  }

  Future<void> loadIdeas() async {

    final data =
        await BusinessIdeaService
            .generateIdeas();

    setState(() {

      ideas = data;

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
              'Business Ideas',
            ),
      ),

      body:
          loading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : ideas.isEmpty

                  ? const Center(
                      child: Text(
                        'No ideas found.',
                      ),
                    )

                  : ListView.builder(

                      padding:
                          const EdgeInsets.all(16),

                      itemCount:
                          ideas.length,

                      itemBuilder:
                          (context, index) {

                        final item =
                            ideas[index];

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

                              Align(

                                alignment:
                                    Alignment
                                        .centerRight,

                                child:
                                    CircleAvatar(

                                  backgroundColor:
                                      AppColors
                                          .maroon,

                                  child: Text(
                                    item['score']
                                        .toString(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}