// Data access object for reminders

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/medications_table.dart';
import '../tables/reminders_table.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [Reminders, Medications])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(super.db);

  Future<int> insertReminder(RemindersCompanion entry) =>
      into(reminders).insert(entry);

  Future<bool> updateReminder(RemindersCompanion entry) =>
      update(reminders).replace(entry);

  Future<int> deleteReminder(int id) =>
      (delete(reminders)..where((t) => t.id.equals(id))).go();

  Future<int> deleteRemindersByMedication(int medicationId) =>
      (delete(reminders)
            ..where((t) => t.medicationId.equals(medicationId)))
          .go();

  Future<List<Reminder>> getRemindersByMedication(int medicationId) =>
      (select(reminders)
            ..where((t) => t.medicationId.equals(medicationId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.hour),
              (t) => OrderingTerm.asc(t.minute),
            ]))
          .get();

  Stream<List<Reminder>> watchEnabledReminders() =>
      (select(reminders)..where((t) => t.enabled.equals(true))).watch();

  Future<List<Reminder>> getAllEnabledReminders() =>
      (select(reminders)..where((t) => t.enabled.equals(true))).get();

  Future<void> setReminderEnabled(int id, {required bool enabled}) =>
      (update(reminders)..where((t) => t.id.equals(id)))
          .write(RemindersCompanion(enabled: Value(enabled)));
}
