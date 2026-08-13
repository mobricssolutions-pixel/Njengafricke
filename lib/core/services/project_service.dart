import 'package:appwrite/appwrite.dart';

import '../constants/app_constants.dart';

import 'appwrite_service.dart';

class ProjectService {

  static Future<void> createProject({

    required String title,

    required String description,

    required String category,

    required List<String> requiredSkills,
  }) async {

    final currentUser =
        await AppwriteService.account.get();

    await AppwriteService.databases
        .createDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.projectsCollectionId,

      documentId: ID.unique(),

      data: {

        'title': title,

        'description':
            description,

        'creatorId':
            currentUser.$id,

        'requiredSkills':
            requiredSkills,

        'members': [
          currentUser.$id,
        ],

        'category':
            category,

        'createdAt':
            DateTime.now().toString(),
      },
    );
  }

static Future<List<dynamic>> getProjects() async {
  final response = await AppwriteService.databases.listDocuments(
    databaseId: AppConstants.databaseId,
    collectionId: AppConstants.projectsCollectionId,
    queries: [
      Query.orderDesc('createdAt'),
      Query.limit(10),
    ],
  );

  return response.documents;
}

  static Future<void> joinProject({

    required String projectId,
  }) async {

    final currentUser =
        await AppwriteService.account.get();

    final project =
        await AppwriteService.databases
            .getDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.projectsCollectionId,

      documentId: projectId,
    );

    List members =
        project.data['members'];

    if (!members.contains(
        currentUser.$id)) {

      members.add(currentUser.$id);

      await AppwriteService.databases
          .updateDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants.projectsCollectionId,

        documentId: projectId,

        data: {
          'members': members,
        },
      );
    }
  }
}