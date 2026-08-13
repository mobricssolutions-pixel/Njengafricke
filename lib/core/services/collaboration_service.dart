import '../constants/app_constants.dart';

import 'appwrite_service.dart';

class CollaborationService {

  static Future<List<dynamic>>
      findCollaborators() async {

    try {

      final currentUser =
          await AppwriteService
              .account
              .get();

      final currentUserDoc =
          await AppwriteService
              .databases
              .getDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .usersCollectionId,

        documentId:
            currentUser.$id,
      );

      List<dynamic> myTags =

          currentUserDoc
                  .data['tags'] ??
              [];

      final users =
          await AppwriteService
              .databases
              .listDocuments(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .usersCollectionId,
      );

      List<dynamic> collaborators = [];

      for (var doc
          in users.documents) {

        if (doc.$id ==
            currentUser.$id) {

          continue;
        }

        List<dynamic> userTags =

            doc.data['tags'] ??
                [];

        int score = 0;

        for (var tag
            in userTags) {

          if (myTags.contains(tag)) {

            score++;
          }
        }

        if (score > 0) {

          collaborators.add({

            'userId': doc.$id,

            'name':
                doc.data['name'] ??
                    'Unknown User',

            'profession':

                doc.data['profession'] ??
                    'No profession',

            'bio':
                doc.data['bio'] ??
                    'No bio',

            'score': score,

            'tags': userTags,
          });
        }
      }

      collaborators.sort(

        (a, b) =>

            b['score']
                .compareTo(
              a['score'],
            ),
      );

      return collaborators;

    } catch (e) {

      print(
        'COLLABORATION ERROR: $e',
      );

      return [];
    }
  }
}