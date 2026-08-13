import 'package:flutter/material.dart';
import '../../fundraising/models/fundraiser_model.dart';
import '../../fundraising/models/approval_model.dart';
import '../../fundraising/services/fundraising_service.dart';

class FundraiserReviewScreen extends StatefulWidget {
  final FundraiserModel fundraiser;

  const FundraiserReviewScreen({
    super.key,
    required this.fundraiser,
  });

  @override
  State<FundraiserReviewScreen> createState() =>
      _FundraiserReviewScreenState();
}

class _FundraiserReviewScreenState
    extends State<FundraiserReviewScreen> {

  final FundraisingService _service = FundraisingService();
  final TextEditingController _reasonController = TextEditingController();

  late Future<ApprovalModel?> _approvalFuture;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _approvalFuture = _service.getApprovalForItem(
      widget.fundraiser.id!,
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _approve() async {
    setState(() => _loading = true);

    try {
      final approval = await _approvalFuture;

      if (approval == null) {
        throw Exception(
          'Approval record not found.',
        );
      }

      await _service.approveFundraiser(
        fundraiserId: widget.fundraiser.id!,
        approvalId: approval.id!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fundraiser approved successfully.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _reject() async {
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a rejection reason.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final approval = await _approvalFuture;

      if (approval == null) {
        throw Exception(
          'Approval record not found.',
        );
      }

      await _service.rejectFundraiser(
        fundraiserId: widget.fundraiser.id!,
        approvalId: approval.id!,
        reason: reason,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fundraiser rejected.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
    @override
  Widget build(BuildContext context) {
    final fundraiser = widget.fundraiser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Fundraiser'),
      ),
      body: FutureBuilder<ApprovalModel?>(
        future: _approvalFuture,
        builder: (context, approvalSnapshot) {
          if (approvalSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (approvalSnapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  approvalSnapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final approval = approvalSnapshot.data;
          if (approval == null) {
            return const Center(
              child: Text(
                'Approval record not found.',
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (fundraiser.imageUrl != null &&
                  fundraiser.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Image.network(
                    fundraiser.imageUrl!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                      height: 220,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 70,
                      ),
                    ),
                  ),
                ),
              if (fundraiser.imageUrl != null &&
                  fundraiser.imageUrl!.isNotEmpty)
                const SizedBox(height: 20),
              Text(
                fundraiser.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Chip(
                    avatar: const Icon(
                      Icons.category,
                      size: 18,
                    ),
                    label: Text(
                      fundraiser.category,
                    ),
                  ),
                  Chip(
                    avatar: const Icon(
                      Icons.pending_actions,
                      size: 18,
                    ),
                    label: Text(
                      approval.status.toUpperCase(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.payments,
                  ),
                  title: const Text(
                    'Goal Amount',
                  ),
                  subtitle: Text(
                    'KES ${fundraiser.goalAmount.toStringAsFixed(0)}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Text(
                    fundraiser.description,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Instructions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Text(
                    fundraiser.paymentInstructions,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Rejection Reason',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Required only when rejecting',
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _loading
                          ? null
                          : _approve,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green,
                        foregroundColor:
                            Colors.white,
                        minimumSize:
                            const Size(
                          double.infinity,
                          50,
                        ),
                      ),
                      icon: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.check,
                            ),
                      label: const Text(
                        'Approve',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _loading
                          ? null
                          : _reject,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red,
                        foregroundColor:
                            Colors.white,
                        minimumSize:
                            const Size(
                          double.infinity,
                          50,
                        ),
                      ),
                      icon: const Icon(
                        Icons.close,
                      ),
                      label: const Text(
                        'Reject',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}