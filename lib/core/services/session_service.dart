import 'dart:async';

import 'package:flutter/material.dart';

import 'appwrite_service.dart';

class SessionService {

  static Timer? _timer;

  static const Duration timeout =
      Duration(minutes: 15);

  static void startSessionTimer(
    BuildContext context,
  ) {

    _timer?.cancel();

    _timer = Timer(
      timeout,
      () async {

        await logout(context);
      },
    );
  }

  static void resetTimer(
    BuildContext context,
  ) {

    startSessionTimer(context);
  }

  static Future<void> logout(
    BuildContext context,
  ) async {

    try {

      await AppwriteService.account
          .deleteSession(
        sessionId: 'current',
      );

    } catch (_) {}

    Navigator.pushNamedAndRemoveUntil(

      context,

      '/login',

      (route) => false,
    );
  }

  static void cancelTimer() {

    _timer?.cancel();
  }
}