import 'package:flutter/material.dart';

import '../models/fundraiser_model.dart';

class FundraiserCard extends StatelessWidget {
  final FundraiserModel fundraiser;
  final VoidCallback? onTap;

  /// Button text (View, Manage, Review, Contribute...)
  final String buttonText;

  /// Show fundraiser status
  final bool showStatus;

  const FundraiserCard({
    super.key,
    required this.fundraiser,
    this.onTap,
    this.buttonText = "View",
    this.showStatus = false,
  });

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

  @override
  Widget build(BuildContext context) {
    final progress = fundraiser.progress;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Cover Image
            if (fundraiser.imageUrl != null &&
                fundraiser.imageUrl!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  fundraiser.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  /// Status
                  if (showStatus)
                    Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Chip(
                        avatar: Icon(
                          _statusIcon(
                              fundraiser.status),
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor:
                            _statusColor(
                                fundraiser.status),
                        label: Text(
                          fundraiser.status
                              .toUpperCase(),
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  /// Title
                  Text(
                    fundraiser.title,
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Category
                  Chip(
                    label:
                        Text(fundraiser.category),
                  ),

                  const SizedBox(height: 12),

                  /// Description
                  Text(
                    fundraiser.description,
                    maxLines: 3,
                    overflow:
                        TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 20),

                  /// Progress Bar
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                            30),
                    child:
                        LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [

                          const Text(
                            "Raised",
                            style:
                                TextStyle(
                              color: Colors
                                  .grey,
                            ),
                          ),

                          Text(
                            "KES ${fundraiser.currentAmount.toStringAsFixed(0)}",
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,
                        children: [

                          const Text(
                            "Goal",
                            style:
                                TextStyle(
                              color: Colors
                                  .grey,
                            ),
                          ),

                          Text(
                            "KES ${fundraiser.goalAmount.toStringAsFixed(0)}",
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${(progress * 100).toStringAsFixed(1)}% Raised",
                    style:
                        const TextStyle(
                      color: Colors.green,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child:
                        ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(
                        Icons.arrow_forward,
                      ),
                      label:
                          Text(buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}