import 'package:appwrite/appwrite.dart';

import '../constants/app_constants.dart';
import 'appwrite_service.dart';

class ChatService {

  static Future<String> createChat(
    String otherUserId,
  ) async {

    try {

      final currentUser =
          await AppwriteService
              .account
              .get();

      final existingChats =
          await AppwriteService
              .databases
              .listDocuments(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .chatsCollectionId,
      );

      for (var chat
          in existingChats.documents) {

        List members =
            chat.data['members'] ?? [];

        if (

            members.contains(
              currentUser.$id,
            ) &&

            members.contains(
              otherUserId,
            )

        ) {

          return chat.$id;
        }
      }

      final newChat =
          await AppwriteService
              .databases
              .createDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .chatsCollectionId,

        documentId:
            ID.unique(),

        data: {

          'members': [

            currentUser.$id,

            otherUserId,
          ],

          'lastMessage': '',

          'updatedAt':
              DateTime.now()
                  .toIso8601String(),
        },
      );

      print(
        'CHAT CREATED: ${newChat.$id}',
      );

      return newChat.$id;

    } catch (e) {

      print(
        'CREATE CHAT ERROR: $e',
      );

      rethrow;
    }
  }

  static Future<void> sendMessage({

    required String chatId,

    required String message,
  }) async {

    try {

      final currentUser =
          await AppwriteService
              .account
              .get();

      print(
        'Sending to chat: $chatId',
      );

      await AppwriteService
          .databases
          .createDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .messagesCollectionId,

        documentId:
            ID.unique(),

        data: {

          'chatId':
              chatId,

          'senderId':
              currentUser.$id,

          'message':
              message,

          'createdAt':
              DateTime.now()
                  .toIso8601String(),
        },
      );

      await AppwriteService
          .databases
          .updateDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .chatsCollectionId,

        documentId:
            chatId,

        data: {

          'lastMessage':
              message,

          'updatedAt':
              DateTime.now()
                  .toIso8601String(),
        },
      );

      print(
        'MESSAGE SENT SUCCESSFULLY',
      );

    } catch (e) {

      print(
        'SEND MESSAGE ERROR: $e',
      );

      rethrow;
    }
  }
}