// Notification service: schedules and manages medication reminders.
// Uses flutter_local_notifications with exact alarms on Android
// and UNNotificationRequest calendar triggers on iOS.
//
// Android requirements (AndroidManifest.xml):
//   <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
//   <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
//   <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
//   <uses-permission android:name="android.permission.VIBRATE" />
//   Add FlutterLocalNotificationsPlugin.registerWith(registrar) to MainActivity
//   and a boot BroadcastReceiver to re-schedule after device reboot.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../core/constants/app_constants.dart';
import '../database/app_database.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // --- Init ---

  static Future<void> initialize() async {
    if (_initialized) return;

    await _configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // requested explicitly via requestPermissions()
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    _initialized = true;
  }

  static Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final timezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName));
  }

  static void _onNotificationResponse(NotificationResponse response) {
    // Future: navigate to medication detail on tap
  }

  // --- Permissions ---

  // Requests notification permissions on Android 13+ and iOS.
  // Returns true if granted or not required on this platform/version.
  static Future<bool> requestPermissions() async {
    // Android
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  // --- Scheduling ---

  // Cancels all pending notifications and re-schedules based on DB state.
  // Call this after any reminder change and on app startup.
  static Future<void> scheduleAllReminders(AppDatabase db) async {
    if (!_initialized) await initialize();
    await _plugin.cancelAll();

    final reminders = await db.remindersDao.getAllEnabledReminders();

    // Batch-fetch all medications to avoid N+1 queries
    final allMedications = await db.medicationsDao.getActiveMedications();
    final medMap = {for (final m in allMedications) m.id: m};

    for (final reminder in reminders) {
      final med = medMap[reminder.medicationId];
      if (med == null) continue;

      final dose = med.dose == med.dose.truncateToDouble()
          ? med.dose.toInt().toString()
          : med.dose.toString();

      await _scheduleDaily(
        notificationId: reminder.notificationId,
        title: 'Promemoria: ${med.name}',
        body: 'Ora di prendere $dose ${med.unit}',
        hour: reminder.hour,
        minute: reminder.minute,
      );
    }
  }

  // Schedules a single daily repeating notification at the given hour:minute.
  static Future<void> _scheduleDaily({
    required int notificationId,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final scheduledDate = _nextInstanceOf(hour, minute);

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      _buildNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // daily repeat
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancels the notification for a specific reminder ID.
  static Future<void> cancelReminder(int notificationId) async {
    await _plugin.cancel(notificationId);
  }

  // --- Helpers ---

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    // If the time has already passed today, schedule for tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static NotificationDetails _buildNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        AppConstants.notificationChannelId,
        AppConstants.notificationChannelName,
        channelDescription: AppConstants.notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        // Large-text style for elderly readability
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }
}
