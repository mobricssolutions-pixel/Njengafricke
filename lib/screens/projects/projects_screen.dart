import 'package:flutter/material.dart';

import 'package:appwrite/models.dart';

import '../../core/constants/app_constants.dart';

import '../../core/services/appwrite_service.dart';

import '../../core/services/project_service.dart';

import '../../core/theme/app_colors.dart';

class ProjectsScreen
    extends StatefulWidget {

  const ProjectsScreen({
    super.key,
  });

  @override
  State<ProjectsScreen>
      createState() =>
          _ProjectsScreenState();
}

class _ProjectsScreenState
    extends State<ProjectsScreen> {

  List<Document> projects = [];

  bool loading = true;

  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final categoryController =
      TextEditingController();

  final skillsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    loadProjects();
  }

  Future<void> loadProjects() async {

    final response =
        await AppwriteService.databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.projectsCollectionId,
    );

    setState(() {

      projects =
          response.documents;

      loading = false;
    });
  }

  Future<void> createProject() async {

    final skills =
        skillsController.text
            .split(',')

            .map(
              (e) => e.trim(),
            )

            .toList();

    await ProjectService.createProject(

      title:
          titleController.text.trim(),

      description:
          descriptionController.text.trim(),

      category:
          categoryController.text.trim(),

      requiredSkills: skills,
    );

    titleController.clear();

    descriptionController.clear();

    categoryController.clear();

    skillsController.clear();

    loadProjects();
  }

  Future<void> joinProject(
    String projectId,
  ) async {

    await ProjectService.joinProject(
      projectId: projectId,
    );

    loadProjects();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title:
            const Text(
              'Projects & Startups',
            ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller:
                  titleController,

              decoration:
                  const InputDecoration(
                hintText:
                    'Project Title',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  descriptionController,

              maxLines: 3,

              decoration:
                  const InputDecoration(
                hintText:
                    'Description',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  categoryController,

              decoration:
                  const InputDecoration(
                hintText:
                    'Category',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  skillsController,

              decoration:
                  const InputDecoration(
                hintText:
                    'Required skills separated by commas',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.yellow,
                ),

                onPressed:
                    createProject,

                child: const Text(
                  'CREATE PROJECT',
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
                              projects.length,

                          itemBuilder:
                              (context, index) {

                            final item =
                                projects[index];

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
                                    BorderRadius
                                        .circular(
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

                                  Text(

                                    item.data[
                                        'title'],

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

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Text(
                                    item.data[
                                        'description'],
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Text(
                                    item.data[
                                        'category'],
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Wrap(

                                    spacing: 8,

                                    children:

                                        (item.data[
                                                    'requiredSkills']
                                                as List)
                                            .map(
                                              (skill) {

                                                return Chip(
                                                  label:
                                                      Text(
                                                    skill,
                                                  ),
                                                );
                                              },
                                            )

                                            .toList(),
                                  ),

                                  const SizedBox(
                                    height: 15,
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
                                            AppColors
                                                .maroon,
                                      ),

                                      onPressed:
                                          () {

                                        joinProject(
                                          item.$id,
                                        );
                                      },

                                      child:
                                          const Text(
                                        'JOIN PROJECT',
                                      ),
                                    ),
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