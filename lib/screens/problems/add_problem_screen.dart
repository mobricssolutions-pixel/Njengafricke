import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../../core/services/tag_engine_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/appwrite_service.dart';
import '../../core/constants/app_constants.dart';

class AddProblemScreen extends StatefulWidget {
  const AddProblemScreen({super.key});

  @override
  State<AddProblemScreen> createState() =>
      _AddProblemScreenState();
}

class _AddProblemScreenState
    extends State<AddProblemScreen> {

  final titleController = TextEditingController();

  final descriptionController =
      TextEditingController();

  final categoryController =
      TextEditingController();

  final locationController =
      TextEditingController();

  bool loading = false;

  Future<void> submitProblem() async {

    try {

      setState(() {
        loading = true;
      });

      final currentUser =
          await AppwriteService.account.get();

      final combinedText = '''

      ${titleController.text}

      ${descriptionController.text}

      ${categoryController.text}

      ''';

      final generatedTags =
          await TagEngineService
              .generateTags(combinedText);

      await AppwriteService.databases.createDocument(

        databaseId: AppConstants.databaseId,

        collectionId:
            AppConstants.problemsCollectionId,

        documentId: ID.unique(),

        data: {

          'title':
              titleController.text.trim(),

          'description':
              descriptionController.text.trim(),

          'category':
              categoryController.text.trim(),

          'location':
              locationController.text.trim(),

          'createdBy': currentUser.$id,

          'createdAt':
              DateTime.now().toString(),

          'tags': 
              generatedTags,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Problem Submitted'),
        ),
      );

      Navigator.pop(context);

    } on AppwriteException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Submission Failed',
          ),
        ),
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Report Problem',
        ),
      ),

      backgroundColor: AppColors.background,

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            buildField(
              titleController,
              'Problem Title',
            ),

            const SizedBox(height: 20),

            buildField(
              descriptionController,
              'Describe the Problem',
              lines: 5,
            ),

            const SizedBox(height: 20),

            buildField(
              categoryController,
              'Category',
            ),

            const SizedBox(height: 20),

            buildField(
              locationController,
              'Location',
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.maroon,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),

                onPressed:
                    loading
                        ? null
                        : submitProblem,

                child:
                    loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'SUBMIT PROBLEM',
                            style: TextStyle(
                              color: Colors.white,
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

  Widget buildField(
    TextEditingController controller,
    String hint, {
    int lines = 1,
  }) {

    return TextField(

      controller: controller,

      maxLines: lines,

      decoration: InputDecoration(

        hintText: hint,

        filled: true,

        fillColor: AppColors.card,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }
}