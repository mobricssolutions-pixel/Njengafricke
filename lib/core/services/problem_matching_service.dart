import '../constants/app_constants.dart';

import 'appwrite_service.dart';

class ProblemMatchingService {

  static Future<List<dynamic>>
      getMatchedProblems() async {

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

    final problems =
        await AppwriteService.databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.problemsCollectionId,
    );

    List<dynamic> matchedProblems = [];

    for (var doc in problems.documents) {

      List<dynamic> problemTags =
          doc.data['tags'] ?? [];

      int score = 0;

      for (var tag in problemTags) {

        if (userTags.contains(tag)) {
          score++;
        }
      }

      if (score > 0) {

        matchedProblems.add({

          'title': doc.data['title'],

          'description':
              doc.data['description'],

          'category':
              doc.data['category'],

          'location':
              doc.data['location'],

          'score': score,
        });
      }
    }

    matchedProblems.sort(

      (a, b) => b['score']
          .compareTo(a['score']),
    );

    return matchedProblems;
  }
}