// Data access object for dose logs (taken/skipped history)

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/dose_logs_table.dart';
import '../tables/medications_table.dart';
import '../tables/reminders_table.dart';

part 'dose_logs_dao.g.dart';

@DriftAccessor(tables: [DoseLogs, Reminders, Medications])
class DoseLogsDao extends DatabaseAccessor<AppDatabase>
    with _$DoseLogsDaoMixin {
  DoseLogsDao(super.db);

  Future<int> insertDoseLog(DoseLogsCompanion entry) =>
      into(doseLogs).insert(entry);

  Future<bool> updateDoseLog(DoseLogsCompanion entry) =>
      update(doseLogs).replace(entry);

  // Mark a scheduled dose as taken right now
  Future<void> markAsTaken(int doseLogId) =>
      (update(doseLogs)..where((t) => t.id.equals(doseLogId))).write(
        DoseLogsCompanion(takenAt: Value(DateTime.now())),
      );

  // Mark as skipped with optional reason
  Future<void> markAsSkipped(int doseLogId, {String? reason}) =>
      (update(doseLogs)..where((t) => t.id.equals(doseLogId))).write(
        DoseLogsCompanion(
          skipped: const Value(true),
          skipReason: Value(reason),
        ),
      );

  // Doses scheduled for today (for home screen)
  Future<List<DoseLog>> getDoseLogsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(doseLogs)
          ..where(
            (t) =>
                t.scheduledAt.isBiggerOrEqualValue(start) &
                t.scheduledAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .get();
  }

  // Stream for the live home screen card
  Stream<List<DoseLog>> watchDoseLogsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(doseLogs)
          ..where(
            (t) =>
                t.scheduledAt.isBiggerOrEqualValue(start) &
                t.scheduledAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .watch();
  }

  // History: dose logs for a given reminder
  Future<List<DoseLog>> getDoseLogsByReminder(int reminderId) =>
      (select(doseLogs)
            ..where((t) => t.reminderId.equals(reminderId))
            ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
          .get();

  // Adherence stats: count taken vs total in date range
  Future<Map<String, int>> getAdherenceStats(
    DateTime from,
    DateTime to,
  ) async {
    final logs = await (select(doseLogs)
          ..where(
            (t) =>
                t.scheduledAt.isBiggerOrEqualValue(from) &
                t.scheduledAt.isSmallerThanValue(to),
          ))
        .get();
    return {
      'total': logs.length,
      'taken': logs.where((l) => l.takenAt != null).length,
      'skipped': logs.where((l) => l.skipped).length,
      'pending':
          logs.where((l) => l.takenAt == null && !l.skipped).length,
    };
  }
}
