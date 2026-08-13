import '../constants/app_constants.dart';

import 'appwrite_service.dart';

class BusinessIdeaService {

  static Future<List<dynamic>>
      generateIdeas() async {

    final currentUser =
        await AppwriteService.account.get();

    final userDoc =
        await AppwriteService.databases.getDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.usersCollectionId,

      documentId: currentUser.$id,
    );

    List<dynamic> userTags =
        userDoc.data['tags'] ?? [];

    final ideas =
        await AppwriteService.databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants
              .businessIdeasCollectionId,
    );

    List<dynamic> matchedIdeas = [];

    for (var doc in ideas.documents) {

      List<dynamic> requiredTags =
          doc.data['requiredTags'];

      int score = 0;

      for (var tag in requiredTags) {

        if (userTags.contains(tag)) {
          score++;
        }
      }

      if (score > 0) {

        matchedIdeas.add({

          'title': doc.data['title'],

          'description':
              doc.data['description'],

          'score': score,
        });
      }
    }

    matchedIdeas.sort(

      (a, b) => b['score']
          .compareTo(a['score']),
    );

    return matchedIdeas;
  }
}