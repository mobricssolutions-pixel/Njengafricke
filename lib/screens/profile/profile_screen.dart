import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/appwrite_service.dart';
import '../../core/services/tag_engine_service.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen
    extends StatefulWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  bool loading = true;

  final nameController =
      TextEditingController();

  final professionController =
      TextEditingController();

  final bioController =
      TextEditingController();

  final skillsController =
      TextEditingController();

  final hobbiesController =
      TextEditingController();

  final talentsController =
      TextEditingController();

  final abilitiesController =
      TextEditingController();

  final tagsController =
      TextEditingController();

  String documentId = '';

  @override
  void initState() {

    super.initState();

    loadProfile();
  }

  Future<void> loadProfile() async {

    try {

      final user =
          await AppwriteService
              .account
              .get();

      final response =
          await AppwriteService
              .databases
              .listDocuments(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .usersCollectionId,
      );

      dynamic currentUser;

      try {

        currentUser =
            response.documents.firstWhere(

          (doc) =>
              doc.data['userId'] ==
              user.$id,
        );

      } catch (e) {

        setState(() {
          loading = false;
        });

        return;
      }

      documentId =
          currentUser.$id;

      nameController.text =
          currentUser.data['name'] ?? '';

      professionController.text =
          currentUser.data['profession'] ?? '';

      bioController.text =
          currentUser.data['bio'] ?? '';

      skillsController.text =
          (currentUser.data['skills']
                  as List?)

              ?.join(', ') ??

              '';

      hobbiesController.text =
          (currentUser.data['hobbies']
                  as List?)

              ?.join(', ') ??

              '';

      talentsController.text =
          (currentUser.data['talents']
                  as List?)

              ?.join(', ') ??

              '';

      abilitiesController.text =
          (currentUser.data['abilities']
                  as List?)

              ?.join(', ') ??

              '';

      tagsController.text =
          (currentUser.data['tags']
                  as List?)

              ?.join(', ') ??

              '';

      setState(() {

        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            ErrorHandler.getMessage(e),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> updateProfile() async {

    try {

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

      tagsController.text =
          generatedTags.join(', ');

      await AppwriteService
          .databases
          .updateDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .usersCollectionId,

        documentId:
            documentId,

        data: {

          'name':
              nameController.text
                  .trim(),

          'profession':
              professionController
                  .text
                  .trim(),

          'bio':
              bioController.text
                  .trim(),

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
                Text('Profile Updated'),
          ),
        );
      }

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            ErrorHandler.getMessage(e),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget buildField({

    required String label,

    required TextEditingController
        controller,

    int lines = 1,
  }) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: TextField(

        controller: controller,

        maxLines: lines,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          labelText: label,

          labelStyle:
              const TextStyle(
            color:
                Colors.white70,
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
      ),
    );
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
          'Profile',
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

                      CircleAvatar(

                        radius: 55,

                        backgroundColor:
                            AppColors.maroon,

                        child: const Icon(

                          Icons.person,

                          size: 65,

                          color:
                              AppColors.yellow,
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      buildField(

                        label: 'Name',

                        controller:
                            nameController,
                      ),

                      buildField(

                        label:
                            'Profession',

                        controller:
                            professionController,
                      ),

                      buildField(

                        label: 'Bio',

                        controller:
                            bioController,

                        lines: 4,
                      ),

                      buildField(

                        label:
                            'Skills (comma separated)',

                        controller:
                            skillsController,
                      ),

                      buildField(

                        label:
                            'Hobbies (comma separated)',

                        controller:
                            hobbiesController,
                      ),

                      buildField(

                        label:
                            'Talents (comma separated)',

                        controller:
                            talentsController,
                      ),

                      buildField(

                        label:
                            'Abilities (comma separated)',

                        controller:
                            abilitiesController,
                      ),

                      buildField(

                        label:
                            'Generated Tags',

                        controller:
                            tagsController,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.maroon,
                            foregroundColor: Colors.white, // Makes text and icon white
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: updateProfile,
                          child: const Text(
                            'UPDATE PROFILE',
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
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