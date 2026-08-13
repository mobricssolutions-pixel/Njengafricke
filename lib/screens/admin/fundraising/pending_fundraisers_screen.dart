import 'package:flutter/material.dart';

import '../../fundraising/models/fundraiser_model.dart';
import '../../fundraising/services/fundraising_service.dart';
import '../../fundraising/widgets/fundraiser_card.dart';
import 'fundraiser_review_screen.dart';

class PendingFundraisersScreen extends StatefulWidget {
  const PendingFundraisersScreen({super.key});

  @override
  State<PendingFundraisersScreen> createState() =>
      _PendingFundraisersScreenState();
}

class _PendingFundraisersScreenState
    extends State<PendingFundraisersScreen> {
  final FundraisingService _service =
      FundraisingService();

  late Future<List<FundraiserModel>> _future;

  @override
  void initState() {
    super.initState();
    _loadFundraisers();
  }

  void _loadFundraisers() {
    _future = _service.getPendingFundraisers();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadFundraisers();
    });

    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pending Fundraisers",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<FundraiserModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final fundraisers =
                snapshot.data ?? [];

            if (fundraisers.isEmpty) {
              return ListView(
                children: const [

                  SizedBox(height: 120),

                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.green,
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      "No pending fundraisers.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 20,
              ),
              itemCount: fundraisers.length,
              itemBuilder: (context, index) {
                final fundraiser =
                    fundraisers[index];

                return FundraiserCard(
                  fundraiser: fundraiser,
                  showStatus: true,
                  buttonText: "Review",
                  onTap: () async {
                    final changed =
                        await 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FundraiserReviewScreen(
                      fundraiser: fundraiser,
                    ),
                  ),
                );

                    if (changed == true) {
                      _refresh();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}