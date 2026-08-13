import 'package:flutter/material.dart';

import 'package:appwrite/models.dart' show Document;

import 'package:appwrite/appwrite.dart';

import '../../../core/constants/app_constants.dart';

import '../../../core/services/appwrite_service.dart';

import '../../../core/theme/app_colors.dart';

class ManageKeywordsScreen
    extends StatefulWidget {

  const ManageKeywordsScreen({
    super.key,
  });

  @override
  State<ManageKeywordsScreen>
      createState() =>
          _ManageKeywordsScreenState();
}

class _ManageKeywordsScreenState
    extends State<ManageKeywordsScreen> {

  List<Document> keywords = [];

  bool loading = true;

  final keywordController =
      TextEditingController();

  final tagsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    loadKeywords();
  }

  Future<void> loadKeywords() async {

    final response =
        await AppwriteService.databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.keywordsCollectionId,
    );

    setState(() {

      keywords = response.documents;

      loading = false;
    });
  }

  Future<void> addKeyword() async {

    final tags =
        tagsController.text
            .split(',')

            .map(
              (e) => e.trim(),
            )

            .toList();

    await AppwriteService.databases
        .createDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.keywordsCollectionId,

      documentId: ID.unique(),

      data: {

        'keyword':
            keywordController.text.trim(),

        'generatedTags': tags,
      },
    );

    keywordController.clear();

    tagsController.clear();

    loadKeywords();
  }

  Future<void> deleteKeyword(
    String documentId,
  ) async {

    await AppwriteService.databases
        .deleteDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.keywordsCollectionId,

      documentId: documentId,
    );

    loadKeywords();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title:
            const Text(
              'Manage Keywords',
            ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(

              controller:
                  keywordController,

              decoration:
                  const InputDecoration(
                hintText: 'Keyword',
              ),
            ),

            const SizedBox(height: 10),

            TextField(

              controller:
                  tagsController,

              decoration:
                  const InputDecoration(
                hintText:
                    'Tags separated by commas',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.maroon,
                ),

                onPressed: addKeyword,

                child: const Text(
                  'ADD KEYWORD',
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(

              child:
                  loading
                      ? const Center(
                          child:
                              CircularProgressIndicator(),
                        )

                      : ListView.builder(

                          itemCount:
                              keywords.length,

                          itemBuilder:
                              (context, index) {

                            final item =
                                keywords[index];

                            return Container(

                              margin:
                                  const EdgeInsets
                                      .only(
                                bottom: 16,
                              ),

                              padding:
                                  const EdgeInsets
                                      .all(
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
                                      AppColors
                                          .maroon,
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

                                      Text(
                                        item.data[
                                            'keyword'],

                                        style:
                                            const TextStyle(
                                          fontSize:
                                              20,

                                          fontWeight:
                                              FontWeight
                                                  .bold,

                                          color:
                                              AppColors
                                                  .yellow,
                                        ),
                                      ),

                                      IconButton(

                                        onPressed: () {

                                          deleteKeyword(
                                            item.$id,
                                          );
                                        },

                                        icon:
                                            const Icon(
                                          Icons.delete,

                                          color:
                                              Colors
                                                  .red,
                                        ),
                                      )
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Wrap(

                                    spacing: 8,

                                    children:

                                        (item.data[
                                                    'generatedTags']
                                                as List)
                                            .map(
                                              (tag) {

                                                return Chip(
                                                  label:
                                                      Text(
                                                    tag,
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