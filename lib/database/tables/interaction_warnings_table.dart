// InteractionWarnings: drug-drug interaction records

import 'package:drift/drift.dart';

import 'medications_table.dart';

class InteractionWarnings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medAId =>
      integer().references(Medications, #id, onDelete: KeyAction.cascade)();
  IntColumn get medBId =>
      integer().references(Medications, #id, onDelete: KeyAction.cascade)();
  // Severity: low, medium, high, severe
  TextColumn get severity => text()();
  TextColumn get description => text()();
  // Source: 'local_db' (from bundled interaction database) or 'ai' (from LLM)
  TextColumn get source =>
      text().withDefault(const Constant('local_db'))();
  DateTimeColumn get createdAt => dateTime()();
}
