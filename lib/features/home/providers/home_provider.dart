// Home screen providers: today's medication schedule with dose status.

import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/app_database.dart';

part 'home_provider.g.dart';

// --- Domain model ---

class HomeDoseItem {
  const HomeDoseItem({
    required this.reminderId,
    required this.medicationId,
    required this.medicationName,
    required this.dose,
    required this.unit,
    required this.hour,
    required this.minute,
    this.doseLog,
  });

  final int reminderId;
  final int medicationId;
  final String medicationName;
  final double dose;
  final String unit;
  final int hour;
  final int minute;
  final DoseLog? doseLog;

  bool get isTaken => doseLog?.takenAt != null;
  bool get isSkipped => doseLog?.skipped ?? false;
  bool get isPending => !isTaken && !isSkipped;

  bool get isOverdue {
    if (!isPending) return false;
    final now = DateTime.now();
    final scheduledMinutes = hour * 60 + minute;
    final nowMinutes = now.hour * 60 + now.minute;
    return nowMinutes > scheduledMinutes;
  }
}

// --- Today's doses provider ---

// Fetches all enabled reminders and their dose status for today.
@riverpod
Future<List<HomeDoseItem>> todayDoses(
  TodayDosesRef ref, // ignore: deprecated_member_use_from_same_package
) async {
  final db = ref.watch(appDatabaseProvider);
  final today = DateTime.now();

  final medications = await db.medicationsDao.getActiveMedications();
  final medMap = {for (final m in medications) m.id: m};

  final reminders = await db.remindersDao.getAllEnabledReminders();
  final doseLogs = await db.doseLogsDao.getDoseLogsForDay(today);
  final logMap = {for (final l in doseLogs) l.reminderId: l};

  final items = reminders
      .where((r) => medMap.containsKey(r.medicationId))
      .map((r) {
        final med = medMap[r.medicationId]!;
        final dose = med.dose == med.dose.truncateToDouble()
            ? med.dose.toInt().toString()
            : med.dose.toString();
        return HomeDoseItem(
          reminderId: r.id,
          medicationId: med.id,
          medicationName: med.name,
          dose: double.parse(dose),
          unit: med.unit,
          hour: r.hour,
          minute: r.minute,
          doseLog: logMap[r.id],
        );
      })
      .toList()
    ..sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));

  return items;
}

// --- Actions ---

// Marks a reminder's dose as taken for today. Creates a dose log if needed.
@riverpod
class DoseActionNotifier extends _$DoseActionNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> markTaken(HomeDoseItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _upsertLog(item, taken: true));
    ref.invalidate(todayDosesProvider);
  }

  Future<void> markSkipped(HomeDoseItem item, {String? reason}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _upsertLog(item, taken: false, skipReason: reason));
    ref.invalidate(todayDosesProvider);
  }

  Future<void> _upsertLog(
    HomeDoseItem item, {
    required bool taken,
    String? skipReason,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final today = DateTime.now();
    final scheduledAt = DateTime(
      today.year, today.month, today.day, item.hour, item.minute,
    );

    final existing = item.doseLog;
    if (existing != null) {
      if (taken) {
        await db.doseLogsDao.markAsTaken(existing.id);
      } else {
        await db.doseLogsDao.markAsSkipped(existing.id, reason: skipReason);
      }
    } else {
      await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: item.reminderId,
          scheduledAt: scheduledAt,
          takenAt: taken ? Value(DateTime.now()) : const Value(null),
          skipped: Value(!taken),
          skipReason: Value(skipReason),
        ),
      );
    }
  }
}
