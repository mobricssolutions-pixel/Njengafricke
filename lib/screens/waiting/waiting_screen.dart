import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appwrite/appwrite.dart';
import '../../core/constants/app_constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../../core/services/appwrite_service.dart';
import '../../core/theme/app_colors.dart';
import '../payments/submit_payment_screen.dart';
import '../auth/login_screen.dart';
import '../landing/landing_screen.dart';

class WaitingScreen extends StatefulWidget {

  const WaitingScreen({
    super.key,
  });

  @override
  State<WaitingScreen> createState() =>
      _WaitingScreenState();
}

class _WaitingScreenState
    extends State<WaitingScreen> {

  late RealtimeSubscription subscription;

  @override
  void initState() {
    super.initState();
    listenForApproval();
  }

  Future<void> listenForApproval() async {
    try {

      final currentUser =
          await AppwriteService.account.get();

      subscription =
          AppwriteService.realtime.subscribe([

        'databases.${AppConstants.databaseId}.collections.${AppConstants.usersCollectionId}.documents.${currentUser.$id}',

      ]);

      subscription.stream.listen((event) {

        final data = event.payload;

        bool paidMember =
            data['paidMember'] ?? false;

        bool approved =
            data['approved'] ?? false;

        if (paidMember &&
            approved) {

          ScaffoldMessenger.of(context)
              .showSnackBar(

            const SnackBar(

              backgroundColor:
                  Colors.green,

              content: Text(
                '🎉 Payment verified. Welcome to Njengafricke!',
              ),
            ),
          );

          Future.delayed(
            const Duration(seconds: 2),
            () {

              if (!mounted) {
                return;
              }

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const DashboardScreen(),
                ),
              );
            },
          );
        }
      });

    } catch (e) {

      debugPrint(
        'Realtime Error: $e',
      );
    }
  }

  Future<void> signOut(
    BuildContext context,
  ) async {

    await AppwriteService
        .account
        .deleteSession(

      sessionId: 'current',
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
  }

  Future<void> contactAdmin() async {

    final Uri url = Uri.parse(
      'https://wa.me/254799480784',
    );

    await launchUrl(

      url,

      mode:
          LaunchMode.externalApplication,
    );
  }

  void goToLandingPage(
    BuildContext context,
  ) {

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const LandingScreen(),
      ),

      (route) => false,
    );
  }

  @override
  void dispose() {

    subscription.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
                const EdgeInsets.all(
              24,
            ),

            child: Column(

              children: [

                const SizedBox(
                  height: 20,
                ),

                // TOP BAR

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    const Text(

                      'Njengafricke',

                      style: TextStyle(

                        color:
                            AppColors.yellow,

                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Row(

                      children: [

                        IconButton(

                          onPressed: () {

                            goToLandingPage(
                              context,
                            );
                          },

                          icon: const Icon(

                            Icons.home,

                            color:
                                AppColors.yellow,
                          ),
                        ),

                        IconButton(

                          onPressed: () {

                            signOut(context);
                          },

                          icon: const Icon(

                            Icons.logout,

                            color:
                                AppColors.yellow,
                          ),
                        )
                      ],
                    )
                  ],
                ),

                const SizedBox(
                  height: 50,
                ),

                // MAIN PREMIUM CARD

                Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(
                    30,
                  ),

                  decoration: BoxDecoration(

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
                      32,
                    ),

                    border: Border.all(

                      color:
                          AppColors.yellow
                              .withOpacity(
                        0.3,
                      ),
                    ),

                    boxShadow: [

                      BoxShadow(

                        color:
                            Colors.black
                                .withOpacity(
                          0.6,
                        ),

                        blurRadius: 25,

                        offset:
                            const Offset(
                          0,
                          12,
                        ),
                      )
                    ],
                  ),

                  child: Column(

                    children: [

                      // ICON

                      Container(

                        padding:
                            const EdgeInsets.all(
                          24,
                        ),

                        decoration:
                            BoxDecoration(

                          color:
                              AppColors.yellow
                                  .withOpacity(
                            0.12,
                          ),

                          shape:
                              BoxShape.circle,
                        ),

                        child: const Icon(

                          Icons.workspace_premium,

                          size: 80,

                          color:
                              AppColors.yellow,
                        ),
                      ),

                      const SizedBox(
                        height: 35,
                      ),

                      // TITLE

                      const Text(

                        'Njengafricke Pilot Access',

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(

                          color:
                              Colors.white,

                          fontSize: 32,

                          fontWeight:
                              FontWeight.bold,

                          height: 1.3,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // DESCRIPTION

                      const Text(
                        'Welcome to the Njengafricke Pilot Test.\n\n'
                        'To join the pilot program, pay a one-time pilot fee of KSh 100 using the Till Number below. '
                        'After payment, submit your M-Pesa confirmation code using the button below.\n\n'
                        'Your account will be approved once your payment has been verified.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.8,
                        ),
                      ),

                      const SizedBox(
                        height: 35,
                      ),

                      // PRICE CARD

                      Container(

                        width: double.infinity,

                        padding:
                            const EdgeInsets.all(
                          24,
                        ),

                        decoration:
                            BoxDecoration(

                          color:
                              AppColors.card,

                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),
                        ),

child: Column(
  children: [

    const Text(
      'NJENGAFRICKE PILOT TEST',
      style: TextStyle(
        color: AppColors.yellow,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    ),

    const SizedBox(height: 18),

    const Text(
      'Normal Membership',
      style: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
    ),

    const SizedBox(height: 6),

    const Text(
      'KSh 500 / Year',
      style: TextStyle(
        decoration: TextDecoration.lineThrough,
        color: Colors.white54,
        fontSize: 22,
      ),
    ),

    const SizedBox(height: 20),

    const Text(
      'Pilot Test Fee',
      style: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
    ),

    const SizedBox(height: 6),

    const Text(
      'KSh 100',
      style: TextStyle(
        color: AppColors.yellow,
        fontWeight: FontWeight.bold,
        fontSize: 46,
      ),
    ),

    const SizedBox(height: 25),

    Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.yellow,
        ),
      ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  const Text(
                                    "HOW TO PAY",
                                    style: TextStyle(
                                      color: AppColors.yellow,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                 const Text(
                                    "1. Open M-Pesa.",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                 const Text(
                                    "2. Select Lipa na M-Pesa.",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),

                                 const SizedBox(height: 8),

                                 const Text(
                                    "3. Select Buy Goods & Services.",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Text(
                                    "4. Enter Till Number:",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),

                                 const SizedBox(height: 6),

                                 Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.maroon,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.yellow,
                                      ),
                                    ),
                                    child: const Text(
                                      "5121303",
                                      style: TextStyle(
                                        color: AppColors.yellow,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),

                                 const SizedBox(height: 12),

                                 const Text(
                                    "5. Enter Amount:",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),

                                 const SizedBox(height: 6),

                                 const Text(
                                    "KSh 100",
                                    style: TextStyle(
                                      color: AppColors.yellow,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                                  ),

                                 const SizedBox(height: 16),

                                 const Text(
                                    "After payment, send the M-Pesa confirmation message to the BuildAfri WhatsApp admin. Your account will be activated after payment verification.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              "This KSh 100 pilot fee gives you early access to the BuildAfri Pilot Test before the official launch.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 35,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.maroon,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const SubmitPaymentScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.payments,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'SUBMIT PAYMENT CONFIRMATION',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.yellow,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                          ),
                          onPressed: () {
                            contactAdmin();
                          },
                          icon: const Icon(
                            Icons.chat,
                            color: AppColors.yellow,
                          ),
                          label: const Text(
                            'NEED HELP? CONTACT ADMIN',
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // BACK TO LANDING PAGE

                      SizedBox(

                        width: double.infinity,

                        child: OutlinedButton.icon(

                          style:
                              OutlinedButton.styleFrom(

                            side: const BorderSide(

                              color:
                                  AppColors.yellow,
                            ),

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 18,
                            ),

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                          ),

                          onPressed: () {

                            goToLandingPage(
                              context,
                            );
                          },

                          icon: const Icon(

                            Icons.arrow_back,

                            color:
                                AppColors.yellow,
                          ),

                          label: const Text(

                            'BACK TO LANDING PAGE',

                            style: TextStyle(

                              color:
                                  AppColors.yellow,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // SIGN OUT BUTTON

                      SizedBox(

                        width: double.infinity,

                        child: TextButton.icon(

                          onPressed: () {

                            signOut(context);
                          },

                          icon: const Icon(

                            Icons.logout,

                            color:
                                Colors.white70,
                          ),

                          label: const Text(

                            'SIGN OUT',

                            style: TextStyle(

                              color:
                                  Colors.white70,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // FOOTER TEXT

                const Text(

                  'BuildAfri exists to help Africa build businesses, solve problems, create opportunities, and raise a generation of innovators.',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(

                    color:
                        Colors.white70,

                    fontSize: 16,

                    height: 1.8,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}