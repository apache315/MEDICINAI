// Medication detail screen: shows a medication's info, reminders, and allows deactivation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/app_database.dart';
import '../../../services/notification_service.dart';
import '../providers/medications_provider.dart';

class MedicationDetailScreen extends ConsumerWidget {
  const MedicationDetailScreen({super.key, required this.medicationId});

  final int medicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medAsync = ref.watch(medicationByIdProvider(medicationId));
    final remindersAsync = ref.watch(medicationRemindersProvider(medicationId));

    return Scaffold(
      appBar: AppBar(title: const Text('Dettaglio farmaco')),
      body: medAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (med) {
          if (med == null) {
            return const Center(child: Text('Farmaco non trovato.'));
          }
          return _DetailBody(
            medication: med,
            remindersAsync: remindersAsync,
            onDeactivate: () => _deactivate(context, ref),
          );
        },
      ),
    );
  }

  Future<void> _deactivate(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disattiva farmaco'),
        content: const Text(
          'Il farmaco verrà rimosso dalla lista attiva e i promemoria saranno disabilitati.',
          style: TextStyle(fontSize: AppConstants.labelFontSize, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Disattiva', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ref
          .read(appDatabaseProvider)
          .medicationsDao
          .deactivateMedication(medicationId);
      if (!context.mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Farmaco disattivato.')),
      );
      navigator.pop();
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Errore: $e'), backgroundColor: Colors.red[700]),
      );
    }
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.medication,
    required this.remindersAsync,
    required this.onDeactivate,
  });

  final Medication medication;
  final AsyncValue<List<Reminder>> remindersAsync;
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    final dose = medication.dose == medication.dose.truncateToDouble()
        ? medication.dose.toInt().toString()
        : medication.dose.toString();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1E4FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.medication,
                        color: Color(0xFF1565C0),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medication.name,
                            style: const TextStyle(
                              fontSize: AppConstants.titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (medication.activePrinciple != null)
                            Text(
                              medication.activePrinciple!,
                              style: TextStyle(
                                fontSize: AppConstants.labelFontSize,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _InfoRow(Icons.scale, 'Dose', '$dose ${medication.unit}'),
                const SizedBox(height: 8),
                _InfoRow(Icons.schedule, 'Frequenza', medication.frequencyDescription),
                if (medication.endDate != null) ...[
                  const SizedBox(height: 8),
                  _InfoRow(
                    Icons.event,
                    'Fine terapia',
                    _formatDate(medication.endDate!),
                  ),
                ],
                if (medication.notes != null && medication.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _InfoRow(Icons.notes, 'Note', medication.notes!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Reminders section
        Text(
          'Promemoria',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1565C0),
              ),
        ),
        const SizedBox(height: 8),
        remindersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Errore: $e'),
          data: (reminders) {
            if (reminders.isEmpty) {
              return const Text(
                'Nessun promemoria configurato.',
                style: TextStyle(fontSize: AppConstants.labelFontSize),
              );
            }
            return Column(
              children: reminders.map((r) => _ReminderTile(reminder: r)).toList(),
            );
          },
        ),
        const SizedBox(height: 32),
        // Deactivate button
        SizedBox(
          height: AppConstants.minButtonHeight,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.stop_circle_outlined, size: 26),
            label: const Text(
              'Disattiva farmaco',
              style: TextStyle(fontSize: AppConstants.bodyFontSize),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red[700],
              side: BorderSide(color: Colors.red[700]!),
            ),
            onPressed: onDeactivate,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: AppConstants.labelFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: AppConstants.labelFontSize)),
        ),
      ],
    );
  }
}

class _ReminderTile extends ConsumerWidget {
  const _ReminderTile({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = reminder.hour.toString().padLeft(2, '0');
    final m = reminder.minute.toString().padLeft(2, '0');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: const Icon(Icons.alarm, size: 28, color: Color(0xFF1565C0)),
      title: Text(
        '$h:$m',
        style: const TextStyle(
          fontSize: AppConstants.bodyFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 24, color: Color(0xFF1565C0)),
            tooltip: 'Modifica orario',
            onPressed: () => _editTime(context, ref),
          ),
          Icon(
            reminder.enabled ? Icons.notifications_active : Icons.notifications_off,
            color: reminder.enabled ? Colors.green[700] : Colors.grey,
            size: 26,
          ),
        ],
      ),
    );
  }

  Future<void> _editTime(BuildContext context, WidgetRef ref) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: reminder.hour, minute: reminder.minute),
      helpText: 'Seleziona orario promemoria',
    );
    if (picked == null || !context.mounted) return;

    final db = ref.read(appDatabaseProvider);
    await db.remindersDao.updateReminderTime(reminder.id, picked.hour, picked.minute);
    await NotificationService.scheduleAllReminders(db);

    if (!context.mounted) return;
    ref.invalidate(medicationRemindersProvider(reminder.medicationId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Promemoria aggiornato: ${picked.hour.toString().padLeft(2, "0")}:${picked.minute.toString().padLeft(2, "0")}',
        ),
      ),
    );
  }
}
