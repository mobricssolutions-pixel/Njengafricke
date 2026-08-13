import '../constants/app_constants.dart';

import 'appwrite_service.dart';

class AdminService {

  static Future<bool> isAdmin() async {

    final currentUser =
        await AppwriteService.account.get();

    final userDoc =
        await AppwriteService.databases
            .getDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.usersCollectionId,

      documentId: currentUser.$id,
    );

    return userDoc.data['role'] == 'admin';
  }
}