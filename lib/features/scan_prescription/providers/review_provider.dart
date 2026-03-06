// ReviewNotifier: manages the editable medication list in the review screen.
// After the user confirms, saves medications + default reminders to the database.

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/app_database.dart';
import '../../../services/llm_service.dart';
import '../../../services/notification_service.dart';

part 'review_provider.g.dart';

@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  @override
  List<ExtractedMedication> build() => const [];

  void init(List<ExtractedMedication> meds) {
    state = List.from(meds);
  }

  void remove(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }

  void update(int index, ExtractedMedication med) {
    state = [
      for (int i = 0; i < state.length; i++) i == index ? med : state[i],
    ];
  }

  // Persists confirmed medications and their default reminders to the database.
  Future<void> confirm(AppDatabase db) async {
    final now = DateTime.now();

    for (final med in state) {
      final medId = await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          name: med.name,
          activePrinciple: Value(med.activePrinciple),
          dose: med.dose,
          unit: med.unit,
          frequencyDescription: _buildFrequencyDescription(med),
          timesPerDay: med.timesPerDay,
          startDate: now,
          endDate: med.durationDays > 0
              ? Value(now.add(Duration(days: med.durationDays)))
              : const Value(null),
          notes: Value(med.notes),
          createdAt: now,
        ),
      );

      // Create default reminders based on timesPerDay and specificTimes
      final times = _defaultTimes(med.timesPerDay, med.specificTimes);
      for (int i = 0; i < times.length; i++) {
        final (hour, minute) = times[i];
        await db.remindersDao.insertReminder(
          RemindersCompanion.insert(
            medicationId: medId,
            hour: hour,
            minute: minute,
            notificationId: medId * 100 + i,
            createdAt: now,
          ),
        );
      }
    }

    // Reschedule all notifications to reflect the new reminders
    await NotificationService.scheduleAllReminders(db);
  }

  String _buildFrequencyDescription(ExtractedMedication med) {
    return med.timesPerDay == 1
        ? '1 volta al giorno'
        : '${med.timesPerDay} volte al giorno';
  }

  // Returns (hour, minute) pairs for default reminder times.
  List<(int, int)> _defaultTimes(int timesPerDay, List<String> specificTimes) {
    if (specificTimes.isNotEmpty) {
      return specificTimes.map((t) {
        final parts = t.split(':');
        final h = int.tryParse(parts.first) ?? 8;
        final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
        return (h, m);
      }).toList();
    }
    return switch (timesPerDay) {
      1 => [(8, 0)],
      2 => [(8, 0), (20, 0)],
      3 => [(8, 0), (14, 0), (20, 0)],
      4 => [(8, 0), (12, 0), (16, 0), (20, 0)],
      _ => [(8, 0)],
    };
  }
}
