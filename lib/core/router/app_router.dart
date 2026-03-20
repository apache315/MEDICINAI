// App navigation using GoRouter
// All route paths defined as constants to avoid typos

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/medications/screens/add_medication_screen.dart';
import '../../features/medications/screens/medication_detail_screen.dart';
import '../../features/medications/screens/medications_list_screen.dart';
import '../../features/model_download/screens/download_screen.dart';
import '../../features/scan_prescription/screens/camera_screen.dart';
import '../../features/scan_prescription/screens/review_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/reminders/screens/reminder_settings_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../services/model_download_service.dart';
import '../widgets/main_scaffold.dart';

part 'app_router.g.dart';

// Tracks whether the user chose to skip the model download.
// Resets on app restart (in-memory only).
final downloadSkippedProvider = StateProvider<bool>((ref) => false);

abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const modelDownload = '/download';
  static const home = '/home';
  static const scan = '/scan';
  static const review = '/review';
  static const medications = '/medications';
  static const medicationDetail = '/medications/:id';
  static const addMedication = '/medications/add';
  static const reminders = '/reminders';
  static const history = '/history';
}

@riverpod
GoRouter appRouter(AppRouterRef ref) { // ignore: deprecated_member_use_from_same_package
  // ValueNotifier used as refreshListenable: GoRouter re-evaluates redirect
  // whenever the model download state changes.
  final refreshTrigger = ValueNotifier<int>(0);
  ref.listen<AsyncValue<ModelState>>(
    modelDownloadNotifierProvider,
    (_, __) => refreshTrigger.value++,
  );
  ref.listen<bool>(downloadSkippedProvider, (_, __) => refreshTrigger.value++);
  ref.onDispose(refreshTrigger.dispose);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    refreshListenable: refreshTrigger,
    redirect: (context, state) {
      // User chose to use app without AI — allow all navigation
      if (ref.read(downloadSkippedProvider)) return null;

      final modelAsync = ref.read(modelDownloadNotifierProvider);
      // Still loading — don't redirect yet
      if (modelAsync.isLoading) return null;

      final isReady = modelAsync.valueOrNull is ModelReady;
      final onDownload = state.matchedLocation == AppRoutes.modelDownload;

      // Model not ready and not already on download page → redirect
      if (!isReady && !onDownload) return AppRoutes.modelDownload;
      // Model ready but still on download page → go home
      if (isReady && onDownload) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.modelDownload,
        builder: (context, state) => const DownloadScreen(),
      ),
      GoRoute(
        path: AppRoutes.scan,
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: AppRoutes.review,
        builder: (context, state) {
          final imagePath = state.extra as String?;
          return ReviewScreen(imagePath: imagePath ?? '');
        },
      ),
      GoRoute(
        path: AppRoutes.addMedication,
        builder: (context, state) => const AddMedicationScreen(),
      ),
      GoRoute(
        path: '/medications/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MedicationDetailScreen(medicationId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.reminders,
        builder: (context, state) => const ReminderSettingsScreen(),
      ),
      // Main shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.medications,
            builder: (context, state) => const MedicationsListScreen(),
          ),
          GoRoute(
            path: AppRoutes.history,
            builder: (context, state) => const HistoryScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Pagina non trovata: ${state.error}'),
      ),
    ),
  );
}
