import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../../core/utils/error_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/appwrite_service.dart';
import '../../core/constants/app_constants.dart';
import '../auth/register_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../waiting/waiting_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;
  bool hidePassword = true;

  @override
  void initState() {

    super.initState();

    checkLoggedInUser();
  }

  // CHECK IF USER IS ALREADY LOGGED IN

  Future<void>
      checkLoggedInUser() async {
 
    try {

      final currentUser =
          await AppwriteService
              .account
              .get();

      final userDoc =
          await AppwriteService
              .databases
              .getDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .usersCollectionId,

        documentId:
            currentUser.$id,
      );

      bool paidMember =
          userDoc.data['paidMember']
              ?? false;

      bool approved =
          userDoc.data['approved']
              ?? false;

      if (!mounted) {
        return;
      }

      if (paidMember == true &&
          approved == true) {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const DashboardScreen(),
          ),
        );

      } else {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const WaitingScreen(),
          ),
        );
      }

    } catch (e) {

      // If there is no internet, tell the user.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(ErrorHandler.getMessage(e)),
          ),
        );
      }
    }
  }

  // LOGIN USER

  Future<void> loginUser() async {

    try {

      setState(() {

        loading = true;
      });

      await AppwriteService
          .account
          .createEmailPasswordSession(

        email:
            emailController.text
                .trim(),

        password:
            passwordController.text
                .trim(),
      );

      final currentUser =
          await AppwriteService
              .account
              .get();

      final userDoc =
          await AppwriteService
              .databases
              .getDocument(

        databaseId:
            AppConstants.databaseId,

        collectionId:
            AppConstants
                .usersCollectionId,

        documentId:
            currentUser.$id,
      );

      bool paidMember =
          userDoc.data['paidMember']
              ?? false;

      bool approved =
          userDoc.data['approved']
              ?? false;

      if (!mounted) {
        return;
      }

      if (paidMember == true &&
          approved == true) {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const DashboardScreen(),
          ),
        );

      } else {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const WaitingScreen(),
          ),
        );
      }

      } catch (e) {

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              ErrorHandler.getMessage(e),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {

      if (mounted) {

        setState(() {

          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            padding:
                const EdgeInsets.all(
              20,
            ),

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                // LOGO

                const Text(

                  'Njengafricke',

                  style: TextStyle(

                    fontSize: 40,

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

                  'Turn Problems Into Opportunities',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(

                    color:
                        Colors.white70,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                // LOGIN CARD

                Container(

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
                      24,
                    ),

                    border: Border.all(

                      color:
                          AppColors.maroon,
                    ),
                  ),

                  child: Column(

                    children: [

                      // EMAIL

                      TextField(

                        controller:
                            emailController,

                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                        ),

                        decoration:
                            InputDecoration(

                          hintText:
                              'Email',

                          hintStyle:
                              const TextStyle(
                            color:
                                Colors.white54,
                          ),

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
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // PASSWORD

                      TextField(

                        controller:
                            passwordController,

                        obscureText:
                            hidePassword,

                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                        ),

                        decoration:
                            InputDecoration(

                          hintText:
                              'Password',

                                suffixIcon: IconButton(
                                    icon: Icon(
                                      hidePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                  ),

                          hintStyle:
                              const TextStyle(
                            color:
                                Colors.white54,
                          ),

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
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // LOGIN BUTTON

                      SizedBox(

                        width:
                            double.infinity,

                        child:
                            ElevatedButton(

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                AppColors.maroon,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 18,
                            ),

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),

                          onPressed:
                              loading
                                  ? null
                                  : loginUser,

                          child:
                              loading

                                  ? const SizedBox(

                                      height:
                                          22,

                                      width:
                                          22,

                                      child:
                                          CircularProgressIndicator(

                                        color:
                                            Colors.white,

                                        strokeWidth:
                                            2.5,
                                      ),
                                    )

                                  : const Text(

                                      'LOGIN',

                                      style:
                                          TextStyle(

                                        color:
                                            Colors.white,

                                        fontWeight:
                                            FontWeight.bold,

                                        fontSize:
                                            16,
                                      ),
                                    ),
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // REGISTER BUTTON

                      TextButton(

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },

                        child: const Text(

                          'Create Account',

                          style: TextStyle(

                            color:
                                AppColors.yellow,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}