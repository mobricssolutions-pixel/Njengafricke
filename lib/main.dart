import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/theme/app_theme.dart';
import 'core/services/session_service.dart';
import 'screens/landing/landing_screen.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications
  const AndroidInitializationSettings
      androidInitializationSettings =
      AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  const InitializationSettings
      initializationSettings =
      InitializationSettings(
    android: androidInitializationSettings,
  );

  await flutterLocalNotificationsPlugin
      .initialize(initializationSettings);

  // Request notification permission (Android 13+)
  final androidImplementation =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

  await androidImplementation
      ?.requestNotificationsPermission();

  runApp(
    const BuildAfri(),
  );
}

class BuildAfri extends StatelessWidget {
  const BuildAfri({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        final currentContext =
            navigatorKey.currentContext;

        if (currentContext != null) {
          SessionService.resetTimer(
            currentContext,
          );
        }
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'BuildAfri',
        theme: AppTheme.darkTheme,
        localizationsDelegates: const [
          FlutterQuillLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        home: const LandingScreen(),
      ),
    );
  }
}