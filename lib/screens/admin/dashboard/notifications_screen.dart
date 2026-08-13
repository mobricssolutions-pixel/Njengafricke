import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/appwrite_service.dart';
import '../../../core/theme/app_colors.dart';
import 'package:appwrite/appwrite.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  bool loading = true;

  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final result =
          await AppwriteService.databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId:
            AppConstants.notificationsCollectionId,
      );

      if (!mounted) return;

      setState(() {
        notifications = result.documents.reversed.toList();
        loading = false;
      });

      await markAllAsRead();

    } catch (e) {
      debugPrint('Notification Error: $e');

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> markAllAsRead() async {
    for (final notification in notifications) {
      if (notification.data['isRead'] == false) {
        await AppwriteService.databases.updateDocument(
          databaseId: AppConstants.databaseId,
          collectionId:
              AppConstants.notificationsCollectionId,
          documentId: notification.$id,
          data: {
            'isRead': true,
          },
        );
      }
    }
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.payments;

      case 'registration':
        return Icons.person_add;

      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.background,
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : notifications.isEmpty
              ? const Center(
                  child: Text(
                    'No notifications yet.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount:
                      notifications.length,

                  separatorBuilder:
                      (_, __) =>
                          const Divider(),

                  itemBuilder:
                      (context, index) {

                    final notification =
                        notifications[index];

                    return ListTile(
                      leading: Icon(
                        getIcon(
                          notification.data['type']
                                  ?.toString() ??
                              '',
                        ),
                        color: AppColors.yellow,
                      ),

                      title: Text(
                        notification.data['title']
                                ?.toString() ??
                            '',
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        notification.data['message']
                                ?.toString() ??
                            '',
                        style:
                            const TextStyle(
                          color:
                              Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}