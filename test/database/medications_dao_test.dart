// Unit tests for MedicationsDao using in-memory SQLite

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind/database/app_database.dart';

AppDatabase _makeTestDb() => AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() {
    db = _makeTestDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('MedicationsDao — Prescriptions', () {
    test('insert and retrieve prescription', () async {
      final id = await db.medicationsDao.insertPrescription(
        PrescriptionsCompanion.insert(
          imagePath: '/storage/img001.jpg',
          scanDate: DateTime(2026, 3, 1),
          createdAt: DateTime(2026, 3, 1),
        ),
      );
      expect(id, greaterThan(0));

      final fetched = await db.medicationsDao.getPrescriptionById(id);
      expect(fetched, isNotNull);
      expect(fetched!.imagePath, equals('/storage/img001.jpg'));
      expect(fetched.confirmed, isFalse);
    });

    test('update prescription sets confirmed flag', () async {
      final id = await db.medicationsDao.insertPrescription(
        PrescriptionsCompanion.insert(
          imagePath: '/storage/img002.jpg',
          scanDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );

      final fetched = await db.medicationsDao.getPrescriptionById(id);
      await db.medicationsDao.updatePrescription(
        fetched!.toCompanion(true).copyWith(confirmed: const Value(true)),
      );

      final updated = await db.medicationsDao.getPrescriptionById(id);
      expect(updated!.confirmed, isTrue);
    });
  });

  group('MedicationsDao — Medications', () {
    late int prescriptionId;

    setUp(() async {
      prescriptionId = await db.medicationsDao.insertPrescription(
        PrescriptionsCompanion.insert(
          imagePath: '/storage/test.jpg',
          scanDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
    });

    test('insert medication and retrieve by ID', () async {
      final id = await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          prescriptionId: Value(prescriptionId),
          name: 'Aspirina',
          dose: 100,
          unit: 'mg',
          frequencyDescription: '1 volta al giorno',
          timesPerDay: 1,
          startDate: DateTime(2026, 3, 1),
          createdAt: DateTime.now(),
        ),
      );
      expect(id, greaterThan(0));

      final med = await db.medicationsDao.getMedicationById(id);
      expect(med, isNotNull);
      expect(med!.name, equals('Aspirina'));
      expect(med.dose, equals(100));
      expect(med.unit, equals('mg'));
      expect(med.isActive, isTrue);
    });

    test('getActiveMedications returns only active', () async {
      final id1 = await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          name: 'Farmaco A',
          dose: 10,
          unit: 'mg',
          frequencyDescription: '1x die',
          timesPerDay: 1,
          startDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
      await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          name: 'Farmaco B',
          dose: 20,
          unit: 'mg',
          frequencyDescription: '1x die',
          timesPerDay: 1,
          startDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );

      // Deactivate Farmaco A
      await db.medicationsDao.deactivateMedication(id1);

      final active = await db.medicationsDao.getActiveMedications();
      expect(active.length, equals(1));
      expect(active.first.name, equals('Farmaco B'));
    });

    test('deleteMedication removes it from DB', () async {
      final id = await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          name: 'Da Eliminare',
          dose: 5,
          unit: 'mg',
          frequencyDescription: '1x die',
          timesPerDay: 1,
          startDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );

      await db.medicationsDao.deleteMedication(id);
      final result = await db.medicationsDao.getMedicationById(id);
      expect(result, isNull);
    });

    test('getMedicationsByPrescription returns correct medications', () async {
      await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          prescriptionId: Value(prescriptionId),
          name: 'Med X',
          dose: 50,
          unit: 'mg',
          frequencyDescription: '2x die',
          timesPerDay: 2,
          startDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
      await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          prescriptionId: Value(prescriptionId),
          name: 'Med Y',
          dose: 100,
          unit: 'ml',
          frequencyDescription: '3x die',
          timesPerDay: 3,
          startDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
      // Another medication with no prescription
      await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          name: 'Med Z (manuale)',
          dose: 5,
          unit: 'gocce',
          frequencyDescription: '1x die',
          timesPerDay: 1,
          startDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );

      final meds = await db.medicationsDao
          .getMedicationsByPrescription(prescriptionId);
      expect(meds.length, equals(2));
      expect(meds.map((m) => m.name), containsAll(['Med X', 'Med Y']));
    });
  });
}
