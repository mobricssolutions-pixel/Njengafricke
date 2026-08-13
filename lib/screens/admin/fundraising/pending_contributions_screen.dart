import 'package:flutter/material.dart';

import '../../fundraising/models/contribution_model.dart';
import 'contribution_review_screen.dart';
import '../../fundraising/services/fundraising_service.dart';

class PendingContributionsScreen extends StatefulWidget {
  const PendingContributionsScreen({super.key});

  @override
  State<PendingContributionsScreen> createState() =>
      _PendingContributionsScreenState();
}

class _PendingContributionsScreenState
    extends State<PendingContributionsScreen> {
  final FundraisingService _service =
      FundraisingService();

  late Future<List<ContributionModel>> _future;

  @override
  void initState() {
    super.initState();
    _loadContributions();
  }

  void _loadContributions() {
    _future = _service.getPendingContributions();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadContributions();
    });

    await _future;
  }

  Widget _buildContributionCard(
      ContributionModel contribution) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 2,
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.payments),
        ),
        title: Text(
          "KES ${contribution.amount.toStringAsFixed(0)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 4),

            Text(
              "Transaction: ${contribution.transactionCode}",
            ),

            Text(
              "Method: ${contribution.paymentMethod}",
            ),

            if (contribution.message != null &&
                contribution.message!
                    .trim()
                    .isNotEmpty)
              Text(
                contribution.message!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: () async {
          final changed =
              await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ContributionReviewScreen(
                contribution: contribution,
              ),
            ),
          );

          if (changed == true) {
            _refresh();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pending Contributions",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child:
            FutureBuilder<List<ContributionModel>>(
          future: _future,
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
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Text(
                    snapshot.error.toString(),
                    textAlign:
                        TextAlign.center,
                  ),
                ),
              );
            }

            final contributions =
                snapshot.data ?? [];

            if (contributions.isEmpty) {
              return ListView(
                children: const [

                  SizedBox(height: 120),

                  Icon(
                    Icons.verified,
                    size: 80,
                    color: Colors.green,
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      "No pending contributions.",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding:
                  const EdgeInsets.only(
                top: 8,
                bottom: 20,
              ),
              itemCount:
                  contributions.length,
              itemBuilder:
                  (context, index) =>
                      _buildContributionCard(
                contributions[index],
              ),
            );
          },
        ),
      ),
    );
  }
}