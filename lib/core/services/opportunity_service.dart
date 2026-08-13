import 'package:appwrite/appwrite.dart';

import '../constants/app_constants.dart';
import 'appwrite_service.dart';

class OpportunityService {
  /// Latest opportunities for landing page
  static Future<List<dynamic>> getLatestOpportunities() async {
    final response =
        await AppwriteService.databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.opportunitiesCollectionId,
      queries: [
        Query.orderDesc('createdAt'),
        Query.limit(10),
      ],
    );

    return response.documents;
  }

  /// Opportunities matched to the logged in user
  static Future<List<dynamic>> getMatchedOpportunities() async {
    final currentUser =
        await AppwriteService.account.get();

    final userDoc =
        await AppwriteService.databases.getDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.usersCollectionId,
      documentId: currentUser.$id,
    );

    List<dynamic> userTags =
        userDoc.data['tags'] ?? [];

    final opportunities =
        await AppwriteService.databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId:
          AppConstants.opportunitiesCollectionId,
    );

    List<dynamic> matched = [];

    for (var doc in opportunities.documents) {
      List<dynamic> requiredTags =
          doc.data['requiredTags'] ?? [];

      int score = 0;

      for (var tag in requiredTags) {
        if (userTags.contains(tag)) {
          score++;
        }
      }

      if (score > 0) {
        matched.add({
          'title': doc.data['title'],
          'description': doc.data['description'],
          'score': score,
          'document': doc,
        });
      }
    }

    matched.sort(
      (a, b) =>
          (b['score'] as int).compareTo(a['score'] as int),
    );

    return matched;
  }
}