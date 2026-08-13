import 'package:flutter/material.dart';

import 'package:appwrite/models.dart'
    show Document;

import 'package:appwrite/appwrite.dart';

import '../../../core/constants/app_constants.dart';

import '../../../core/services/appwrite_service.dart';

import '../../../core/services/tag_engine_service.dart';

import '../../../core/theme/app_colors.dart';

class ManageOpportunitiesScreen
    extends StatefulWidget {

  const ManageOpportunitiesScreen({
    super.key,
  });

  @override
  State<ManageOpportunitiesScreen>
      createState() =>
          _ManageOpportunitiesScreenState();
}

class _ManageOpportunitiesScreenState
    extends State<ManageOpportunitiesScreen> {

  List<Document> opportunities = [];

  bool loading = true;

  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final categoryController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    loadOpportunities();
  }

  Future<void> loadOpportunities() async {

    try {

      final response =
          await AppwriteService
              .databases
              .listDocuments(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .opportunitiesCollectionId,
      );

      setState(() {

        opportunities =
            response.documents;

        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              'Error loading opportunities: $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> addOpportunity() async {

    try {

      final combinedText = '''

      ${titleController.text}

      ${descriptionController.text}

      ${categoryController.text}

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
                .opportunitiesCollectionId,

        documentId:
            ID.unique(),

        data: {

          'title':
              titleController.text.trim(),

          'description':
              descriptionController.text.trim(),

          'category':
              categoryController.text.trim(),

          'requiredTags':
              generatedTags,

          'opportunityTags':
              generatedTags,
        },
      );

      titleController.clear();

      descriptionController.clear();

      categoryController.clear();

      loadOpportunities();

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
                Text('Opportunity Added'),
          ),
        );
      }

    } on AppwriteException catch (e) {

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              e.message ??
                  'Failed to add opportunity',
            ),
          ),
        );
      }
    }
  }

  Future<void> deleteOpportunity(
    String documentId,
  ) async {

    try {

      await AppwriteService
          .databases
          .deleteDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .opportunitiesCollectionId,

        documentId:
            documentId,
      );

      loadOpportunities();

    } catch (e) {

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              'Delete failed: $e',
            ),
          ),
        );
      }
    }
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

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle:
            const TextStyle(
          color: Colors.white70,
        ),

        filled: true,

        fillColor:
            AppColors.card,

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          borderSide:
              const BorderSide(
            color:
                AppColors.maroon,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          borderSide:
              const BorderSide(
            color:
                AppColors.yellow,
            width: 2,
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

        title:
            const Text(
          'Manage Opportunities',
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          children: [

            buildField(

              controller:
                  titleController,

              hint:
                  'Opportunity Title',
            ),

            const SizedBox(
              height: 12,
            ),

            buildField(

              controller:
                  descriptionController,

              hint:
                  'Description',

              lines: 4,
            ),

            const SizedBox(
              height: 12,
            ),

            buildField(

              controller:
                  categoryController,

              hint:
                  'Category',
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(

              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton(

                style:
                    ElevatedButton
                        .styleFrom(

                  backgroundColor:
                      AppColors.maroon,
                ),

                onPressed:
                    addOpportunity,

                child:
                    const Text(

                  'ADD OPPORTUNITY',

                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            Expanded(

              child:
                  loading

                      ? const Center(
                          child:
                              CircularProgressIndicator(),
                        )

                      : opportunities.isEmpty

                          ? const Center(
                              child: Text(
                                'No opportunities yet.',
                              ),
                            )

                          : ListView.builder(

                              itemCount:
                                  opportunities
                                      .length,

                              itemBuilder:
                                  (
                                    context,
                                    index,
                                  ) {

                                final item =
                                    opportunities[
                                        index];

                                return Container(

                                  margin:
                                      const EdgeInsets.only(
                                    bottom:
                                        16,
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

                                    border:
                                        Border.all(
                                      color:
                                          AppColors.maroon,
                                    ),
                                  ),

                                  child: Column(

                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Row(

                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,

                                        children: [

                                          Expanded(

                                            child:
                                                Text(

                                              item.data[
                                                      'title'] ??
                                                  '',

                                              style:
                                                  const TextStyle(

                                                fontSize:
                                                    20,

                                                fontWeight:
                                                    FontWeight.bold,

                                                color:
                                                    AppColors.yellow,
                                              ),
                                            ),
                                          ),

                                          IconButton(

                                            onPressed:
                                                () {

                                              deleteOpportunity(
                                                item
                                                    .$id,
                                              );
                                            },

                                            icon:
                                                const Icon(

                                              Icons
                                                  .delete,

                                              color:
                                                  Colors.red,
                                            ),
                                          )
                                        ],
                                      ),

                                      const SizedBox(
                                        height:
                                            10,
                                      ),

                                      Text(
                                        item.data[
                                                'description'] ??
                                            '',
                                      ),

                                      const SizedBox(
                                        height:
                                            10,
                                      ),

                                      Text(
                                        'Category: ${item.data['category'] ?? ''}',
                                      ),

                                      const SizedBox(
                                        height:
                                            15,
                                      ),

                                      Wrap(

                                        spacing:
                                            8,

                                        runSpacing:
                                            8,

                                        children:

                                            (item.data['requiredTags'] ??
                                                    [])

                                                .map<Widget>(
                                                  (
                                                    tag,
                                                  ) {

                                                    return Chip(

                                                      backgroundColor:
                                                          AppColors.maroon,

                                                      label:
                                                          Text(

                                                        tag.toString(),

                                                        style:
                                                            const TextStyle(
                                                          color:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )

                                                .toList(),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
            )
          ],
        ),
      ),
    );
  }
}