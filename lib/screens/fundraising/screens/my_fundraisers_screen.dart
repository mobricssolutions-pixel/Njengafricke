import 'package:flutter/material.dart';

import '../../../core/utils/error_handler.dart';
import '../models/fundraiser_model.dart';
import '../screens/create_fundraiser_screen.dart';
import '../screens/fundraiser_details_screen.dart';
import '../services/fundraising_service.dart';
import '../widgets/fundraiser_card.dart';

class MyFundraisersScreen extends StatefulWidget {
  const MyFundraisersScreen({super.key});

  @override
  State<MyFundraisersScreen> createState() =>
      _MyFundraisersScreenState();
}

class _MyFundraisersScreenState
    extends State<MyFundraisersScreen> {
  final FundraisingService _service =
      FundraisingService();

  late Future<List<FundraiserModel>> _future;

  @override
  void initState() {
    super.initState();
    _loadFundraisers();
  }

  void _loadFundraisers() {
    _future = _service.getMyFundraisers();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadFundraisers();
    });

    await _future;
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'completed':
        return Colors.blue;

      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;

      case 'rejected':
        return Icons.cancel;

      case 'completed':
        return Icons.flag;

      default:
        return Icons.hourglass_top;
    }
  }

  Widget _statusChip(String status) {
    return Chip(
      avatar: Icon(
        _statusIcon(status),
        size: 18,
        color: Colors.white,
      ),
      backgroundColor: _statusColor(status),
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Fundraisers"),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("New"),
        onPressed: () async {
          final created =
              await Navigator.push<bool>(
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

            // Friendly error message
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    ErrorHandler.getMessage(snapshot.error),
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
                      "You haven't created any fundraisers yet.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30),
                    child: Center(
                      child: Text(
                        "Tap the New button below to start your first fundraiser.",
                        textAlign:
                            TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 90,
              ),
              itemCount: fundraisers.length,
              itemBuilder:
                  (context, index) {
                final fundraiser =
                    fundraisers[index];

                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(
                        left: 20,
                        top: 8,
                        bottom: 4,
                      ),
                      child: _statusChip(
                        fundraiser.status,
                      ),
                    ),
                    FundraiserCard(
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
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}