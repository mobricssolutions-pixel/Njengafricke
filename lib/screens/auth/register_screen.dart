import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../waiting/waiting_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/appwrite_service.dart';
import '../../core/constants/app_constants.dart';

class RegisterScreen
    extends StatefulWidget {

  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final referralController =
      TextEditingController();

  bool loading = false;
  bool hidePassword = true;

  String generateReferralCode(
    String name,
  ) {

    final clean =
        name
            .replaceAll(' ', '')
            .toUpperCase();

    final timestamp =
        DateTime.now()
            .millisecondsSinceEpoch
            .toString()
            .substring(8);

    return '$clean$timestamp';
  }

bool isStrongPassword(String password) {
  return password.length >= 8;
}

  Future<void> registerUser() async {

    if (nameController.text
        .trim()
        .isEmpty) {

      showMessage(
        'Enter full name',
      );

      return;
    }

    if (emailController.text
        .trim()
        .isEmpty) {

      showMessage(
        'Enter email',
      );

      return;
    }

    if (phoneController.text
        .trim()
        .isEmpty) {

      showMessage(
        'Enter phone number',
      );

      return;
    }

if (!isStrongPassword(
    passwordController.text.trim(),
)) {

  showMessage(
    'Password must contain:\n'
    '• At least 8 characters\n'
    '• One uppercase letter\n'
    '• One lowercase letter\n'
    '• One number\n'
    '• One special character (@\$!%*?&)',
  );

  return;
} 

    try {

      setState(() {
        loading = true;
      });

      final user =
          await AppwriteService
              .account
              .create(
        userId: ID.unique(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
      );

      // LOGIN USER IMMEDIATELY
      await AppwriteService.account.createEmailPasswordSession(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final myReferralCode =
          generateReferralCode(
        nameController.text.trim(),
      );

      String referredBy = '';

      // CHECK REFERRAL CODE

      if (referralController.text
          .trim()
          .isNotEmpty) {

        try {

          final users =
              await AppwriteService
                  .databases
                  .listDocuments(

            databaseId:
                AppConstants.databaseId,

            collectionId:
                AppConstants
                    .usersCollectionId,
          );

          for (var doc
              in users.documents) {

            if (doc.data['referralCode'] ==
                referralController.text
                    .trim()
                    .toUpperCase()) {

              referredBy =
                  doc.data['userId'];

              int oldPoints =
                  doc.data['referralPoints']
                      ?? 0;

              await AppwriteService
                  .databases
                  .updateDocument(

                databaseId:
                    AppConstants.databaseId,

                collectionId:
                    AppConstants
                        .usersCollectionId,

                documentId:
                    doc.$id,

                data: {

                  'referralPoints':
                      oldPoints + 1,
                },
              );

              break;
            }
          }

        } catch (e) {

          print(
            'REFERRAL ERROR: $e',
          );
        }
      }

      await AppwriteService.databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.usersCollectionId,
        documentId: user.$id,
        data: {
          'userId': user.$id,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),

          // PROFILE
          'profession': '',
          'bio': '',
          'skills': [],
          'hobbies': [],
          'talents': [],

          // MEMBERSHIP
          'paidMember': false,
          'approved': false,
          'role': 'user',

          // REFERRALS
          'referralCode': myReferralCode,
          'referredBy': referredBy,
          'referralPoints': 0,
          'totalEarnings': 0,

          // AUDIT
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      // CREATE ADMIN NOTIFICATION

        try {
          await AppwriteService.databases.createDocument(
            databaseId: AppConstants.databaseId,
            collectionId: AppConstants.notificationsCollectionId,
            documentId: ID.unique(),
            data: {
              'title': 'New User Registration',
              'message':
                  '${nameController.text.trim()} created an account and is awaiting approval.',
              'type': 'registration',
              'userId': user.$id,
              'userName': nameController.text.trim(),
              'email': emailController.text.trim(),
              'phone': phoneController.text.trim(),
              'isRead': false,
              'createdAt': DateTime.now().toIso8601String(),
            },
          );
        } catch (e) {
          debugPrint('Notification Error: $e');
        }
    
if (mounted) {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        'Registration successful. Wait for admin approval.',
      ),
    ),
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const WaitingScreen(),
    ),
  );
}

} on AppwriteException catch (e) {

  if (e.code == 409) {

    showMessage(
      'This email is already registered. Please login instead.',
    );

  } else {

    showMessage(
      e.message ?? 'Registration Failed',
    );
  }

} catch (e) {

  showMessage(
    'Something went wrong',
  );

} finally {

  if (mounted) {

    setState(() {
      loading = false;
    });
  }
}
} // registerUser ends here
  void showMessage(
    String message,
  ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget buildField({

    required TextEditingController
        controller,

    required String hint,

    bool obscure = false,

    TextInputType keyboardType =
        TextInputType.text,
  }) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 20,
      ),

      child: TextField(

        controller: controller,

        obscureText:
          hint == 'Password'
              ? hidePassword
              : obscure,

        keyboardType:
            keyboardType,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle:
              const TextStyle(
            color:
                Colors.white70,
          ),

          filled: true,

          fillColor:
              AppColors.card,

              suffixIcon: hint == 'Password'
                ? IconButton(
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
                  )
                : null,

          contentPadding:
              const EdgeInsets.symmetric(

            horizontal: 20,

            vertical: 18,
          ),

          border:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              16,
            ),

            borderSide:
                BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              16,
            ),

            borderSide:
                const BorderSide(
              color:
                  AppColors.maroon,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              16,
            ),

            borderSide:
                const BorderSide(

              color:
                  AppColors.yellow,

              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    referralController.dispose();
    super.dispose();
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
          'Create Account',
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(
            20,
          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(
                height: 20,
              ),

              const Text(

                'Join Njengafricke',

                style: TextStyle(

                  fontSize: 32,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      AppColors.yellow,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(

                'Innovation • Collaboration • Opportunities',

                style: TextStyle(
                  color:
                      Colors.white70,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              buildField(

                controller:
                    nameController,

                hint: 'Full Name',
              ),

              buildField(

                controller:
                    emailController,

                hint: 'Email',

                keyboardType:
                    TextInputType.emailAddress,
              ),

              buildField(

                controller:
                    phoneController,

                hint: 'Phone Number',

                keyboardType:
                    TextInputType.phone,
              ),

              Padding(
  padding: const EdgeInsets.only(bottom: 20),
  child: TextField(
    controller: passwordController,
    obscureText: hidePassword,
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: InputDecoration(
      hintText: 'Password',
      hintStyle: const TextStyle(
        color: Colors.white70,
      ),
      filled: true,
      fillColor: AppColors.card,

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

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.maroon,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.yellow,
          width: 2,
        ),
      ),
    ),
  ),
),

              buildField(

                controller:
                    referralController,

                hint:
                    'Referral Code (Optional)',
              ),

              const SizedBox(
                height: 10,
              ),

              SizedBox(

                width:
                    double.infinity,

                height: 58,

                child:
                    ElevatedButton(

                  style:
                      ElevatedButton
                          .styleFrom(

                    backgroundColor:
                        AppColors
                            .maroon,

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
                          : registerUser,

                  child:
                      loading

                          ? const SizedBox(

                              height: 25,

                              width: 25,

                              child:
                                  CircularProgressIndicator(

                                color:
                                    Colors.white,

                                strokeWidth:
                                    2,
                              ),
                            )

                          : const Text(

                              'REGISTER',

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
                height: 20,
              ),

              const Center(

                child: Text(

                  'Only approved paid members can access Njengafricke.',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    color:
                        Colors.white60,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Container(

                width:
                    double.infinity,

                padding:
                    const EdgeInsets.all(
                  20,
                ),

                decoration:
                    BoxDecoration(

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

                child: const Column(

                  children: [

                    Icon(

                      Icons.share,

                      color:
                          AppColors.yellow,

                      size: 40,
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Text(

                      'Earn By Inviting Builders',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(

                        color:
                            AppColors.yellow,

                        fontSize: 20,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(

                      'Invite people into Njengafricke using your referral code and earn points when they join. Future payments inside the platform can later translate into real earnings.',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(

                        color:
                            Colors.white70,

                        height: 1.6,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}