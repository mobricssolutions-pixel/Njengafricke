import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/appwrite_service.dart';

import '../models/contribution_model.dart';
import '../models/fundraiser_model.dart';
import '../screens/contribute_screen.dart';
import '../services/fundraising_service.dart';

class FundraiserDetailsScreen extends StatefulWidget {
  final FundraiserModel fundraiser;

  const FundraiserDetailsScreen({
    super.key,
    required this.fundraiser,
  });

  @override
  State<FundraiserDetailsScreen> createState() =>
      _FundraiserDetailsScreenState();
}

class _FundraiserDetailsScreenState
    extends State<FundraiserDetailsScreen> {

  final FundraisingService _service =
      FundraisingService();

  bool _loadingPermissions = true;

  bool _isOwner = false;

  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

Future<void> _loadPermissions() async {
  try {
    final user = await AppwriteService.account.get();

    _isOwner =
        widget.fundraiser.creatorId == user.$id;

    final document =
        await AppwriteService.databases.getDocument(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.usersCollectionId,
      documentId: user.$id,
    );

    _isAdmin =
        document.data['role'] == 'admin';
  } catch (e) {
    debugPrint(
      'Permission check failed: $e',
    );
  }

  if (mounted) {
    setState(() {
      _loadingPermissions = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {

    final fundraiser = widget.fundraiser;

    final progress = fundraiser.progress;

    final canViewContacts =
        _isOwner || _isAdmin;

        if (_loadingPermissions) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fundraiser"),
      ),
      body: ListView(
        children: [
          /// Cover Image
          if (fundraiser.imageUrl != null &&
              fundraiser.imageUrl!.isNotEmpty)
            Image.network(
              fundraiser.imageUrl!,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  fundraiser.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Chip(
                  label: Text(
                    fundraiser.category,
                  ),
                ),

                const SizedBox(height: 20),

                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Text(
                      "Raised",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    Text(
                      "KES ${fundraiser.currentAmount.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Text(
                      "Goal",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    Text(
                      "KES ${fundraiser.goalAmount.toStringAsFixed(0)}",
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  "Description",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  fundraiser.description,
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 20),

                const Text(
                  "Verified Contributors",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                FutureBuilder<
                    List<ContributionModel>>(
                  future:
                      FundraisingService()
                          .getProjectContributions(
                    fundraiser.id!,
                  ),
                  builder:
                      (context, snapshot) {
                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return const Padding(
                        padding:
                            EdgeInsets.all(
                                20),
                        child: Center(
                          child:
                              CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot
                        .hasError) {
                      return Card(
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .all(16),
                          child: Text(
                            snapshot.error
                                .toString(),
                          ),
                        ),
                      );
                    }

                    final contributors =
                        (snapshot.data ??
                                [])
                            .where(
                              (c) =>
                                  c.isVerified,
                            )
                            .toList();

                    if (contributors
                        .isEmpty) {
                      return const Card(
                        child: Padding(
                          padding:
                              EdgeInsets.all(
                                  16),
                          child: Text(
                            "No verified contributors yet.\nBe the first to support this fundraiser.",
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          contributors
                              .length,
                      separatorBuilder:
                          (_, __) =>
                              const Divider(),
                      itemBuilder:
                          (context, index) {
                        final c =
                            contributors[
                                index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: ListTile(

                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),

                            title: Text(
                              c.supporterName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                const SizedBox(height: 4),

                                if (canViewContacts) ...[

                                  Row(
                                    children: [

                                      const Icon(
                                        Icons.phone,
                                        size: 16,
                                      ),

                                      const SizedBox(width: 6),

                                      Expanded(
                                        child: Text(
                                          c.supporterPhone,
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (c.supporterEmail != null &&
                                      c.supporterEmail!.isNotEmpty)

                                    Padding(
                                      padding:
                                          const EdgeInsets.only(
                                        top: 4,
                                      ),
                                      child: Row(
                                        children: [

                                          const Icon(
                                            Icons.email,
                                            size: 16,
                                          ),

                                          const SizedBox(width: 6),

                                          Expanded(
                                            child: Text(
                                              c.supporterEmail!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  const SizedBox(height: 6),

                                ],

                                Row(
                                  children: const [

                                    Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                      size: 16,
                                    ),

                                    SizedBox(width: 6),

                                    Text(
                                      "Verified Contribution",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                if (!canViewContacts)

                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Contact information is only visible to the fundraiser owner and administrators.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            trailing: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [

                                const Text(
                                  "Amount",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),

                                Text(
                                  "KES ${c.amount.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child:
                      ElevatedButton.icon(
                    icon: const Icon(
                      Icons.favorite,
                    ),
                    label: const Text(
                      "Contribute",
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ContributeScreen(
                            fundraiser:
                                fundraiser,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}