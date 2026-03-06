// History screen: shows dose logs for the past 14 days, grouped by day.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(doseHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Storico assunzioni')),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (groups) {
          if (groups.isEmpty) return const _EmptyState();
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: groups.length,
            itemBuilder: (context, i) => _DayGroup(group: groups[i]),
          );
        },
      ),
    );
  }
}

class _DayGroup extends StatelessWidget {
  const _DayGroup({required this.group});

  final HistoryDayGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            _formatDay(group.date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1565C0),
                ),
          ),
        ),
        ...group.items.map((item) => _HistoryTile(item: item)),
        const Divider(height: 1),
      ],
    );
  }

  String _formatDay(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);

    if (day == today) return 'Oggi';
    if (day == today.subtract(const Duration(days: 1))) return 'Ieri';

    const weekdays = ['', 'lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato', 'domenica'];
    const months = ['', 'gen', 'feb', 'mar', 'apr', 'mag', 'giu', 'lug', 'ago', 'set', 'ott', 'nov', 'dic'];
    return '${weekdays[dt.weekday]} ${dt.day} ${months[dt.month]}';
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final HistoryItem item;

  @override
  Widget build(BuildContext context) {
    final h = item.hour.toString().padLeft(2, '0');
    final m = item.minute.toString().padLeft(2, '0');
    final dose = item.dose == item.dose.truncateToDouble()
        ? item.dose.toInt().toString()
        : item.dose.toString();

    Color iconColor;
    IconData icon;
    String statusText;

    if (item.isTaken) {
      iconColor = const Color(0xFF2E7D32);
      icon = Icons.check_circle;
      statusText = 'Preso';
    } else if (item.isSkipped) {
      iconColor = Colors.orange;
      icon = Icons.cancel_outlined;
      statusText = 'Saltato';
    } else {
      iconColor = Colors.red;
      icon = Icons.error_outline;
      statusText = 'Non registrato';
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: iconColor, size: 32),
      title: Text(
        item.medicationName,
        style: const TextStyle(
          fontSize: AppConstants.bodyFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '$dose ${item.unit} · ore $h:$m',
        style: TextStyle(
          fontSize: AppConstants.labelFontSize,
          color: Colors.grey[700],
        ),
      ),
      trailing: Text(
        statusText,
        style: TextStyle(
          fontSize: AppConstants.labelFontSize,
          fontWeight: FontWeight.w600,
          color: iconColor,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nessuno storico',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Le assunzioni registrate compariranno qui.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.labelFontSize,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
