// Tile for a single medication in the list screen.

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/app_database.dart';

class MedicationTile extends StatelessWidget {
  const MedicationTile({
    super.key,
    required this.medication,
    required this.onTap,
  });

  final Medication medication;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dose = medication.dose == medication.dose.truncateToDouble()
        ? medication.dose.toInt().toString()
        : medication.dose.toString();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFD1E4FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.medication,
            color: Color(0xFF1565C0),
            size: 28,
          ),
        ),
        title: Text(
          medication.name,
          style: const TextStyle(
            fontSize: AppConstants.bodyFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '$dose ${medication.unit} · ${medication.frequencyDescription}',
            style: TextStyle(
              fontSize: AppConstants.labelFontSize,
              color: Colors.grey[700],
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 28),
        onTap: onTap,
        minVerticalPadding: 12,
      ),
    );
  }
}
