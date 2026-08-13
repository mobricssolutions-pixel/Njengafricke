import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import '../../core/theme/app_colors.dart';
import '../../core/services/tag_engine_service.dart';
import '../../core/services/appwrite_service.dart';
import '../../core/constants/app_constants.dart';

class ProfileSetupScreen extends StatefulWidget {

  const ProfileSetupScreen({
    super.key,
  });

  @override
  State<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState
    extends State<ProfileSetupScreen> {

  final skillsController =
      TextEditingController();

  final talentsController =
      TextEditingController();

  final hobbiesController =
      TextEditingController();

  final abilitiesController =
      TextEditingController();

  bool loading = false;

  Future<void> saveProfile() async {

  try {

    setState(() {
      loading = true;
    });

    final currentUser =
        await AppwriteService
            .account
            .get();

    final combinedText = '''

    ${skillsController.text}

    ${talentsController.text}

    ${hobbiesController.text}

    ${abilitiesController.text}

    ''';

    final generatedTags =
        await TagEngineService
            .generateTags(
      combinedText,
    );

    print(
      'Generated Tags: $generatedTags',
    );

    await AppwriteService
        .databases
        .updateDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.usersCollectionId,

      documentId:
          currentUser.$id,

      data: {

        'skills':

            skillsController.text

                .split(',')

                .map(
                  (e) => e.trim(),
                )

                .where(
                  (e) => e.isNotEmpty,
                )

                .toList(),

        'talents':

            talentsController.text

                .split(',')

                .map(
                  (e) => e.trim(),
                )

                .where(
                  (e) => e.isNotEmpty,
                )

                .toList(),

        'hobbies':

            hobbiesController.text

                .split(',')

                .map(
                  (e) => e.trim(),
                )

                .where(
                  (e) => e.isNotEmpty,
                )

                .toList(),

        'abilities':

            abilitiesController.text

                .split(',')

                .map(
                  (e) => e.trim(),
                )

                .where(
                  (e) => e.isNotEmpty,
                )

                .toList(),

        'tags':
            generatedTags,
      },
    );

    if (mounted) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text('Profile Saved'),
        ),
      );
    }

  } on AppwriteException catch (e) {

    print(
      'APPWRITE ERROR: ${e.message}',
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(
          e.message ??
              'Error Saving Profile',
        ),
      ),
    );

  } finally {

    if (mounted) {

      setState(() {
        loading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Your Capabilities',
        ),
      ),

      backgroundColor:
          AppColors.background,

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            buildField(
              controller:
                  skillsController,
              hint:
                  'Skills (comma separated)',
            ),

            const SizedBox(
              height: 20,
            ),

            buildField(
              controller:
                  talentsController,
              hint: 'Talents',
            ),

            const SizedBox(
              height: 20,
            ),

            buildField(
              controller:
                  hobbiesController,
              hint: 'Hobbies',
            ),

            const SizedBox(
              height: 20,
            ),

            buildField(
              controller:
                  abilitiesController,
              hint: 'Abilities',
            ),

            const SizedBox(
              height: 40,
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

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),

                onPressed:
                    loading
                        ? null
                        : saveProfile,

                child:
                    loading

                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )

                        : const Text(

                            'SAVE PROFILE',

                            style: TextStyle(

                              color:
                                  Colors.white,

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

  Widget buildField({

    required TextEditingController
        controller,

    required String hint,
  }) {

    return TextField(

      controller: controller,

      maxLines: 3,

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
}