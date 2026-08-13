import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ai/ai_mentor_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/appwrite_service.dart';
import '../../core/constants/app_constants.dart';
import '../auth/login_screen.dart';
import '../business/business_ideas_screen.dart';
import '../collaboration/collaborators_screen.dart';
import '../projects/projects_screen.dart';
import '../problems/add_problem_screen.dart';
import '../problems/matched_problems_screen.dart';
import '../admin/dashboard/admin_gate_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../opportunities/opportunities_screen.dart';
import '../fundraising/screens/fundraising_screen.dart';
import '../fundraising/screens/my_fundraisers_screen.dart';
import '../admin/fundraising/pending_fundraisers_screen.dart';
import '../admin/fundraising/pending_contributions_screen.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  int totalProjects = 0;

  int totalCollaborators = 0;

  int referralPoints = 0;

  int totalReferrals = 0;

  int totalEarnings = 0;

  String referralCode = '';

  String userName = '';

  bool loadingStats = true;

  @override
  void initState() {

    super.initState();

    loadDashboardStats();
  }

  Future<void> loadDashboardStats() async {

    try {

      final currentUser =
          await AppwriteService
              .account
              .get();

      // LOAD PROJECTS

      final projectsResponse =
          await AppwriteService
              .databases
              .listDocuments(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .projectsCollectionId,
      );

      final myProjects =

          projectsResponse.documents.where(
        (doc) {

          return
              doc.data['createdBy'] ==
              currentUser.$id;
        },
      ).toList();

      // LOAD USERS

      final usersResponse =
          await AppwriteService
              .databases
              .listDocuments(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .usersCollectionId,
      );

      dynamic currentUserDoc;

      try {

        currentUserDoc =
            usersResponse.documents.firstWhere(

          (doc) {

            return
                doc.data['userId'] ==
                currentUser.$id;
          },
        );

      } catch (e) {

        print(
          'CURRENT USER DOCUMENT NOT FOUND',
        );

        if (mounted) {

          setState(() {

            loadingStats = false;
          });
        }

        return;
      }

      List myTags =
          currentUserDoc.data['tags']
              ?? [];

      int collaboratorsCount = 0;

      for (var user
          in usersResponse.documents) {

        if (user.data['userId'] ==
            currentUser.$id) {

          continue;
        }

        List userTags =
            user.data['tags'] ?? [];

        bool matched = false;

        for (var tag
            in userTags) {

          if (myTags.contains(tag)) {

            matched = true;

            break;
          }
        }

        if (matched) {

          collaboratorsCount++;
        }
      }

      if (mounted) {

        setState(() {

          totalProjects =
              myProjects.length;

          totalCollaborators =
              collaboratorsCount;

          referralPoints =
              currentUserDoc
                      .data['referralPoints']
                  ?? 0;

          totalReferrals = usersResponse.documents.where((doc) {
            return doc.data['referredBy'] == currentUser.$id &&
                  (doc.data['paidMember'] ?? false) == true &&
                  (doc.data['approved'] ?? false) == true;
          }).length;

          totalEarnings = totalReferrals * 10;

          referralCode =
              currentUserDoc
                      .data['referralCode']
                  ?? '';

          userName =
              currentUserDoc
                      .data['name']
                  ?? '';

          loadingStats = false;
        });
      }

    } catch (e) {

      print(
        'DASHBOARD STATS ERROR: $e',
      );

      if (mounted) {

        setState(() {

          loadingStats = false;
        });
      }
    }
  }

  void copyReferralCode() {

    Clipboard.setData(
      ClipboardData(
        text: referralCode,
      ),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        backgroundColor:
            Colors.green,

        content: Text(
          'Referral code copied',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      drawer: Drawer(

        backgroundColor:
            AppColors.background,

        child: SafeArea(

          child: Column(

            children: [

              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  24,
                ),

                decoration:
                    const BoxDecoration(

                  color:
                      AppColors.maroon,
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(

                      'Njengafricke',

                      style: TextStyle(

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            AppColors.yellow,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(

                      userName,

                      style: const TextStyle(
                        color:
                            Colors.white,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(

                      'Innovation • Opportunities • Collaboration',

                      style: TextStyle(
                        color:
                            Colors.white70,
                      ),
                    )
                  ],
                ),
              ),

              Expanded(

                child: ListView(

                  padding:
                      const EdgeInsets.all(
                    12,
                  ),

                  children: [

                    buildDrawerItem(

                      icon:
                          Icons.lightbulb,

                      title:
                          'Business Ideas',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const BusinessIdeasScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.report_problem,

                      title:
                          'Report Problem',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const AddProblemScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.public,

                      title:
                          'Problems To Solve',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                MatchedProblemsScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.auto_awesome,

                      title:
                          'Opportunities',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const OpportunitiesScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.groups,

                      title:
                          'Collaborators',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const CollaboratorsScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.rocket_launch,

                      title:
                          'Projects',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const ProjectsScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon: Icons.volunteer_activism,

                      title: 'Fundraising',

                      onTap: () {

                        Navigator.pop(context);

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const FundraisingScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon: Icons.account_balance_wallet,

                      title: 'My Fundraisers',

                      onTap: () {

                        Navigator.pop(context);

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const MyFundraisersScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.admin_panel_settings,

                      title:
                          'Admin Panel',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const AdminGateScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(
                      color:
                          Colors.white24,
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.person,

                      title:
                          'Profile',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const ProfileScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.settings,

                      title:
                          'Settings',

                      onTap: () {

                        Navigator.pop(
                          context,
                        );

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const SettingsScreen(),
                          ),
                        );
                      },
                    ),

                    buildDrawerItem(

                      icon:
                          Icons.logout,

                      title:
                          'Logout',

                      onTap: () async {

                        Navigator.pop(
                          context,
                        );

                        await AppwriteService
                            .account
                            .deleteSession(

                          sessionId:
                              'current',
                        );

                        if (context.mounted) {

                          Navigator.pushAndRemoveUntil(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  const LoginScreen(),
                            ),

                            (route) => false,
                          );
                        }
                      },
                    ),
                    
                    buildDrawerItem(

                    icon: Icons.smart_toy,

                    title: 'AI Mentor',

                    onTap: () {

                      Navigator.pop(context);

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              const AiMentorScreen(),
                        ),
                      );
                    },
                  ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      appBar: AppBar(

        backgroundColor:
            AppColors.background,

        elevation: 0,

        title: const Text(

          'Njengafricke',

          style: TextStyle(

            color:
                AppColors.yellow,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(

        child:
            SingleChildScrollView(

          padding:
              const EdgeInsets.all(
            20,
          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              buildHeader(),

              const SizedBox(
                height: 25,
              ),

              buildReferralCard(),

              const SizedBox(
                height: 25,
              ),

              buildStartBuildingCard(),

              const SizedBox(
                height: 25,
              ),

              loadingStats
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : buildStatsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(
        24,
      ),

      decoration: BoxDecoration(

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

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(

            'Innovation • Opportunities • Collaboration',

            style: TextStyle(

              fontSize: 16,

              color:
                  Colors.white70,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(

            'Build. Earn. Grow.',

            style: TextStyle(

              fontSize: 34,

              fontWeight:
                  FontWeight.bold,

              color:
                  AppColors.yellow,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          const Text(

            'Invite builders into Njengafricke and earn referral points that can later convert into real earnings after payment approval.',

            style: TextStyle(

              color:
                  Colors.white70,

              fontSize: 16,

              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReferralCard() {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration: BoxDecoration(

        color:
            AppColors.card,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        border: Border.all(
          color:
              AppColors.yellow,
        ),

        boxShadow: [

          BoxShadow(

            color:
                AppColors.yellow
                    .withOpacity(
              0.15,
            ),

            blurRadius: 20,

            spreadRadius: 1,
          )
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Row(

            children: [

              Icon(

                Icons.workspace_premium,

                color:
                    AppColors.yellow,

                size: 30,
              ),

              SizedBox(
                width: 12,
              ),

              Text(

                'Referral Rewards',

                style: TextStyle(

                  color:
                      AppColors.yellow,

                  fontSize: 24,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          Container(

            width: double.infinity,

            padding:
                const EdgeInsets.all(
              18,
            ),

            decoration: BoxDecoration(

              color:
                  Colors.black,

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(

                  'YOUR REFERRAL CODE',

                  style: TextStyle(

                    color:
                        Colors.white54,

                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(

                  children: [

                    Expanded(

                      child: Text(

                        referralCode,

                        style:
                            const TextStyle(

                          color:
                              AppColors.yellow,

                          fontSize: 28,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(

                      onPressed:
                          copyReferralCode,

                      icon: const Icon(

                        Icons.copy,

                        color:
                            AppColors.yellow,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(

            children: [

              Expanded(

                child: buildReferralStat(

                  'Points',

                  referralPoints
                      .toString(),

                  Icons.stars,
                ),
              ),

              const SizedBox(
                width: 15,
              ),

              Expanded(

                child: buildReferralStat(

                  'Referrals',

                  totalReferrals
                      .toString(),

                  Icons.people,
                ),
              ),

             const SizedBox(
                width: 15,
              ),

              Expanded(

                child: buildReferralStat(

                  'KES.',

                  totalEarnings
                      .toString(),

                  Icons.account_balance_wallet,
                ),
              ),

            ],
          ),

          const SizedBox(
            height: 18,
          ),

          const Text(

            'Each successful referral increases your reward points. These points covert to money every week',

            style: TextStyle(

              color:
                  Colors.white70,

              height: 1.6,
            ),
          )
        ],
      ),
    );
  }

  Widget buildStartBuildingCard() {

  return Container(

    width: double.infinity,

    padding: const EdgeInsets.all(22),

    decoration: BoxDecoration(

      color: AppColors.card,

      borderRadius: BorderRadius.circular(24),

      border: Border.all(
        color: AppColors.maroon,
      ),

    ),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Row(

          children: [

            Icon(

              Icons.volunteer_activism,

              color: AppColors.yellow,

              size: 30,

            ),

            SizedBox(width: 12),

            Text(

              "START BUILDING",

              style: TextStyle(

                color: AppColors.yellow,

                fontSize: 24,

                fontWeight: FontWeight.bold,

              ),

            ),

          ],

        ),

        const SizedBox(height: 18),

        const Text(

          "Every successful business, farm, invention, school project, or community initiative begins with one decision: to start. Create a fundraising project, tell your story, and let your community invest in your vision.",

          style: TextStyle(

            color: Colors.white70,

            height: 1.6,

            fontSize: 16,

          ),

        ),

        const SizedBox(height: 20),

        Wrap(

          spacing: 10,

          runSpacing: 10,

          children: const [

            Chip(
              label: Text("Business"),
            ),

            Chip(
              label: Text("Farming"),
            ),

            Chip(
              label: Text("School Fees"),
            ),

            Chip(
              label: Text("Technology"),
            ),

            Chip(
              label: Text("Manufacturing"),
            ),

            Chip(
              label: Text("Community Projects"),
            ),

          ],

        ),

        const SizedBox(height: 25),

        SizedBox(

          width: double.infinity,

        ),

      ],

    ),

  );

}

  Widget buildReferralStat(

    String title,

    String value,

    IconData icon,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(

        color:
            Colors.black,

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: Column(

        children: [

          Icon(

            icon,

            color:
                AppColors.yellow,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(

            value,

            style:
                const TextStyle(

              color:
                  AppColors.yellow,

              fontSize: 26,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(

            title,

            style: const TextStyle(
              color:
                  Colors.white70,
            ),
          )
        ],
      ),
    );
  }

  Widget buildStatsSection() {

    return Row(

      children: [

        Expanded(

          child: buildStatCard(

            'Projects',

            totalProjects.toString(),

            Icons.rocket_launch,
          ),
        ),

        const SizedBox(
          width: 15,
        ),

        Expanded(

          child: buildStatCard(

            'Collaborators',

            totalCollaborators
                .toString(),

            Icons.groups,
          ),
        ),
      ],
    );
  }

  Widget buildStatCard(

    String title,

    String value,

    IconData icon,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(

        color:
            AppColors.card,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color:
              AppColors.maroon,
        ),
      ),

      child: Column(

        children: [

          Icon(

            icon,

            size: 40,

            color:
                AppColors.yellow,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(

            value,

            style:
                const TextStyle(

              fontSize: 28,

              fontWeight:
                  FontWeight.bold,

              color:
                  AppColors.yellow,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(

            title,

            style: const TextStyle(
              color:
                  Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget buildDrawerItem({

    required IconData icon,

    required String title,

    required VoidCallback onTap,
  }) {

    return ListTile(

      leading: Icon(

        icon,

        color:
            AppColors.yellow,
      ),

      title: Text(

        title,

        style: const TextStyle(
          color:
              Colors.white,
        ),
      ),

      onTap: onTap,
    );
  }
}