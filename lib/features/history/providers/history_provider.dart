// History screen providers: recent dose log history grouped by day.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/app_database.dart';

part 'history_provider.g.dart';

class HistoryDayGroup {
  const HistoryDayGroup({required this.date, required this.items});

  final DateTime date;
  final List<HistoryItem> items;
}

class HistoryItem {
  const HistoryItem({
    required this.log,
    required this.medicationName,
    required this.dose,
    required this.unit,
    required this.hour,
    required this.minute,
  });

  final DoseLog log;
  final String medicationName;
  final double dose;
  final String unit;
  final int hour;
  final int minute;

  bool get isTaken => log.takenAt != null;
  bool get isSkipped => log.skipped;
}

// Returns dose log history grouped by day, most recent first (last 14 days).
@riverpod
Future<List<HistoryDayGroup>> doseHistory(
  DoseHistoryRef ref, // ignore: deprecated_member_use_from_same_package
) async {
  final db = ref.watch(appDatabaseProvider);

  final now = DateTime.now();

  // Get all medications for name lookup
  final medications = await db.medicationsDao.getActiveMedications();
  final medByRemId = <int, ({String name, double dose, String unit})>{};

  // Also need reminders to get hour/minute and medicationId
  final reminders = await db.remindersDao.getAllEnabledReminders();
  final medMap = {for (final m in medications) m.id: m};
  for (final r in reminders) {
    final med = medMap[r.medicationId];
    if (med != null) {
      medByRemId[r.id] = (
        name: med.name,
        dose: med.dose,
        unit: med.unit,
      );
    }
  }

  final reminderMap = {for (final r in reminders) r.id: r};

  // Fetch logs day by day for the past 14 days
  final allGroups = <HistoryDayGroup>[];
  for (int i = 0; i < 14; i++) {
    final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
    final logs = await db.doseLogsDao.getDoseLogsForDay(day);

    final items = logs
        .where((l) => medByRemId.containsKey(l.reminderId))
        .map((l) {
          final info = medByRemId[l.reminderId]!;
          final reminder = reminderMap[l.reminderId];
          return HistoryItem(
            log: l,
            medicationName: info.name,
            dose: info.dose,
            unit: info.unit,
            hour: reminder?.hour ?? 0,
            minute: reminder?.minute ?? 0,
          );
        })
        .toList()
      ..sort((a, b) => a.log.scheduledAt.compareTo(b.log.scheduledAt));

    if (items.isNotEmpty) {
      allGroups.add(HistoryDayGroup(date: day, items: items));
    }
  }

  return allGroups;
}
