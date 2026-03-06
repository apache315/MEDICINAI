// DoseLogs: records each time a user takes or skips a dose

import 'package:drift/drift.dart';

import 'reminders_table.dart';

class DoseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get reminderId =>
      integer().references(Reminders, #id, onDelete: KeyAction.cascade)();
  // When the dose was scheduled
  DateTimeColumn get scheduledAt => dateTime()();
  // When the user actually took the dose (null if not yet logged)
  DateTimeColumn get takenAt => dateTime().nullable()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
  TextColumn get skipReason => text().nullable()();
  TextColumn get notes => text().nullable()();
}
