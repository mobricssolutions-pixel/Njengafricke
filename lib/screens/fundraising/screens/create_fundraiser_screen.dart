import 'package:flutter/material.dart';

import '../models/fundraiser_model.dart';
import '../services/fundraising_service.dart';

class CreateFundraiserScreen extends StatefulWidget {
  const CreateFundraiserScreen({super.key});

  @override
  State<CreateFundraiserScreen> createState() =>
      _CreateFundraiserScreenState();
}

class _CreateFundraiserScreenState
    extends State<CreateFundraiserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalController = TextEditingController();
  final _paymentController = TextEditingController();

  final FundraisingService _service = FundraisingService();

  bool _isLoading = false;

  String _category = 'Education';

  final List<String> _categories = [
    'Education',
    'Health',
    'Business',
    'Agriculture',
    'Technology',
    'Community',
    'Environment',
    'Emergency',
    'Sports',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try 
    {
        final fundraiser = FundraiserModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        goalAmount: double.parse(_goalController.text.trim()),
        paymentInstructions: _paymentController.text.trim(),
        createdAt: DateTime.now(),
        );

      await _service.createFundraiser(fundraiser);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fundraiser submitted for approval.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Start Fundraiser',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            TextFormField(
              controller: _titleController,
              decoration: _decoration(
                'Title',
                Icons.title,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Enter fundraiser title';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _category,
              decoration: _decoration(
                'Category',
                Icons.category,
              ),
              items: _categories
                  .map(
                    (category) =>
                        DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _goalController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _decoration(
                'Goal Amount (KES)',
                Icons.payments,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Enter goal amount';
                }

                if (double.tryParse(value) ==
                    null) {
                  return 'Invalid amount';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
                  _descriptionController,
              maxLines: 6,
              decoration: _decoration(
                'Description',
                Icons.description,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Enter description';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                    _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.volunteer_activism,
                      ),
                label: Text(
                  _isLoading
                      ? 'Submitting...'
                      : 'Submit for Approval',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}