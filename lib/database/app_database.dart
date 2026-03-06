// Drift database definition — single source of truth for all local data

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';
import 'daos/dose_logs_dao.dart';
import 'daos/medications_dao.dart';
import 'daos/reminders_dao.dart';
import 'tables/app_settings_table.dart';
import 'tables/dose_logs_table.dart';
import 'tables/interaction_warnings_table.dart';
import 'tables/medications_table.dart';
import 'tables/prescriptions_table.dart';
import 'tables/reminders_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Prescriptions,
    Medications,
    Reminders,
    DoseLogs,
    InteractionWarnings,
    AppSettings,
  ],
  daos: [MedicationsDao, RemindersDao, DoseLogsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Future migrations go here
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationSupportDirectory();
    final file = File(p.join(dbDir.path, AppConstants.databaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}

// Riverpod provider — single instance for the whole app
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
