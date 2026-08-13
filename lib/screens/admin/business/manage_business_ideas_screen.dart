import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/appwrite_service.dart';
import '../../../core/services/tag_engine_service.dart';
import '../../../core/theme/app_colors.dart';

class ManageBusinessIdeasScreen
    extends StatefulWidget {

  const ManageBusinessIdeasScreen({
    super.key,
  });

  @override
  State<ManageBusinessIdeasScreen>
      createState() =>
          _ManageBusinessIdeasScreenState();
}

class _ManageBusinessIdeasScreenState
    extends State<ManageBusinessIdeasScreen> {

  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  List<dynamic> ideas = [];

  bool loading = true;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    loadIdeas();
  }

  Future<void> loadIdeas() async {

    final response =
        await AppwriteService
            .databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants
              .businessIdeasCollectionId,
    );

    setState(() {

      ideas = response.documents;

      loading = false;
    });
  }

  Future<void> addIdea() async {

    try {

      setState(() {
        saving = true;
      });

      final combinedText = '''

      ${titleController.text}

      ${descriptionController.text}

      ''';

      final generatedTags =
          await TagEngineService
              .generateTags(
        combinedText,
      );

      await AppwriteService
          .databases
          .createDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .businessIdeasCollectionId,

        documentId:
            ID.unique(),

        data: {

          'title':
              titleController.text.trim(),

          'description':
              descriptionController.text
                  .trim(),

          'requiredTags':
              generatedTags,
        },
      );

      titleController.clear();

      descriptionController.clear();

      loadIdeas();

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
                Text('Business Idea Added'),
          ),
        );
      }

    } catch (e) {

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              'Error: $e',
            ),
          ),
        );
      }

    } finally {

      setState(() {
        saving = false;
      });
    }
  }

  Future<void> deleteIdea(
    String id,
  ) async {

    await AppwriteService
        .databases
        .deleteDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants
              .businessIdeasCollectionId,

      documentId: id,
    );

    loadIdeas();
  }

  Widget buildField({

    required TextEditingController
        controller,

    required String hint,

    int lines = 1,
  }) {

    return TextField(

      controller: controller,

      maxLines: lines,

      decoration: InputDecoration(

        hintText: hint,

        filled: true,

        fillColor:
            AppColors.card,

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Manage Business Ideas',
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

                      buildField(

                        controller:
                            titleController,

                        hint:
                            'Business Idea Title',
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      buildField(

                        controller:
                            descriptionController,

                        hint:
                            'Business Description',

                        lines: 5,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(

                        width:
                            double.infinity,

                        child:
                            ElevatedButton(

                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                AppColors.maroon,
                          ),

                          onPressed:
                              saving
                                  ? null
                                  : addIdea,

                          child:
                              saving

                                  ? const CircularProgressIndicator(
                                      color:
                                          Colors.white,
                                    )

                                  : const Text(
                                      'ADD BUSINESS IDEA',
                                    ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      ListView.builder(

                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

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

                                  item.data['title'],

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
                                  item.data['description'],
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Wrap(

                                  spacing: 8,

                                  children:

                                      (item.data['requiredTags']
                                                  ?? [])

                                              .map<Widget>(

                                    (tag) {

                                      return Chip(
                                        label:
                                            Text(tag),
                                      );
                                    },
                                  ).toList(),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Align(

                                  alignment:
                                      Alignment
                                          .centerRight,

                                  child:
                                      IconButton(

                                    onPressed: () {

                                      deleteIdea(
                                        item.$id,
                                      );
                                    },

                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
    );
  }
}