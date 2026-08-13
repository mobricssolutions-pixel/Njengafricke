import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/appwrite_service.dart';
import '../../../core/theme/app_colors.dart';

class PendingPaymentsScreen extends StatefulWidget {
  const PendingPaymentsScreen({super.key});

  @override
  State<PendingPaymentsScreen> createState() =>
      _PendingPaymentsScreenState();
}

class _PendingPaymentsScreenState
    extends State<PendingPaymentsScreen> {

  bool loading = true;

  List<dynamic> payments = [];

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      final result =
          await AppwriteService.databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId:
            AppConstants.paymentsCollectionId,
        queries: [
          Query.equal('status', 'pending'),
        ],
      );

      if (!mounted) return;

      setState(() {
        payments = result.documents;
        loading = false;
      });
    } catch (e) {
      debugPrint('Payment Load Error: $e');

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> approvePayment(
    dynamic payment,
  ) async {
    try {
      await AppwriteService.databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId:
            AppConstants.paymentsCollectionId,
        documentId: payment.$id,
        data: {
          'status': 'approved',
        },
      );

      await AppwriteService.databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId:
            AppConstants.usersCollectionId,
        documentId: payment.data['userId'],
        data: {
          'paidMember': true,
          'approved': true,
        },
      );

      await AppwriteService.databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId:
            AppConstants.notificationsCollectionId,
        documentId: ID.unique(),
        data: {
          'title': 'Payment Approved',
          'message':
              '${payment.data['name']} has been approved.',
          'type': 'payment_approved',
          'isRead': false,
          'createdAt':
              DateTime.now().toIso8601String(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Payment approved successfully.',
          ),
        ),
      );

      loadPayments();
    } catch (e) {
      debugPrint('Approve Error: $e');
    }
  }

  Future<void> rejectPayment(
    dynamic payment,
  ) async {
    try {
      await AppwriteService.databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId:
            AppConstants.paymentsCollectionId,
        documentId: payment.$id,
        data: {
          'status': 'rejected',
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Payment rejected.',
          ),
        ),
      );

      loadPayments();
    } catch (e) {
      debugPrint('Reject Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Pending Payments',
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : payments.isEmpty
              ? const Center(
                  child: Text(
                    'No pending payments.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount: payments.length,
                  itemBuilder:
                      (context, index) {

                    final payment =
                        payments[index];

                    return Card(
                      color: AppColors.card,
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Text(
                              payment.data['name']
                                      ?.toString() ??
                                  '',
                              style:
                                  const TextStyle(
                                color: AppColors
                                    .yellow,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              'Phone: ${payment.data['phone']}',
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),

                            Text(
                              'Amount: KES ${payment.data['amount']}',
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),

                            Text(
                              'M-Pesa Code: ${payment.data['mpesaCode']}',
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
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
                                          Colors
                                              .green,
                                    ),
                                    onPressed: () {
                                      approvePayment(
                                        payment,
                                      );
                                    },
                                    child:
                                        const Text(
                                      'APPROVE',
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
                                          Colors.red,
                                    ),
                                    onPressed: () {
                                      rejectPayment(
                                        payment,
                                      );
                                    },
                                    child:
                                        const Text(
                                      'REJECT',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}