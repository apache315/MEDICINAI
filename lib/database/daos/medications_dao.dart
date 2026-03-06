// Data access object for medications and prescriptions

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/medications_table.dart';
import '../tables/prescriptions_table.dart';

part 'medications_dao.g.dart';

@DriftAccessor(tables: [Medications, Prescriptions])
class MedicationsDao extends DatabaseAccessor<AppDatabase>
    with _$MedicationsDaoMixin {
  MedicationsDao(super.db);

  // --- Prescriptions ---

  Future<int> insertPrescription(PrescriptionsCompanion entry) =>
      into(prescriptions).insert(entry);

  Future<bool> updatePrescription(PrescriptionsCompanion entry) =>
      update(prescriptions).replace(entry);

  Future<Prescription?> getPrescriptionById(int id) =>
      (select(prescriptions)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  // --- Medications ---

  Future<int> insertMedication(MedicationsCompanion entry) =>
      into(medications).insert(entry);

  Future<bool> updateMedication(MedicationsCompanion entry) =>
      update(medications).replace(entry);

  Future<int> deleteMedication(int id) =>
      (delete(medications)..where((t) => t.id.equals(id))).go();

  Future<Medication?> getMedicationById(int id) =>
      (select(medications)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Stream<List<Medication>> watchActiveMedications() =>
      (select(medications)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<List<Medication>> getActiveMedications() =>
      (select(medications)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Future<List<Medication>> getMedicationsByPrescription(int prescriptionId) =>
      (select(medications)
            ..where((t) => t.prescriptionId.equals(prescriptionId)))
          .get();

  Future<void> deactivateMedication(int id) => (update(medications)
        ..where((t) => t.id.equals(id)))
      .write(const MedicationsCompanion(isActive: Value(false)));
}
