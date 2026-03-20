// Step-by-step visual log for the prescription scan pipeline.
// Uses a plain StateNotifierProvider (no code generation required).

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScanStepStatus { running, done, error }

class ScanStep {
  const ScanStep({required this.label, required this.status, this.detail});

  final String label;
  final ScanStepStatus status;
  final String? detail;

  ScanStep copyWith({ScanStepStatus? status, String? detail}) => ScanStep(
        label: label,
        status: status ?? this.status,
        detail: detail ?? this.detail,
      );
}

class ScanLogNotifier extends StateNotifier<List<ScanStep>> {
  ScanLogNotifier() : super(const []);

  void reset() => state = const [];

  void add(String label) =>
      state = [...state, ScanStep(label: label, status: ScanStepStatus.running)];

  void completeLast({String? detail}) {
    if (state.isEmpty) return;
    final copy = List<ScanStep>.from(state);
    copy[copy.length - 1] =
        copy.last.copyWith(status: ScanStepStatus.done, detail: detail);
    state = copy;
  }

  void errorLast(String detail) {
    if (state.isEmpty) return;
    final copy = List<ScanStep>.from(state);
    copy[copy.length - 1] =
        copy.last.copyWith(status: ScanStepStatus.error, detail: detail);
    state = copy;
  }
}

final scanLogProvider =
    StateNotifierProvider<ScanLogNotifier, List<ScanStep>>(
  (ref) => ScanLogNotifier(),
);
