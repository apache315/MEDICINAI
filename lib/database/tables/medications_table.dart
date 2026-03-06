// Medications: individual drugs with dose and schedule info

import 'package:drift/drift.dart';

import 'prescriptions_table.dart';

class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Null if added manually (not from a prescription scan)
  IntColumn get prescriptionId =>
      integer().nullable().references(Prescriptions, #id)();
  TextColumn get name => text()();
  TextColumn get activePrinciple => text().nullable()();
  // Dose amount (e.g. 100, 20.5)
  RealColumn get dose => real()();
  // Dose unit: mg, mcg, g, ml, UI, gocce, compresse, capsule, bustine
  TextColumn get unit => text()();
  // Human-readable frequency description (e.g. "2 volte al giorno")
  TextColumn get frequencyDescription => text()();
  // Number of times per day (for reminder scheduling)
  IntColumn get timesPerDay => integer()();
  DateTimeColumn get startDate => dateTime()();
  // Null means indefinite (ongoing medication)
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
}
