// Riverpod providers for the medications feature

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/app_database.dart';

part 'medications_provider.g.dart';

// Streams all active medications, sorted by name.
@riverpod
Stream<List<Medication>> activeMedications(
  ActiveMedicationsRef ref, // ignore: deprecated_member_use_from_same_package
) {
  return ref.watch(appDatabaseProvider).medicationsDao.watchActiveMedications();
}

// Returns reminders for a specific medication.
@riverpod
Future<List<Reminder>> medicationReminders(
  MedicationRemindersRef ref, // ignore: deprecated_member_use_from_same_package
  int medicationId,
) {
  return ref
      .watch(appDatabaseProvider)
      .remindersDao
      .getRemindersByMedication(medicationId);
}

// Returns a single medication by ID (null if not found).
@riverpod
Future<Medication?> medicationById(
  MedicationByIdRef ref, // ignore: deprecated_member_use_from_same_package
  int id,
) {
  return ref
      .watch(appDatabaseProvider)
      .medicationsDao
      .getMedicationById(id);
}
