// Add medication screen: manual entry form for elderly users.
// Large fonts, big tap targets, clear labels — accessible by design.

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/app_database.dart';
import '../../../services/notification_service.dart';

// Valid dose units
const _units = ['mg', 'mcg', 'g', 'ml', 'UI', 'gocce', 'compresse', 'capsule', 'bustine'];

// Default reminder times for 1–4 doses per day
List<TimeOfDay> _defaultTimes(int count) => switch (count) {
      1 => [const TimeOfDay(hour: 8, minute: 0)],
      2 => [const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 20, minute: 0)],
      3 => [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 14, minute: 0),
          const TimeOfDay(hour: 20, minute: 0)
        ],
      _ => [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 12, minute: 0),
          const TimeOfDay(hour: 16, minute: 0),
          const TimeOfDay(hour: 20, minute: 0)
        ],
    };

class AddMedicationScreen extends ConsumerStatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  ConsumerState<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _principleCtrl = TextEditingController();
  final _doseCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _unit = 'mg';
  int _timesPerDay = 1;
  List<TimeOfDay> _reminderTimes = [const TimeOfDay(hour: 8, minute: 0)];
  bool _withFood = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _principleCtrl.dispose();
    _doseCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _setTimesPerDay(int value) {
    setState(() {
      _timesPerDay = value;
      _reminderTimes = _defaultTimes(value);
    });
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTimes[index],
      helpText: 'Orario promemoria ${index + 1}',
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _reminderTimes[index] = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final now = DateTime.now();
      final durationDays = int.tryParse(_durationCtrl.text.trim());

      final medId = await db.medicationsDao.insertMedication(
        MedicationsCompanion.insert(
          name: _nameCtrl.text.trim(),
          activePrinciple: Value(_principleCtrl.text.trim().isEmpty
              ? null
              : _principleCtrl.text.trim()),
          dose: double.parse(_doseCtrl.text.trim()),
          unit: _unit,
          frequencyDescription: _timesPerDay == 1
              ? '1 volta al giorno'
              : '$_timesPerDay volte al giorno',
          timesPerDay: _timesPerDay,
          startDate: now,
          endDate: durationDays != null
              ? Value(now.add(Duration(days: durationDays)))
              : const Value(null),
          notes: Value(_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
          createdAt: now,
        ),
      );

      for (int i = 0; i < _reminderTimes.length; i++) {
        await db.remindersDao.insertReminder(
          RemindersCompanion.insert(
            medicationId: medId,
            hour: _reminderTimes[i].hour,
            minute: _reminderTimes[i].minute,
            notificationId: medId * 100 + i,
            createdAt: now,
          ),
        );
      }

      // Reschedule all notifications to include the new reminders
      await NotificationService.scheduleAllReminders(db);

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('${_nameCtrl.text.trim()} aggiunto con successo!'),
          backgroundColor: Colors.green[700],
        ),
      );
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Errore durante il salvataggio: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aggiungi farmaco')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _SectionHeader('Informazioni farmaco'),
            const SizedBox(height: 12),
            _LargeField(
              label: 'Nome farmaco *',
              controller: _nameCtrl,
              hint: 'es. Aspirina',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Inserisci il nome del farmaco' : null,
            ),
            const SizedBox(height: 16),
            _LargeField(
              label: 'Principio attivo (opzionale)',
              controller: _principleCtrl,
              hint: 'es. Acido acetilsalicilico',
            ),
            const SizedBox(height: 24),
            const _SectionHeader('Dose'),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _LargeField(
                    label: 'Quantità *',
                    controller: _doseCtrl,
                    hint: 'es. 100',
                    inputType: const TextInputType.numberWithOptions(decimal: true),
                    formatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Inserisci la dose';
                      if (double.tryParse(v.trim()) == null) return 'Numero non valido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _UnitDropdown(value: _unit, onChanged: (u) => setState(() => _unit = u!))),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionHeader('Frequenza'),
            const SizedBox(height: 12),
            _TimesPerDaySelector(
              value: _timesPerDay,
              onChanged: _setTimesPerDay,
            ),
            const SizedBox(height: 16),
            _ReminderTimePickers(
              times: _reminderTimes,
              onPickTime: _pickTime,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text(
                'Da prendere a stomaco pieno',
                style: TextStyle(fontSize: AppConstants.bodyFontSize),
              ),
              value: _withFood,
              onChanged: (v) => setState(() => _withFood = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            const _SectionHeader('Durata (opzionale)'),
            const SizedBox(height: 12),
            _LargeField(
              label: 'Giorni di terapia (vuoto = indefinita)',
              controller: _durationCtrl,
              hint: 'es. 30',
              inputType: TextInputType.number,
              formatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            const _SectionHeader('Note (opzionale)'),
            const SizedBox(height: 12),
            _LargeField(
              label: 'Note aggiuntive',
              controller: _notesCtrl,
              hint: 'es. Assumere dopo i pasti',
              maxLines: 3,
            ),
            const SizedBox(height: 36),
            SizedBox(
              height: AppConstants.minButtonHeight + 8,
              child: ElevatedButton.icon(
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                      )
                    : const Icon(Icons.save_outlined, size: 28),
                label: Text(
                  _saving ? 'Salvataggio…' : 'Salva farmaco',
                  style: const TextStyle(
                    fontSize: AppConstants.bodyFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _saving ? null : _save,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// --- Form sub-widgets ---

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1565C0),
          ),
    );
  }
}

class _LargeField extends StatelessWidget {
  const _LargeField({
    required this.label,
    required this.controller,
    this.hint,
    this.inputType,
    this.formatters,
    this.validator,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? inputType;
  final List<TextInputFormatter>? formatters;
  final FormFieldValidator<String>? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: formatters,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: AppConstants.bodyFontSize),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  const _UnitDropdown({required this.value, required this.onChanged});

  final String value;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: AppConstants.bodyFontSize,
        color: Colors.black87,
      ),
      decoration: const InputDecoration(
        labelText: 'Unità',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: _units
          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
          .toList(),
    );
  }
}

class _TimesPerDaySelector extends StatelessWidget {
  const _TimesPerDaySelector({required this.value, required this.onChanged});

  final int value;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Volte al giorno:',
          style: TextStyle(fontSize: AppConstants.bodyFontSize),
        ),
        const SizedBox(width: 16),
        for (int n = 1; n <= 4; n++) ...[
          if (n > 1) const SizedBox(width: 8),
          _NumberChip(number: n, selected: value == n, onTap: () => onChanged(n)),
        ],
      ],
    );
  }
}

class _NumberChip extends StatelessWidget {
  const _NumberChip({
    required this.number,
    required this.selected,
    required this.onTap,
  });

  final int number;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1565C0) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: AppConstants.bodyFontSize,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _ReminderTimePickers extends StatelessWidget {
  const _ReminderTimePickers({required this.times, required this.onPickTime});

  final List<TimeOfDay> times;
  final void Function(int index) onPickTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Orari promemoria:',
          style: TextStyle(fontSize: AppConstants.bodyFontSize),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (int i = 0; i < times.length; i++)
              _TimeChip(
                label: times[i].format(context),
                onTap: () => onPickTime(i),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1565C0), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 22, color: Color(0xFF1565C0)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: AppConstants.bodyFontSize,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
