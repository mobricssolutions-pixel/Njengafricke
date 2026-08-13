import 'package:flutter/material.dart';

import '../models/contribution_model.dart';
import '../models/fundraiser_model.dart';
import '../services/fundraising_service.dart';

class ContributeScreen extends StatefulWidget {
  final FundraiserModel fundraiser;

  const ContributeScreen({
    super.key,
    required this.fundraiser,
  });

  @override
  State<ContributeScreen> createState() =>
      _ContributeScreenState();
}

class _ContributeScreenState
    extends State<ContributeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _amountController = TextEditingController();
  final _transactionController = TextEditingController();
  final _messageController = TextEditingController();

  final FundraisingService _service = FundraisingService();

  bool _isSubmitting = false;

  String _paymentMethod = 'M-Pesa';

  final List<String> _paymentMethods = [
    'M-Pesa',
    'Airtel Money',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    _amountController.dispose();
    _transactionController.dispose();
    _messageController.dispose();

    super.dispose();
  }
  InputDecoration _decoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final contribution = ContributionModel(
        projectId: widget.fundraiser.id!,
        supporterId: '',
        supporterName: _fullNameController.text.trim(),
        supporterPhone: _phoneController.text.trim(),
        supporterEmail: _emailController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        transactionCode: _transactionController.text.trim(),
        paymentMethod: _paymentMethod,
        message: _messageController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _service.submitContribution(
        contribution,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Contribution submitted successfully. It will appear once verified by the admin.",
          ),
        ),
      );

      Navigator.pop(context);
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
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contribute"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
          const EdgeInsets.all(16),
          children: [

            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

  const Text(
    "How to Contribute",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),

  const SizedBox(height: 12),

  Card(
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [

          Row(
            children: [
              Icon(Icons.account_balance_wallet),
              SizedBox(width: 8),
              Text(
                "BuildAfri Official Payment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            "Paybill: 542542",
          ),

          SizedBox(height: 6),

          Text(
            "Account number: 190491",
          ),

          SizedBox(height: 6),

          Text(
            "Account Name: M.S.",
          ),

          SizedBox(height: 16),

          Divider(),

          SizedBox(height: 8),

          Text(
            "After making the payment, click 'Contribute' and enter your M-Pesa transaction code for verification.",
          ),

          SizedBox(height: 16),

          Divider(),

          SizedBox(height: 8),

          Text(
            "Service Fee",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 6),

          Text(
            "A 5% BuildAfri service fee is deducted from every verified contribution to support platform operations, payment verification, and continuous improvement of the service.",
          ),
        ],
      ),
    ),
  ),
],
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _fullNameController,
              decoration: _decoration(
                "Full Name",
                Icons.person,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Enter your full name";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _decoration(
                "Phone Number",
                Icons.phone,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Enter your phone number";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _decoration(
                "Email (Optional)",
                Icons.email,
              ),
            ),

            TextFormField(
              controller:
              _amountController,
              keyboardType:
              const TextInputType
                  .numberWithOptions(
                decimal: true,
              ),
              decoration: _decoration(
                "Amount (KES)",
                Icons.payments,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Enter amount";
                }

                if (double.tryParse(
                    value) ==
                    null) {
                  return "Invalid amount";
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration:
              _decoration(
                "Payment Method",
                Icons.wallet,
              ),
              items: _paymentMethods
                  .map(
                    (method) =>
                    DropdownMenuItem(
                      value: method,
                      child:
                      Text(method),
                    ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _paymentMethod =
                  value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
              _transactionController,
              decoration:
              _decoration(
                "Transaction Code",
                Icons.receipt,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Enter transaction code";
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
              _messageController,
              maxLines: 4,
              decoration:
              _decoration(
                "Message (Optional)",
                Icons.message,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child:
              ElevatedButton.icon(
                onPressed:
                _isSubmitting
                    ? null
                    : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth:
                    2,
                    color: Colors
                        .white,
                  ),
                )
                    : const Icon(Icons
                    .favorite),
                label: Text(
                  _isSubmitting
                      ? "Submitting..."
                      : "Submit Contribution",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}