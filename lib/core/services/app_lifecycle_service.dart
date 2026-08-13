import 'package:flutter/widgets.dart';

import 'session_service.dart';

class AppLifecycleService
    extends WidgetsBindingObserver {

  final BuildContext context;

  AppLifecycleService(this.context);

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {

    if (state ==
        AppLifecycleState.paused) {

      SessionService.startSessionTimer(
        context,
      );
    }

    if (state ==
        AppLifecycleState.resumed) {

      SessionService.resetTimer(
        context,
      );
    }
  }
}