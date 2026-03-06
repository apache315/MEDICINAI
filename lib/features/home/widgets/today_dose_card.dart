// Card showing a single scheduled dose for today with take/skip actions.

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../providers/home_provider.dart';

class TodayDoseCard extends StatelessWidget {
  const TodayDoseCard({
    super.key,
    required this.item,
    required this.onTaken,
    required this.onSkipped,
  });

  final HomeDoseItem item;
  final VoidCallback onTaken;
  final VoidCallback onSkipped;

  @override
  Widget build(BuildContext context) {
    final h = item.hour.toString().padLeft(2, '0');
    final m = item.minute.toString().padLeft(2, '0');
    final timeLabel = '$h:$m';

    final dose = item.dose == item.dose.truncateToDouble()
        ? item.dose.toInt().toString()
        : item.dose.toString();

    Color borderColor;
    Color iconColor;
    IconData statusIcon;
    String? statusLabel;

    if (item.isTaken) {
      borderColor = const Color(0xFF2E7D32);
      iconColor = const Color(0xFF2E7D32);
      statusIcon = Icons.check_circle;
      statusLabel = 'Preso';
    } else if (item.isSkipped) {
      borderColor = Colors.orange;
      iconColor = Colors.orange;
      statusIcon = Icons.cancel_outlined;
      statusLabel = 'Saltato';
    } else if (item.isOverdue) {
      borderColor = const Color(0xFFB71C1C);
      iconColor = const Color(0xFFB71C1C);
      statusIcon = Icons.alarm_outlined;
      statusLabel = null; // action buttons shown instead
    } else {
      borderColor = Colors.grey.shade300;
      iconColor = const Color(0xFF1565C0);
      statusIcon = Icons.medication;
      statusLabel = null;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(color: borderColor, width: item.isPending ? 1 : 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time + icon
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeLabel,
                  style: TextStyle(
                    fontSize: AppConstants.titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(statusIcon, color: iconColor, size: 28),
              ],
            ),
            const SizedBox(width: 16),
            // Name + dose
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.medicationName,
                    style: const TextStyle(
                      fontSize: AppConstants.bodyFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dose ${item.unit}',
                    style: TextStyle(
                      fontSize: AppConstants.labelFontSize,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (statusLabel != null) ...[
                    const SizedBox(height: 6),
                    _StatusChip(label: statusLabel, color: borderColor),
                  ] else if (item.isPending) ...[
                    const SizedBox(height: 10),
                    _ActionRow(onTaken: onTaken, onSkipped: onSkipped),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppConstants.labelFontSize,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.onTaken, required this.onSkipped});

  final VoidCallback onTaken;
  final VoidCallback onSkipped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppConstants.minButtonHeight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check, size: 22),
              label: const Text(
                'Preso',
                style: TextStyle(fontSize: AppConstants.labelFontSize),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              onPressed: onTaken,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: AppConstants.minButtonHeight,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.close, size: 22),
              label: const Text(
                'Salta',
                style: TextStyle(fontSize: AppConstants.labelFontSize),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange[700],
                side: BorderSide(color: Colors.orange[700]!),
              ),
              onPressed: onSkipped,
            ),
          ),
        ),
      ],
    );
  }
}
