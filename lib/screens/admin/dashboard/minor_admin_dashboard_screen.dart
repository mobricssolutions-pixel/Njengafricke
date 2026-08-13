import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../business/manage_business_ideas_screen.dart';
import '../opportunities/manage_opportunities_screen.dart';
import '../ai/manage_keywords_screen.dart';
import '../users/manage_users_screen.dart';
import 'admin_analytics_screen.dart';
import '../ai/admin_ai_upload_screen.dart';
import '../fundraising/pending_fundraisers_screen.dart';
import '../fundraising/pending_contributions_screen.dart';
import '../ai/generate_search_text_screen.dart';
import 'notifications_screen.dart';
import 'package:appwrite/appwrite.dart';
import '../../../core/services/appwrite_service.dart';
import '../../../core/constants/app_constants.dart';
import '../payments/pending_payments_screen.dart';
import 'pending_activations_screen.dart';

class MinorAdminDashboardScreen
    extends StatefulWidget {

  const MinorAdminDashboardScreen({
    super.key,
  });

  @override
  State<MinorAdminDashboardScreen>
      createState() =>
          _MinorAdminDashboardScreenState();
}

class _MinorAdminDashboardScreenState
    extends State<MinorAdminDashboardScreen>
    with TickerProviderStateMixin {

  late AnimationController glowController;

  late Animation<double> glowAnimation;

  int notificationCount = 0;

  RealtimeSubscription? notificationSubscription;



  @override
  void initState() {
    super.initState();

    loadNotifications();

    notificationSubscription =
        AppwriteService.realtime.subscribe([
      'databases.${AppConstants.databaseId}.collections.${AppConstants.notificationsCollectionId}.documents.*'
    ]);

    notificationSubscription?.stream.listen((event) {
      loadNotifications();
    });

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1,
    ).animate(glowController);
  }

  @override
  void dispose() {
    notificationSubscription?.close();
    glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Njengafricke Admin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.yellow,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const NotificationsScreen(),
                    ),
                  );
                },
              ),

              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(

          children: [

            // HERO SECTION

            AnimatedBuilder(

              animation:
                  glowAnimation,

              builder:
                  (context, child) {

                return Container(

                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  decoration:
                      BoxDecoration(

                    gradient:
                        const LinearGradient(

                      colors: [

                        AppColors.maroon,

                        Colors.black,
                      ],

                      begin:
                          Alignment.topLeft,

                      end:
                          Alignment.bottomRight,
                    ),

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
                            AppColors.yellow.withOpacity(
                          glowAnimation.value *
                              0.3,
                        ),

                        blurRadius:
                            35,

                        spreadRadius:
                            2,
                      ),
                    ],
                  ),

                  child: const Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(

                        'Njengafricke Control Center',

                        style: TextStyle(

                          color:
                              AppColors.yellow,

                          fontSize: 28,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 14,
                      ),

                      Text(

                        'Manage AI intelligence,  and the future of Africa’s builder economy.',

                        style: TextStyle(

                          color:
                              Colors.white70,

                          height: 1.6,

                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(
              height: 30,
            ),

            buildAdminCard(
            context: context,
            icon: Icons.campaign,
            title: 'Pending Activations',
            subtitle:
                'View users who have not activated and contact them directly.',
            onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        PendingActivationsScreen(),
                ),
                );
            },
            ),

            const SizedBox(height: 20),

            // AI KNOWLEDGE

            buildAdminCard(

              context: context,

              icon:
                  Icons.smart_toy_outlined,

              title:
                  'AI Knowledge Base',

              subtitle:
                  'Upload African intelligence, startup lessons, business wisdom, student-of-life teachings, and community knowledge for the AI Mentor.',

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const AdminAiUploadScreen(),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // KEYWORDS

            buildAdminCard(

              context: context,

              icon:
                  Icons.psychology_alt_rounded,

              title:
                  'Manage Keywords',

              subtitle:
                  'Expand Njengafricke intelligence engine and improve opportunity matching accuracy.',

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const ManageKeywordsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // OPPORTUNITIES

            buildAdminCard(

              context: context,

              icon:
                  Icons.workspaces_outline,

              title:
                  'Manage Opportunities',

              subtitle:
                  'Create and update business, project, investment, innovation, and employment opportunities.',

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const ManageOpportunitiesScreen(),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 20,
            ),
            // FOOTER

            AnimatedBuilder(

              animation:
                  glowAnimation,

              builder:
                  (context, child) {

                return Text(

                  'NJENGAFRICKE ADMIN SYSTEM',

                  style: TextStyle(

                    color:
                        AppColors.yellow,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 18,

                    letterSpacing: 2,

                    shadows: [

                      Shadow(

                        color:
                            AppColors.yellow.withOpacity(
                          glowAnimation.value,
                        ),

                        blurRadius:
                            20,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
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
        notificationCount = result.documents
            .where(
              (doc) =>
                  doc.data['isRead'] == false,
            )
            .length;
      });
    } catch (e) {
      debugPrint('Notification Error: $e');
    }
  }

  Widget buildAdminCard({

    required BuildContext context,

    required IconData icon,

    required String title,

    required String subtitle,

    required VoidCallback onTap,
  }) {

    return InkWell(

      borderRadius:
          BorderRadius.circular(
        22,
      ),

      onTap: onTap,

      child: AnimatedContainer(

        duration:
            const Duration(
          milliseconds: 250,
        ),

        width:
            double.infinity,

        padding:
            const EdgeInsets.all(
          22,
        ),

        decoration:
            BoxDecoration(

          color:
              AppColors.card,

          borderRadius:
              BorderRadius.circular(
            22,
          ),

          border: Border.all(

            color:
                AppColors.maroon,

            width: 1.5,
          ),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black.withOpacity(
                0.35,
              ),

              blurRadius:
                  15,

              offset:
                  const Offset(
                0,
                8,
              ),
            ),
          ],
        ),

        child: Row(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Container(

              padding:
                  const EdgeInsets.all(
                15,
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
                  18,
                ),

                boxShadow: [

                  BoxShadow(

                    color:
                        AppColors.yellow.withOpacity(
                      0.2,
                    ),

                    blurRadius:
                        15,

                    spreadRadius:
                        1,
                  ),
                ],
              ),

              child: Icon(

                icon,

                color:
                    AppColors.yellow,

                size: 30,
              ),
            ),

            const SizedBox(
              width: 18,
            ),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style:
                        const TextStyle(

                      fontSize: 21,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          AppColors.yellow,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(

                    subtitle,

                    style:
                        const TextStyle(

                      color:
                          Colors.white70,

                      height: 1.6,

                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            const Icon(

              Icons.arrow_forward_ios,

              color:
                  AppColors.yellow,

              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}