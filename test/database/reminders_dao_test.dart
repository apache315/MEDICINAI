// Unit tests for RemindersDao using in-memory SQLite

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind/database/app_database.dart';

AppDatabase _makeTestDb() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late int medicationId;

  setUp(() async {
    db = _makeTestDb();
    medicationId = await db.medicationsDao.insertMedication(
      MedicationsCompanion.insert(
        name: 'Farmaco Test',
        dose: 100,
        unit: 'mg',
        frequencyDescription: '2x die',
        timesPerDay: 2,
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('RemindersDao', () {
    test('insert and retrieve reminders by medication', () async {
      await db.remindersDao.insertReminder(
        RemindersCompanion.insert(
          medicationId: medicationId,
          hour: 8,
          minute: 0,
          notificationId: 10001,
          createdAt: DateTime.now(),
        ),
      );
      await db.remindersDao.insertReminder(
        RemindersCompanion.insert(
          medicationId: medicationId,
          hour: 20,
          minute: 30,
          notificationId: 10002,
          createdAt: DateTime.now(),
        ),
      );

      final reminders =
          await db.remindersDao.getRemindersByMedication(medicationId);
      expect(reminders.length, equals(2));
      // Should be ordered by hour
      expect(reminders[0].hour, equals(8));
      expect(reminders[1].hour, equals(20));
    });

    test('setReminderEnabled toggles enabled state', () async {
      final id = await db.remindersDao.insertReminder(
        RemindersCompanion.insert(
          medicationId: medicationId,
          hour: 9,
          minute: 0,
          notificationId: 10003,
          createdAt: DateTime.now(),
        ),
      );

      await db.remindersDao.setReminderEnabled(id, enabled: false);
      final enabled = await db.remindersDao.getAllEnabledReminders();
      expect(enabled.any((r) => r.id == id), isFalse);
    });

    test('delete reminder removes it', () async {
      final id = await db.remindersDao.insertReminder(
        RemindersCompanion.insert(
          medicationId: medicationId,
          hour: 12,
          minute: 0,
          notificationId: 10004,
          createdAt: DateTime.now(),
        ),
      );

      await db.remindersDao.deleteReminder(id);
      final remaining =
          await db.remindersDao.getRemindersByMedication(medicationId);
      expect(remaining.any((r) => r.id == id), isFalse);
    });

    test('deleteRemindersByMedication removes all for a medication', () async {
      await db.remindersDao.insertReminder(
        RemindersCompanion.insert(
          medicationId: medicationId,
          hour: 7,
          minute: 0,
          notificationId: 10005,
          createdAt: DateTime.now(),
        ),
      );
      await db.remindersDao.insertReminder(
        RemindersCompanion.insert(
          medicationId: medicationId,
          hour: 19,
          minute: 0,
          notificationId: 10006,
          createdAt: DateTime.now(),
        ),
      );

      await db.remindersDao.deleteRemindersByMedication(medicationId);
      final remaining =
          await db.remindersDao.getRemindersByMedication(medicationId);
      expect(remaining, isEmpty);
    });
  });
}
