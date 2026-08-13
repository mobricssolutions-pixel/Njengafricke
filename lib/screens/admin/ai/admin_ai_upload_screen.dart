import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../../core/theme/app_colors.dart';
import '../../../core/services/appwrite_service.dart';
import '../../../core/constants/app_constants.dart';

class AdminAiUploadScreen
    extends StatefulWidget {

  const AdminAiUploadScreen({
    super.key,
  });

  @override
  State<AdminAiUploadScreen>
      createState() =>
          _AdminAiUploadScreenState();
}

class _AdminAiUploadScreenState
    extends State<AdminAiUploadScreen> {

  final titleController =
      TextEditingController();

  final categoryController =
      TextEditingController();

  final questionController =
      TextEditingController();

  late quill.QuillController answerController;

  final communityController =
      TextEditingController();

  final keywordsController =
      TextEditingController();

  bool loading = false;

  Future<void> uploadKnowledge() async {

    if (titleController.text
        .trim()
        .isEmpty) {

      showMessage(
        'Enter title',
      );

      return;
    }

    if (answerController.document.isEmpty()) {
      showMessage('Enter answer');
      return;
    }

    try {

      setState(() {
        loading = true;
      });

      final currentUser =
          await AppwriteService
              .account
              .get();

      List<String> keywords = keywordsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      String keywordsText = keywords.join(' ');


      String searchText =
          "${titleController.text.trim()} "
          "${keywords.join(' ')} "
          "${categoryController.text.trim()} "
          "${communityController.text.trim()}";

      final answerJson = jsonEncode(
        answerController.document.toDelta().toJson(),
      );

      print(answerJson.length);
      
      await AppwriteService
          .databases
          .createDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .aiKnowledgeCollectionId,

        documentId:
            ID.unique(),

        data: {

          'title':
              titleController.text
                  .trim(),

          'category':
              categoryController.text
                  .trim(),

          'question':
              questionController.text
                  .trim(),

          'answer': jsonEncode(
              answerController.document.toDelta().toJson(),
            ),

          'answerText': answerController.document.toPlainText(),

          'community':
              communityController.text
                  .trim(),

          'keywords': keywords,

          'keywordsText': keywordsText,

          'searchText': searchText,

          'createdBy':
              currentUser.$id,

          'approved':
              true,

          'createdAt':
              DateTime.now()
                  .toIso8601String(),
        },
      );

      clearFields();

      showMessage(
        'Knowledge uploaded successfully',
      );

    } on AppwriteException catch (e) {

      showMessage(
        e.message ??
            'Upload failed',
      );

    } catch (e) {

      showMessage(
        'Something went wrong',
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  void clearFields() {

    titleController.clear();

    categoryController.clear();

    questionController.clear();

    communityController.clear();

    keywordsController.clear();

    answerController = quill.QuillController.basic();

    setState(() {});
  }

  void showMessage(
    String message,
  ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget buildField({

    required TextEditingController
        controller,

    required String hint,

    int maxLines = 1,
  }) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 20,
      ),

      child: TextField(

        controller: controller,

        maxLines: maxLines,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle:
              const TextStyle(
            color:
                Colors.white60,
          ),

          filled: true,

          fillColor:
              AppColors.card,

          border:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              18,
            ),

            borderSide:
                BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              18,
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
              18,
            ),
 
            borderSide:
                const BorderSide(

              color:
                  AppColors.yellow,

              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    answerController = quill.QuillController.basic();
  }

  @override
  void dispose() {
    answerController.dispose();

    titleController.dispose();
    categoryController.dispose();
    questionController.dispose();
    communityController.dispose();
    keywordsController.dispose();

    super.dispose();
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

          'Upload AI Knowledge',

          style: TextStyle(
            color:
                AppColors.yellow,
          ),
        ),
      ),

      body: SingleChildScrollView(

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
                  'Knowledge Title',
            ),

            buildField(

              controller:
                  categoryController,

              hint:
                  'Category',
            ),

            buildField(

              controller:
                  communityController,

              hint:
                  'Community',
            ),

            buildField(

              controller:
                  questionController,

              hint:
                  'Possible Question',
            ),

            buildField(

              controller:
                  keywordsController,

              hint:
                  'Keywords separated by commas',
            ),

            Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.maroon,
              ),
            ),
            child: Column(
              children: [

                quill.QuillSimpleToolbar(
                  controller: answerController,
                ),

                const Divider(height: 1),

                SizedBox(
                  height: 400,
                  child: quill.QuillEditor.basic(
                    controller: answerController,
                  ),
                ),
              ],
            ),
          ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(

              width:
                  double.infinity,

              height: 58,

              child:
                  ElevatedButton(

                style:
                    ElevatedButton
                        .styleFrom(

                  backgroundColor:
                      AppColors.yellow,
                ),

                onPressed:
                    loading
                        ? null
                        : uploadKnowledge,

                child:
                    loading

                        ? const CircularProgressIndicator(
                            color:
                                Colors.black,
                          )

                        : const Text(

                            'UPLOAD KNOWLEDGE',

                            style:
                                TextStyle(

                              color:
                                  Colors.black,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }
}