import 'package:flutter/material.dart';

import '../../../core/utils/error_handler.dart';
import '../models/fundraiser_model.dart';
import '../services/fundraising_service.dart';
import '../widgets/fundraiser_card.dart';
import 'create_fundraiser_screen.dart';
import 'fundraiser_details_screen.dart';

class FundraisingScreen extends StatefulWidget {
  const FundraisingScreen({super.key});

  @override
  State<FundraisingScreen> createState() =>
      _FundraisingScreenState();
}

class _FundraisingScreenState
    extends State<FundraisingScreen> {
  final FundraisingService _service =
      FundraisingService();

  late Future<List<FundraiserModel>> _fundraisers;

  @override
  void initState() {
    super.initState();
    _loadFundraisers();
  }

  void _loadFundraisers() {
    _fundraisers = _service.getApprovedFundraisers();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadFundraisers();
    });

    await _fundraisers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fundraising"),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateFundraiserScreen(),
            ),
          );

          if (created == true) {
            _refresh();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Start"),
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<FundraiserModel>>(
          future: _fundraisers,
          builder: (context, snapshot) {

            // Loading
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Friendly Error
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Text(
                    ErrorHandler.getMessage(
                      snapshot.error,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }

            final fundraisers =
                snapshot.data ?? [];

            // Empty State
            if (fundraisers.isEmpty) {
              return ListView(
                children: const [

                  SizedBox(height: 120),

                  Icon(
                    Icons.volunteer_activism,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      "No fundraisers available.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Text(
                        "Start the first fundraiser for your community.",
                        textAlign:
                            TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }

            // Success
            return ListView.builder(
              padding:
                  const EdgeInsets.only(
                top: 8,
                bottom: 90,
              ),
              itemCount:
                  fundraisers.length,
              itemBuilder:
                  (context, index) {
                final fundraiser =
                    fundraisers[index];

                return FundraiserCard(
                  fundraiser:
                      fundraiser,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FundraiserDetailsScreen(
                          fundraiser:
                              fundraiser,
                        ),
                      ),
                    );

                    _refresh();
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