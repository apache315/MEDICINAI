// Medications list screen: shows all active medications.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../providers/medications_provider.dart';
import '../widgets/medication_tile.dart';

class MedicationsListScreen extends ConsumerWidget {
  const MedicationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsAsync = ref.watch(activeMedicationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('I miei farmaci')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addMedication),
        icon: const Icon(Icons.add, size: 28),
        label: const Text(
          'Aggiungi',
          style: TextStyle(fontSize: AppConstants.labelFontSize),
        ),
      ),
      body: medicationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (meds) {
          if (meds.isEmpty) return const _EmptyState();
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: meds.length,
            itemBuilder: (context, i) => MedicationTile(
              medication: meds[i],
              onTap: () => context.push('/medications/${meds[i].id}'),
            ),
          );
        },
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
            Icon(Icons.medication_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nessun farmaco attivo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Aggiungi un farmaco manualmente\no fotografa la ricetta dalla schermata principale.',
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
