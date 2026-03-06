// Home screen: today's medication schedule dashboard.
// Shows all doses for today with quick take/skip actions.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../providers/home_provider.dart';
import '../widgets/today_dose_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosesAsync = ref.watch(todayDosesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediRemind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 28),
            tooltip: 'Impostazioni promemoria',
            onPressed: () => context.push(AppRoutes.reminders),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.scan),
        icon: const Icon(Icons.document_scanner_outlined, size: 26),
        label: const Text(
          'Scansiona ricetta',
          style: TextStyle(fontSize: AppConstants.labelFontSize),
        ),
      ),
      body: dosesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (doses) {
          if (doses.isEmpty) return const _EmptyState();
          return _DoseList(doses: doses, ref: ref);
        },
      ),
    );
  }
}

class _DoseList extends StatelessWidget {
  const _DoseList({required this.doses, required this.ref});

  final List<HomeDoseItem> doses;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final taken = doses.where((d) => d.isTaken).length;
    final total = doses.length;

    return Column(
      children: [
        _SummaryBanner(taken: taken, total: total),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 100),
            itemCount: doses.length,
            itemBuilder: (ctx, i) {
              final item = doses[i];
              return TodayDoseCard(
                item: item,
                onTaken: () => ref
                    .read(doseActionNotifierProvider.notifier)
                    .markTaken(item),
                onSkipped: () => ref
                    .read(doseActionNotifierProvider.notifier)
                    .markSkipped(item),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({required this.taken, required this.total});

  final int taken;
  final int total;

  @override
  Widget build(BuildContext context) {
    final allDone = taken == total;
    final color = allDone ? const Color(0xFF2E7D32) : const Color(0xFF1565C0);
    final bgColor = allDone ? const Color(0xFFB8F5C0) : const Color(0xFFD1E4FF);

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(allDone ? Icons.verified : Icons.today_outlined, color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allDone ? 'Ottimo! Tutti i farmaci presi!' : 'Oggi, ${_todayLabel()}',
                  style: TextStyle(
                    fontSize: AppConstants.labelFontSize,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$taken/$total farmaci presi',
                  style: TextStyle(
                    fontSize: AppConstants.bodyFontSize,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    const months = [
      'gennaio', 'febbraio', 'marzo', 'aprile', 'maggio', 'giugno',
      'luglio', 'agosto', 'settembre', 'ottobre', 'novembre', 'dicembre',
    ];
    return '${now.day} ${months[now.month - 1]}';
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
            Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nessun farmaco per oggi',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Fotografa una ricetta o aggiungi un farmaco\ntoccando i pulsanti in basso.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.labelFontSize,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
