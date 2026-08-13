import 'package:flutter/material.dart';

import '../../fundraising/models/contribution_model.dart';
import '../../fundraising/models/fundraiser_model.dart';
import '../../fundraising/services/fundraising_service.dart';

class ContributionReviewScreen extends StatefulWidget {
  final ContributionModel contribution;

  const ContributionReviewScreen({
    super.key,
    required this.contribution,
  });

  @override
  State<ContributionReviewScreen> createState() =>
      _ContributionReviewScreenState();
}

class _ContributionReviewScreenState
    extends State<ContributionReviewScreen> {
  final FundraisingService _service =
      FundraisingService();

  final TextEditingController _reasonController =
      TextEditingController();

  late Future<FundraiserModel?> _fundraiserFuture;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _fundraiserFuture = _service.getFundraiserById(
      widget.contribution.projectId,
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _verify(
      FundraiserModel fundraiser) async {
    setState(() => _loading = true);

    try {
      await _service.verifyContribution(
        contribution: widget.contribution,
        fundraiser: fundraiser,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Contribution verified."),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _reject() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Enter rejection reason."),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await _service.rejectContribution(
        contributionId:
            widget.contribution.id!,
        reason:
            _reasonController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Contribution rejected."),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Widget _buildTile(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Review Contribution"),
      ),
      body: FutureBuilder<FundraiserModel?>(
        future: _fundraiserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final fundraiser =
              snapshot.data;

          if (fundraiser == null) {
            return const Center(
              child: Text(
                "Fundraiser not found.",
              ),
            );
          }

          return ListView(
            padding:
                const EdgeInsets.all(16),
            children: [

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                          16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [

                      Text(
                        fundraiser.title,
                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                          height: 12),

                      Chip(
                        label: Text(
                            fundraiser
                                .category),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildTile(
                "Contribution Amount",
                "KES ${widget.contribution.amount.toStringAsFixed(0)}",
              ),

              _buildTile(
                "Payment Method",
                widget.contribution
                    .paymentMethod,
              ),

              _buildTile(
                "Transaction Code",
                widget.contribution
                    .transactionCode,
              ),

              if (widget.contribution.message !=
                      null &&
                  widget.contribution.message!
                      .trim()
                      .isNotEmpty)
                _buildTile(
                  "Message",
                  widget.contribution
                      .message!,
                ),

              const SizedBox(height: 20),

              TextField(
                controller:
                    _reasonController,
                maxLines: 4,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Reason (Required when rejecting)",
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [

                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                          Icons.check),
                      onPressed: _loading
                          ? null
                          : () => _verify(
                              fundraiser),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green,
                      ),
                      label: const Text(
                          "Verify"),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                          Icons.close),
                      onPressed: _loading
                          ? null
                          : _reject,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red,
                      ),
                      label: const Text(
                          "Reject"),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}