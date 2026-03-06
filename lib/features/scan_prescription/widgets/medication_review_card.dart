// Card displaying a single extracted medication during the review step.
// Shows name, dose, unit, timesPerDay with edit and delete actions.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../services/llm_service.dart';

class MedicationReviewCard extends StatelessWidget {
  const MedicationReviewCard({
    super.key,
    required this.medication,
    required this.index,
    required this.onUpdate,
    required this.onDelete,
  });

  final ExtractedMedication medication;
  final int index;
  final void Function(ExtractedMedication updated) onUpdate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medication, size: 28, color: Color(0xFF1565C0)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    medication.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.bodyFontSize,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  iconSize: 28,
                  tooltip: 'Modifica',
                  onPressed: () => _showEditDialog(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  iconSize: 28,
                  tooltip: 'Rimuovi',
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.scale,
              label: 'Dose',
              value: '${_formatDose(medication.dose)} ${medication.unit}',
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.schedule,
              label: 'Frequenza',
              value: medication.timesPerDay == 1
                  ? '1 volta al giorno'
                  : '${medication.timesPerDay} volte al giorno',
            ),
            if (medication.durationDays > 0) ...[
              const SizedBox(height: 6),
              _InfoRow(
                icon: Icons.calendar_today,
                label: 'Durata',
                value: '${medication.durationDays} giorni',
              ),
            ],
            if (medication.specificTimes.isNotEmpty) ...[
              const SizedBox(height: 6),
              _InfoRow(
                icon: Icons.access_time,
                label: 'Orari',
                value: medication.specificTimes.join(', '),
              ),
            ],
            if (medication.notes != null && medication.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              _InfoRow(
                icon: Icons.notes,
                label: 'Note',
                value: medication.notes!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDose(double dose) {
    return dose == dose.truncateToDouble() ? dose.toInt().toString() : dose.toString();
  }

  void _showEditDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _EditMedicationDialog(
        medication: medication,
        onSave: onUpdate,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rimuovi farmaco'),
        content: Text('Vuoi rimuovere "${medication.name}" dalla lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annulla'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop(true);
              onDelete();
            },
            child: const Text('Rimuovi'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

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
          child: Text(
            value,
            style: const TextStyle(fontSize: AppConstants.labelFontSize),
          ),
        ),
      ],
    );
  }
}

// --- Edit Dialog ---

class _EditMedicationDialog extends StatefulWidget {
  const _EditMedicationDialog({
    required this.medication,
    required this.onSave,
  });

  final ExtractedMedication medication;
  final void Function(ExtractedMedication) onSave;

  @override
  State<_EditMedicationDialog> createState() => _EditMedicationDialogState();
}

class _EditMedicationDialogState extends State<_EditMedicationDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _doseCtrl;
  late final TextEditingController _unitCtrl;
  late final TextEditingController _timesCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final m = widget.medication;
    _nameCtrl = TextEditingController(text: m.name);
    _doseCtrl = TextEditingController(text: m.dose.toString());
    _unitCtrl = TextEditingController(text: m.unit);
    _timesCtrl = TextEditingController(text: m.timesPerDay.toString());
    _durationCtrl = TextEditingController(
      text: m.durationDays > 0 ? m.durationDays.toString() : '',
    );
    _notesCtrl = TextEditingController(text: m.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _doseCtrl.dispose();
    _unitCtrl.dispose();
    _timesCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final updated = ExtractedMedication(
      name: _nameCtrl.text.trim(),
      dose: double.tryParse(_doseCtrl.text) ?? widget.medication.dose,
      unit: _unitCtrl.text.trim(),
      timesPerDay: int.tryParse(_timesCtrl.text) ?? widget.medication.timesPerDay,
      activePrinciple: widget.medication.activePrinciple,
      specificTimes: widget.medication.specificTimes,
      durationDays: int.tryParse(_durationCtrl.text) ?? -1,
      withFood: widget.medication.withFood,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifica farmaco'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field('Nome', _nameCtrl),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _field(
                    'Dose',
                    _doseCtrl,
                    inputType: const TextInputType.numberWithOptions(decimal: true),
                    formatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _field('Unità', _unitCtrl)),
              ],
            ),
            const SizedBox(height: 12),
            _field(
              'Volte al giorno',
              _timesCtrl,
              inputType: TextInputType.number,
              formatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            _field(
              'Durata (giorni, vuoto = indeterminata)',
              _durationCtrl,
              inputType: TextInputType.number,
              formatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            _field('Note', _notesCtrl, maxLines: 2),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Salva'),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType? inputType,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: inputType,
      inputFormatters: formatters,
      maxLines: maxLines,
      style: const TextStyle(fontSize: AppConstants.bodyFontSize),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
