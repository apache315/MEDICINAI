// Root app widget — sets up Riverpod router and theme

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'database/app_database.dart';
import 'services/notification_service.dart';

class MediRemindApp extends ConsumerStatefulWidget {
  const MediRemindApp({super.key});

  @override
  ConsumerState<MediRemindApp> createState() => _MediRemindAppState();
}

class _MediRemindAppState extends ConsumerState<MediRemindApp> {
  @override
  void initState() {
    super.initState();
    // Reschedule all reminders on every app start.
    // This recovers from device reboots, battery optimization kills, etc.
    _rescheduleOnStartup();
  }

  Future<void> _rescheduleOnStartup() async {
    try {
      final db = ref.read(appDatabaseProvider);
      await NotificationService.scheduleAllReminders(db);
    } catch (_) {
      // Non-critical: if this fails the user can reschedule manually from settings
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MediRemind',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: const Locale('it', 'IT'),
      supportedLocales: const [Locale('it', 'IT'), Locale('en', 'US')],
    );
  }
}
