import 'package:flutter/material.dart';

import '../../../core/services/appwrite_service.dart';
import '../../../core/constants/app_constants.dart';

import 'admin_dashboard_screen.dart';
import 'minor_admin_dashboard_screen.dart';

class AdminGateScreen extends StatefulWidget {
  const AdminGateScreen({
    super.key,
  });

  @override
  State<AdminGateScreen> createState() =>
      _AdminGateScreenState();
}

class _AdminGateScreenState
    extends State<AdminGateScreen> {

  bool loading = true;

  String role = 'user';

  @override
  void initState() {
    super.initState();

    checkRole();
  }

  Future<void> checkRole() async {
    try {

      final currentUser =
          await AppwriteService.account.get();

      final userDoc =
          await AppwriteService.databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId:
            AppConstants.usersCollectionId,
        documentId: currentUser.$id,
      );

      if (!mounted) return;

      setState(() {
        role =
            userDoc.data['role'] ?? 'user';
        loading = false;
      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (role == 'admin') {
      return const AdminDashboardScreen();
    }

    if (role == 'minorAdmin') {
      return const MinorAdminDashboardScreen();
    }

    return const Scaffold(
      body: Center(
        child: Text(
          'Access Denied',
        ),
      ),
    );
  }
}