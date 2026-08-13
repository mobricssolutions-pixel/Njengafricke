import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/appwrite_service.dart';
import '../../../core/theme/app_colors.dart';

class PendingActivationsScreen extends StatefulWidget {
  const PendingActivationsScreen({super.key});

  @override
  State<PendingActivationsScreen> createState() =>
      _PendingActivationsScreenState();
}

class _PendingActivationsScreenState
    extends State<PendingActivationsScreen> {
  bool loading = true;

  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    loadPendingUsers();
  }

  Future<void> loadPendingUsers() async {
    try {
      final result =
          await AppwriteService.databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.usersCollectionId,
      );

      final pendingUsers =
          result.documents.where((doc) {
        final paidMember =
            doc.data['paidMember'] ?? false;

        final approved =
            doc.data['approved'] ?? false;

        return !paidMember || !approved;
      }).toList();

      if (!mounted) return;

      setState(() {
        users = pendingUsers
            .map(
              (doc) => {
                'id': doc.$id,
                'name': doc.data['name'] ?? '',
                'phone': doc.data['phone'] ?? '',
                'email': doc.data['email'] ?? '',
                'createdAt':
                    doc.data['createdAt'] ?? '',
                'paidMember':
                    doc.data['paidMember'] ?? false,
                'approved':
                    doc.data['approved'] ?? false,
              },
            )
            .toList();

        loading = false;
      });
    } catch (e) {
      debugPrint(
        'Pending Activations Error: $e',
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> openWhatsApp(
    String phone,
    String name,
  ) async {
    final cleanedPhone =
        phone.replaceAll('+', '');

    final message =
        'Hello $name. Your Njengafricke account is still pending activation. Complete activation to access opportunities, collaboration and fundraising features.';

    final uri = Uri.parse(
      'https://wa.me/$cleanedPhone?text=${Uri.encodeComponent(message)}',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> sendSMS(
    String phone,
    String name,
  ) async {
    final uri = Uri.parse(
      'sms:$phone?body=${Uri.encodeComponent(
        'Hello $name. Your Njengafricke account is still pending activation.',
      )}',
    );

    await launchUrl(uri);
  }

  Widget buildUserCard(
    Map<String, dynamic> user,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.maroon,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            user['name'],
            style: const TextStyle(
              color: AppColors.yellow,
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            user['phone'],
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          Text(
            user['email'],
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: user['paidMember']
                      ? Colors.green
                      : Colors.red,
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
                child: Text(
                  user['paidMember']
                      ? 'Paid'
                      : 'Not Paid',
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: user['approved']
                      ? Colors.green
                      : Colors.orange,
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
                child: Text(
                  user['approved']
                      ? 'Approved'
                      : 'Pending',
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.message,
                  ),
                  label:
                      const Text('WhatsApp'),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green,
                  ),
                  onPressed: () {
                    openWhatsApp(
                      user['phone'],
                      user['name'],
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.sms,
                  ),
                  label: const Text('SMS'),
                  onPressed: () {
                    sendSMS(
                      user['phone'],
                      user['name'],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
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
          'Pending Activations',
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : users.isEmpty
              ? const Center(
                  child: Text(
                    'No pending activations',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh:
                      loadPendingUsers,
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),
                    itemCount:
                        users.length,
                    itemBuilder:
                        (context, index) {
                      return buildUserCard(
                        users[index],
                      );
                    },
                  ),
                ),
    );
  }
}