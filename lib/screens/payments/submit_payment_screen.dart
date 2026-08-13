import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import '../../core/services/appwrite_service.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

class SubmitPaymentScreen extends StatefulWidget {
  const SubmitPaymentScreen({super.key});

  @override
  State<SubmitPaymentScreen> createState() =>
      _SubmitPaymentScreenState();
}

class _SubmitPaymentScreenState
    extends State<SubmitPaymentScreen> {

  final mpesaCodeController =
      TextEditingController();

  bool loading = false;

  Future<void> submitPayment() async {

    if (mpesaCodeController.text
        .trim()
        .isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            'Enter M-Pesa confirmation code',
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        loading = true;
      });

      final user =
          await AppwriteService.account.get();

      final userDoc =
          await AppwriteService.databases
              .getDocument(
        databaseId:
            AppConstants.databaseId,
        collectionId:
            AppConstants.usersCollectionId,
        documentId: user.$id,
      );

      await AppwriteService.databases
          .createDocument(
        databaseId:
            AppConstants.databaseId,
        collectionId:
            AppConstants
                .paymentsCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': user.$id,
          'name':
              userDoc.data['name'],
          'phone':
              userDoc.data['phone'],
          'mpesaCode':
              mpesaCodeController.text
                  .trim()
                  .toUpperCase(),
          'amount': 100,
          'status': 'pending',
          'createdAt': DateTime.now()
              .toIso8601String(),
        },
      );

      await AppwriteService.databases
          .createDocument(
        databaseId:
            AppConstants.databaseId,
        collectionId:
            AppConstants
                .notificationsCollectionId,
        documentId: ID.unique(),
        data: {
          'title':
              'Payment Submitted',
          'message':
              '${userDoc.data['name']} submitted payment ${mpesaCodeController.text.trim().toUpperCase()}',
          'type': 'payment',
          'isRead': false,
          'createdAt': DateTime.now()
              .toIso8601String(),
        },
      );

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            backgroundColor:
                Colors.green,
            content: Text(
              'Payment submitted successfully. Waiting for verification.',
            ),
          ),
        );

        Navigator.pop(context);
      }

    } on AppwriteException catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.message ??
                'Failed to submit payment',
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            'Something went wrong',
          ),
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
  void dispose() {

    mpesaCodeController.dispose();

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
          'Submit Payment',
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(24),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const SizedBox(
              height: 20,
            ),

            const Text(

              'Payment Confirmation',

              style: TextStyle(

                color:
                    AppColors.yellow,

                fontSize: 28,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(

              'Enter the M-Pesa confirmation code you received after paying KSh 100.',

              style: TextStyle(

                color:
                    Colors.white70,

                height: 1.6,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            TextField(

              controller:
                  mpesaCodeController,

              textCapitalization:
                  TextCapitalization
                      .characters,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
                  InputDecoration(

                hintText:
                    'Example: QHG7K4P2M',

                hintStyle:
                    const TextStyle(
                  color:
                      Colors.white60,
                ),

                filled: true,

                fillColor:
                    AppColors.card,

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

            const SizedBox(
              height: 30,
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
                      AppColors.maroon,

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
                        : submitPayment,

                child:
                    loading

                        ? const SizedBox(

                            height: 24,

                            width: 24,

                            child:
                                CircularProgressIndicator(

                              color:
                                  Colors.white,

                              strokeWidth:
                                  2,
                            ),
                          )

                        : const Text(

                            'SUBMIT PAYMENT',

                            style:
                                TextStyle(

                              color:
                                  Colors.white,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}