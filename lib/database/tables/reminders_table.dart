// Reminders: scheduled notification times for each medication

import 'package:drift/drift.dart';

import 'medications_table.dart';

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId =>
      integer().references(Medications, #id, onDelete: KeyAction.cascade)();
  // Hour and minute of the reminder (0-23, 0-59)
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  // JSON array of weekday ints: 1=Mon, 7=Sun (empty = every day)
  TextColumn get daysOfWeek => text().withDefault(const Constant('[]'))();
  // Unique ID used for flutter_local_notifications
  IntColumn get notificationId => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
}
