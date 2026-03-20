// Review screen: shows AI-extracted medications for user confirmation.
// The user can edit, remove, or confirm the list before reminders are created.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../database/app_database.dart';
import '../../../services/llm_service.dart';
import '../providers/review_provider.dart';
import '../providers/scan_log_provider.dart';
import '../providers/scan_provider.dart';
import '../widgets/medication_review_card.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  bool _confirming = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final scanAsync = ref.watch(prescriptionScanProvider(widget.imagePath));

    // Initialize review list once scan completes
    scanAsync.whenData((result) {
      if (!_initialized && result.isSuccess) {
        _initialized = true;
        // Schedule after build to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(reviewNotifierProvider.notifier).init(result.medications);
        });
      }
    });

    final medications = ref.watch(reviewNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controlla i farmaci'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.help_outline),
            label: const Text('Aiuto'),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: scanAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (result) {
          if (result.hasError) return _ErrorView(message: result.error ?? 'Errore sconosciuto');
          if (medications.isEmpty) return const _EmptyView();
          return _ReviewBody(
            medications: medications,
            confirming: _confirming,
            onUpdate: (int i, ExtractedMedication med) =>
                ref.read(reviewNotifierProvider.notifier).update(i, med),
            onDelete: (i) =>
                ref.read(reviewNotifierProvider.notifier).remove(i),
            onConfirm: () => _confirm(context),
          );
        },
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final medications = ref.read(reviewNotifierProvider);
    if (medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aggiungi almeno un farmaco prima di confermare.')),
      );
      return;
    }

    // Capture context-dependent objects before async gap
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    setState(() => _confirming = true);
    try {
      final db = ref.read(appDatabaseProvider);
      await ref.read(reviewNotifierProvider.notifier).confirm(db);
      if (!mounted) return;
      final count = medications.length;
      final label = count == 1 ? 'farmaco aggiunto' : 'farmaci aggiunti';
      messenger.showSnackBar(
        SnackBar(
          content: Text('$count $label. Promemoria creati!'),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 3),
        ),
      );
      router.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Errore durante il salvataggio: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Come funziona'),
        content: const Text(
          'L\'AI ha estratto i farmaci dalla ricetta.\n\n'
          '• Tocca ✏️ per modificare nome, dose o frequenza\n'
          '• Tocca 🗑️ per rimuovere un farmaco non corretto\n'
          '• Tocca "Conferma" per creare i promemoria\n\n'
          'Controlla sempre i dati prima di confermare.',
          style: TextStyle(fontSize: AppConstants.labelFontSize, height: 1.6),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Capito'),
          ),
        ],
      ),
    );
  }
}

// --- Sub-widgets ---

class _LoadingView extends ConsumerWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = ref.watch(scanLogProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Analisi ricetta…',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                "L'AI sta leggendo la ricetta (30–120 sec).",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 28),
            if (steps.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              ...steps.map((step) => _ScanStepRow(step: step)),
          ],
        ),
      ),
    );
  }
}

class _ScanStepRow extends StatelessWidget {
  const _ScanStepRow({required this.step});

  final ScanStep step;

  @override
  Widget build(BuildContext context) {
    final Widget icon = switch (step.status) {
      ScanStepStatus.running => const SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ScanStepStatus.done =>
        const Icon(Icons.check_circle, color: Colors.green, size: 20),
      ScanStepStatus.error =>
        const Icon(Icons.error_outline, color: Colors.red, size: 20),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: step.status == ScanStepStatus.error
                        ? Colors.red
                        : null,
                  ),
                ),
                if (step.detail != null)
                  Text(
                    step.detail!,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 72, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Problema con la ricetta',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: AppConstants.minButtonHeight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Riprova',
                  style: TextStyle(fontSize: AppConstants.bodyFontSize),
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 72, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Nessun farmaco trovato',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "L'AI non ha riconosciuto farmaci nella ricetta.\n"
              'Prova a fotografare di nuovo con più luce,\noppure inserisci i farmaci manualmente.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: AppConstants.minButtonHeight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Riprova',
                  style: TextStyle(fontSize: AppConstants.bodyFontSize),
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewBody extends StatelessWidget {
  const _ReviewBody({
    required this.medications,
    required this.confirming,
    required this.onUpdate,
    required this.onDelete,
    required this.onConfirm,
  });

  final List<ExtractedMedication> medications;
  final bool confirming;
  final void Function(int, ExtractedMedication) onUpdate;
  final void Function(int) onDelete;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header banner
        Container(
          width: double.infinity,
          color: const Color(0xFFD1E4FF),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF1565C0)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Controlla i dati estratti dall\'AI prima di confermare.',
                  style: TextStyle(
                    fontSize: AppConstants.labelFontSize,
                    color: Color(0xFF001D36),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Medication list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 120),
            itemCount: medications.length,
            itemBuilder: (context, i) => MedicationReviewCard(
              medication: medications[i],
              index: i,
              onUpdate: (ExtractedMedication med) => onUpdate(i, med),
              onDelete: () => onDelete(i),
            ),
          ),
        ),
        // Confirm button (fixed at bottom)
        _ConfirmBar(confirming: confirming, onConfirm: onConfirm),
      ],
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.confirming, required this.onConfirm});

  final bool confirming;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppConstants.minButtonHeight + 8,
          child: ElevatedButton.icon(
            icon: confirming
                ? const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_outline, size: 30),
            label: Text(
              confirming ? 'Salvataggio…' : 'Conferma e crea promemoria',
              style: const TextStyle(
                fontSize: AppConstants.bodyFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            onPressed: confirming ? null : onConfirm,
          ),
        ),
      ),
    );
  }
}
