import 'package:flutter/material.dart';

import 'package:appwrite/models.dart'
    show Document;
import 'package:appwrite/appwrite.dart';
import '../../../core/constants/app_constants.dart';

import '../../../core/services/appwrite_service.dart';

import '../../../core/theme/app_colors.dart';

class ManageUsersScreen
    extends StatefulWidget {

  const ManageUsersScreen({
    super.key,
  });

  @override
  State<ManageUsersScreen>
      createState() =>
          _ManageUsersScreenState();
}

class _ManageUsersScreenState
    extends State<ManageUsersScreen> {

  List<Document> users = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadUsers();
  }

  Future<void> loadUsers() async {

    final response =
        await AppwriteService
            .databases
            .listDocuments(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants
              .usersCollectionId,
    );

    setState(() {

      users =
          response.documents;

      loading = false;
    });
  }

  Future<void> togglePaidStatus(
    Document user,
  ) async {

    final currentStatus =
        user.data['paidMember'] ?? false;

    final newStatus = !currentStatus;

    await AppwriteService
        .databases
        .updateDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants.usersCollectionId,

      documentId:
          user.$id,

      data: {

        'paidMember': newStatus,

        'approved': newStatus,
      },
    );

    if (newStatus) {

      await AppwriteService
          .databases
          .createDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .notificationsCollectionId,

        documentId:
            ID.unique(),

        data: {

          'title':
              'Payment Approved',

          'message':
              'Your Njengafricke membership has been activated. Welcome!',

          'userId':
              user.$id,

          'isRead':
              false,

          'createdAt':
              DateTime.now()
                  .toIso8601String(),
        },
      );
    }

    loadUsers();
  }

  Future<void> toggleApprovalStatus(
    Document user,
  ) async {

    final currentStatus =
        user.data['approved']
            ?? false;

    await AppwriteService
        .databases
        .updateDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants
              .usersCollectionId,

      documentId:
          user.$id,

      data: {

        'approved':
            !currentStatus,
      },
    );

    loadUsers();
  }

  Future<void> changeRole(
    Document user,
    String role,
  ) async {

    await AppwriteService
        .databases
        .updateDocument(

      databaseId:
          AppConstants.databaseId,

      collectionId:
          AppConstants
              .usersCollectionId,

      documentId:
          user.$id,

      data: {

        'role': role,
      },
    );

    loadUsers();
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
          'Manage Users',
        ),
      ),

      body:
          loading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : ListView.builder(

                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  itemCount:
                      users.length,

                  itemBuilder:
                      (context, index) {

                    final user =
                        users[index];

                    final paidMember =
                        user.data[
                                'paidMember']
                            ?? false;

                    final approved =
                        user.data[
                                'approved']
                            ?? false;

                    final role =
                        user.data['role']
                            ?? 'user';

                    return Container(

                      margin:
                          const EdgeInsets.only(
                        bottom: 18,
                      ),

                      padding:
                          const EdgeInsets.all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            AppColors.card,

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        border: Border.all(
                          color:
                              AppColors.maroon,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors.black
                                    .withOpacity(
                              0.3,
                            ),

                            blurRadius: 8,

                            offset:
                                const Offset(
                              0,
                              4,
                            ),
                          ),
                        ],
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Row(

                            children: [

                              CircleAvatar(

                                backgroundColor:
                                    AppColors
                                        .maroon,

                                child:
                                    const Icon(

                                  Icons.person,

                                  color:
                                      AppColors
                                          .yellow,
                                ),
                              ),

                              const SizedBox(
                                width: 14,
                              ),

                              Expanded(

                                child: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(

                                      user.data['name'] ??
                                          'No Name',

                                      style:
                                          const TextStyle(

                                        fontSize:
                                            20,

                                        fontWeight:
                                            FontWeight
                                                .bold,

                                        color:
                                            AppColors
                                                .yellow,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Text(

                                      user.data['email'] ??
                                          '',

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors
                                                .white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          Row(

                            children: [

                              Container(

                                padding:
                                    const EdgeInsets.symmetric(

                                  horizontal: 12,

                                  vertical: 8,
                                ),

                                decoration:
                                    BoxDecoration(

                                  color:
                                      paidMember
                                          ? Colors.green
                                          : Colors.red,

                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                ),

                                child: Text(

                                  paidMember
                                      ? 'PAID MEMBER'
                                      : 'NOT PAID',

                                  style:
                                      const TextStyle(

                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              Container(

                                padding:
                                    const EdgeInsets.symmetric(

                                  horizontal: 12,

                                  vertical: 8,
                                ),

                                decoration:
                                    BoxDecoration(

                                  color:
                                      approved
                                          ? Colors.green
                                          : Colors.orange,

                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                ),

                                child: Text(

                                  approved
                                      ? 'APPROVED'
                                      : 'PENDING',

                                  style:
                                      const TextStyle(

                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Row(

                            children: [

                              Expanded(

                                child:
                                    ElevatedButton(

                                  style:
                                      ElevatedButton
                                          .styleFrom(

                                    backgroundColor:
                                        paidMember
                                            ? Colors.green
                                            : Colors.red,
                                  ),

                                  onPressed: () {

                                    togglePaidStatus(
                                      user,
                                    );
                                  },

                                  child: Text(

                                    paidMember
                                        ? 'REMOVE PAID'
                                        : 'MAKE PAID',
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              Expanded(

                                child:
                                    ElevatedButton(

                                  style:
                                      ElevatedButton
                                          .styleFrom(

                                    backgroundColor:
                                        approved
                                            ? Colors.green
                                            : Colors.orange,
                                  ),

                                  onPressed: () {

                                    toggleApprovalStatus(
                                      user,
                                    );
                                  },

                                  child: Text(

                                    approved
                                        ? 'APPROVED'
                                        : 'APPROVE',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          DropdownButtonFormField<
                              String>(

                            value: role,

                            dropdownColor:
                                AppColors.card,

                            decoration:
                                InputDecoration(

                              filled: true,

                              fillColor:
                                  AppColors.background,

                              border:
                                  OutlineInputBorder(

                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                            ),

                            items: const [

                              DropdownMenuItem(

                                value: 'user',

                                child: Text(
                                  'User',
                                ),
                              ),

                              DropdownMenuItem(

                                value: 'admin',

                                child: Text(
                                  'Admin',
                                ),
                              ),

                              DropdownMenuItem(

                                value: 'minorAdmin',

                                child: Text(
                                  'MinorAdmin',
                                ),
                              ),
                            ],

                            onChanged:
                                (value) {

                              if (value !=
                                  null) {

                                changeRole(
                                  user,
                                  value,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}