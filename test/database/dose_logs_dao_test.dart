// Unit tests for DoseLogsDao using in-memory SQLite

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind/database/app_database.dart';

AppDatabase _makeTestDb() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;
  late int medicationId;
  late int reminderId;

  setUp(() async {
    db = _makeTestDb();
    medicationId = await db.medicationsDao.insertMedication(
      MedicationsCompanion.insert(
        name: 'Farmaco Test',
        dose: 50,
        unit: 'mg',
        frequencyDescription: '1x die',
        timesPerDay: 1,
        startDate: DateTime(2026, 3, 1),
        createdAt: DateTime.now(),
      ),
    );
    reminderId = await db.remindersDao.insertReminder(
      RemindersCompanion.insert(
        medicationId: medicationId,
        hour: 8,
        minute: 0,
        notificationId: 20001,
        createdAt: DateTime.now(),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('DoseLogsDao', () {
    test('insert dose log and retrieve for day', () async {
      final today = DateTime(2026, 3, 6);
      final scheduled = DateTime(2026, 3, 6, 8, 0);

      final id = await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: reminderId,
          scheduledAt: scheduled,
        ),
      );
      expect(id, greaterThan(0));

      final logs = await db.doseLogsDao.getDoseLogsForDay(today);
      expect(logs.length, equals(1));
      expect(logs.first.reminderId, equals(reminderId));
    });

    test('markAsTaken updates takenAt', () async {
      final id = await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: reminderId,
          scheduledAt: DateTime(2026, 3, 6, 8, 0),
        ),
      );

      await db.doseLogsDao.markAsTaken(id);

      final logs = await db.doseLogsDao.getDoseLogsForDay(DateTime(2026, 3, 6));
      expect(logs.first.takenAt, isNotNull);
      expect(logs.first.skipped, isFalse);
    });

    test('markAsSkipped sets skipped flag and reason', () async {
      final id = await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: reminderId,
          scheduledAt: DateTime(2026, 3, 6, 8, 0),
        ),
      );

      await db.doseLogsDao.markAsSkipped(id, reason: 'Non era a casa');

      final logs = await db.doseLogsDao.getDoseLogsForDay(DateTime(2026, 3, 6));
      expect(logs.first.skipped, isTrue);
      expect(logs.first.skipReason, equals('Non era a casa'));
    });

    test('getDoseLogsForDay only returns logs for that day', () async {
      // Log for today
      await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: reminderId,
          scheduledAt: DateTime(2026, 3, 6, 8, 0),
        ),
      );
      // Log for tomorrow
      await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: reminderId,
          scheduledAt: DateTime(2026, 3, 7, 8, 0),
        ),
      );

      final todayLogs =
          await db.doseLogsDao.getDoseLogsForDay(DateTime(2026, 3, 6));
      expect(todayLogs.length, equals(1));
    });

    test('getAdherenceStats calculates correct counts', () async {
      final from = DateTime(2026, 3, 1);
      final to = DateTime(2026, 3, 8);

      final id1 = await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: reminderId,
          scheduledAt: DateTime(2026, 3, 3, 8, 0),
        ),
      );
      final id2 = await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: reminderId,
          scheduledAt: DateTime(2026, 3, 4, 8, 0),
        ),
      );
      await db.doseLogsDao.insertDoseLog(
        DoseLogsCompanion.insert(
          reminderId: reminderId,
          scheduledAt: DateTime(2026, 3, 5, 8, 0),
        ),
      );

      await db.doseLogsDao.markAsTaken(id1);
      await db.doseLogsDao.markAsSkipped(id2, reason: 'Test');

      final stats = await db.doseLogsDao.getAdherenceStats(from, to);
      expect(stats['total'], equals(3));
      expect(stats['taken'], equals(1));
      expect(stats['skipped'], equals(1));
      expect(stats['pending'], equals(1));
    });
  });
}
