import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

import '../../core/services/appwrite_service.dart';

import '../../core/theme/app_colors.dart';

import '../auth/login_screen.dart';

class SettingsScreen
    extends StatefulWidget {

  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool loading = true;

  bool notifications = true;

  String name = '';

  String email = '';

  String role = '';

  bool paidMember = false;

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  Future<void> loadUserData() async {

    try {

      final user =
          await AppwriteService
              .account
              .get();

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

      final currentUser =
          response.documents.firstWhere(

        (doc) =>
            doc.data['userId'] ==
            user.$id,
      );

      setState(() {

        name =
            currentUser.data['name'] ??
                '';

        email =
            currentUser.data['email'] ??
                '';

        role =
            currentUser.data['role'] ??
                'user';

        paidMember =
            currentUser
                    .data['paidMember'] ??
                false;

        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> logout() async {

    await AppwriteService
        .account
        .deleteSession(
      sessionId: 'current',
    );

    if (mounted) {

      Navigator.pushAndRemoveUntil(

        context,

        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),

        (route) => false,
      );
    }
  }

  Widget buildTile({

    required IconData icon,

    required String title,

    String? subtitle,

    Widget? trailing,

    VoidCallback? onTap,
  }) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      decoration: BoxDecoration(

        color: AppColors.card,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              AppColors.maroon,
        ),
      ),

      child: ListTile(

        leading: Icon(
          icon,
          color: AppColors.yellow,
        ),

        title: Text(

          title,

          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        subtitle:
            subtitle != null

                ? Text(

                    subtitle,

                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                    ),
                  )

                : null,

        trailing: trailing,

        onTap: onTap,
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
          'Settings',
        ),
      ),

      body:
          loading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : SingleChildScrollView(

                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Container(

                        padding:
                            const EdgeInsets.all(
                          20,
                        ),

                        decoration:
                            BoxDecoration(

                          gradient:
                              const LinearGradient(

                            colors: [

                              AppColors.maroon,

                              Colors.black,
                            ],
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),
                        ),

                        child: Row(

                          children: [

                            CircleAvatar(

                              radius: 35,

                              backgroundColor:
                                  AppColors
                                      .yellow,

                              child: const Icon(

                                Icons.person,

                                size: 40,

                                color:
                                    Colors.black,
                              ),
                            ),

                            const SizedBox(
                              width: 20,
                            ),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(

                                    name,

                                    style:
                                        const TextStyle(

                                      fontSize:
                                          22,

                                      fontWeight:
                                          FontWeight
                                              .bold,

                                      color:
                                          Colors.white,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(

                                    email,

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Row(

                                    children: [

                                      Container(

                                        padding:
                                            const EdgeInsets.symmetric(

                                          horizontal:
                                              12,

                                          vertical:
                                              6,
                                        ),

                                        decoration:
                                            BoxDecoration(

                                          color:
                                              paidMember

                                                  ? Colors
                                                      .green

                                                  : Colors
                                                      .red,

                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),

                                        child: Text(

                                          paidMember

                                              ? 'PAID MEMBER'

                                              : 'NOT PAID',

                                          style:
                                              const TextStyle(

                                            fontWeight:
                                                FontWeight.bold,

                                            color:
                                                Colors.white,

                                            fontSize:
                                                12,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),

                                      Container(

                                        padding:
                                            const EdgeInsets.symmetric(

                                          horizontal:
                                              12,

                                          vertical:
                                              6,
                                        ),

                                        decoration:
                                            BoxDecoration(

                                          color:
                                              AppColors
                                                  .yellow,

                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),

                                        child: Text(

                                          role
                                              .toUpperCase(),

                                          style:
                                              const TextStyle(

                                            fontWeight:
                                                FontWeight.bold,

                                            color:
                                                Colors.black,

                                            fontSize:
                                                12,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      const Text(

                        'Preferences',

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight:
                              FontWeight.bold,

                          color:
                              AppColors.yellow,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      buildTile(

                        icon:
                            Icons.notifications,

                        title:
                            'Notifications',

                        subtitle:
                            'Receive updates and opportunities',

                        trailing: Switch(

                          value: notifications,

                          activeColor:
                              AppColors.yellow,

                          onChanged: (value) {

                            setState(() {

                              notifications =
                                  value;
                            });
                          },
                        ),
                      ),
                      buildTile(

                        icon:
                            Icons.security,

                        title:
                            'Privacy & Security',

                        subtitle:
                            'Manage account security',

                        onTap: () {

                          showDialog(

                            context: context,

                            builder: (_) {

                              return AlertDialog(

                                backgroundColor:
                                    AppColors.card,

                                title: const Text(
                                  'Privacy & Security',
                                ),

                                content: const Text(

                                  'Njengafricke protects your innovation data, opportunities, and collaborations.',

                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                actions: [

                                  TextButton(

                                    onPressed: () {

                                      Navigator.pop(context);
                                    },

                                    child: const Text(
                                      'OK',
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),

                      buildTile(

                        icon:
                            Icons.workspace_premium,

                        title:
                            'Membership',

                        subtitle:
                            paidMember

                                ? 'Premium access active'

                                : 'Awaiting activation',

                        onTap: () {

                          showDialog(

                            context: context,

                            builder: (_) {

                              return AlertDialog(

                                backgroundColor:
                                    AppColors.card,

                                title: const Text(
                                  'Membership Status',
                                ),

                                content: Text(

                                  paidMember

                                      ? 'Your Njengafricke premium membership is active.'

                                      : 'Your account is not yet activated by admin.',

                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                actions: [

                                  TextButton(

                                    onPressed: () {

                                      Navigator.pop(context);
                                    },

                                    child: const Text(
                                      'OK',
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),

                      buildTile(

                        icon: Icons.info,

                        title:
                            'About Njengafricke',

                        subtitle:
                            'Version 1.0.0',

                        onTap: () {

                          showAboutDialog(

                            context: context,

                            applicationName:
                                'Njengafricke',

                            applicationVersion:
                                '1.0.0',

                            applicationLegalese:
                                'Innovation Platform for Africa',

                            children: [

                              const Padding(

                                padding:
                                    EdgeInsets.only(
                                  top: 12,
                                ),

                                child: Text(

                                  'Njengafricke helps Africans transform community problems into opportunities, businesses, collaborations, and innovation.',

                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      SizedBox(

                        width:
                            double.infinity,

                        height: 55,

                        child:
                            ElevatedButton.icon(

                          style:
                              ElevatedButton
                                  .styleFrom(

                            backgroundColor:
                                Colors.red,

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),

                          onPressed: logout,

                          icon: const Icon(
                            Icons.logout,
                          ),

                          label: const Text(

                            'LOGOUT',

                            style: TextStyle(

                              fontWeight:
                                  FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}