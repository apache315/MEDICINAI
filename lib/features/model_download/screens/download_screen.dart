import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../services/model_download_service.dart';

class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelAsync = ref.watch(modelDownloadNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: modelAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorBody(message: e.toString()),
            data: (state) => switch (state) {
              ModelNotDownloaded() => const _NotDownloadedBody(),
              ModelDownloading() => _DownloadingBody(state: state),
              ModelReady() => const _ReadyBody(),
              ModelError(:final message) => _ErrorBody(message: message),
            },
          ),
        ),
      ),
    );
  }
}

// --- Not downloaded state ---

class _NotDownloadedBody extends ConsumerWidget {
  const _NotDownloadedBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.psychology_outlined, size: 80, color: Colors.blue),
        const SizedBox(height: 32),
        Text(
          'Scarica il cervello AI',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Per leggere le ricette mediche in modo automatico e offline, l\'app deve scaricare il modello AI e il modulo visivo (~700 MB in totale).',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.wifi, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Consigliato: usa il Wi-Fi per risparmiare dati mobili.',
                  style: TextStyle(color: Colors.amber.shade900),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Dopo il download, tutto funziona senza internet.\nI tuoi dati non escono mai dal telefono.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        FilledButton.icon(
          onPressed: () =>
              ref.read(modelDownloadNotifierProvider.notifier).startDownload(),
          icon: const Icon(Icons.download_rounded, size: 28),
          label: const Text('Scarica ora'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppConstants.minButtonHeight),
            textStyle: const TextStyle(
              fontSize: AppConstants.bodyFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () =>
              ref.read(downloadSkippedProvider.notifier).state = true,
          child: const Text('Usa l\'app senza AI (inserimento manuale)'),
        ),
      ],
    );
  }
}

// --- Downloading state ---

class _DownloadingBody extends ConsumerWidget {
  const _DownloadingBody({required this.state});

  final ModelDownloading state;

  String _estimateTime() {
    // Rough estimate: ~5 MB/s on average Wi-Fi
    final remainingBytes = state.totalBytes - state.downloadedBytes;
    if (remainingBytes <= 0 || state.totalBytes == 0) return '';
    final seconds = (remainingBytes / (5 * 1024 * 1024)).round();
    if (seconds < 60) return '~$seconds secondi rimasti';
    final minutes = (seconds / 60).round();
    return '~$minutes minuti rimasti';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.downloading_rounded, size: 80, color: Colors.blue),
        const SizedBox(height: 32),
        Text(
          'Download in corso...',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        LinearProgressIndicator(
          value: state.progress > 0 ? state.progress : null,
          minHeight: 12,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(state.progress * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              state.totalBytes > 0
                  ? '${state.downloadedMb} / ${state.totalMb} MB'
                  : '${state.downloadedMb} MB scaricati',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        if (state.totalBytes > 0) ...[
          const SizedBox(height: 4),
          Text(
            _estimateTime(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.right,
          ),
        ],
        const SizedBox(height: 32),
        Text(
          'Non chiudere l\'app durante il download.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () =>
              ref.read(modelDownloadNotifierProvider.notifier).cancelDownload(),
          icon: const Icon(Icons.cancel_outlined),
          label: const Text('Annulla download'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppConstants.minButtonHeight),
          ),
        ),
      ],
    );
  }
}

// --- Ready state (auto-redirected by router, shown briefly) ---

class _ReadyBody extends StatelessWidget {
  const _ReadyBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_rounded, size: 80, color: Colors.green),
        SizedBox(height: 16),
        Text(
          'Modello AI pronto!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// --- Error state ---

class _ErrorBody extends ConsumerWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.error_outline_rounded, size: 80, color: Colors.red),
        const SizedBox(height: 24),
        Text(
          'Errore durante il download',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        FilledButton.icon(
          onPressed: () =>
              ref.read(modelDownloadNotifierProvider.notifier).startDownload(),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Riprova'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppConstants.minButtonHeight),
            textStyle: const TextStyle(fontSize: AppConstants.bodyFontSize),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () =>
              ref.read(downloadSkippedProvider.notifier).state = true,
          child: const Text('Continua senza AI'),
        ),
      ],
    );
  }
}
