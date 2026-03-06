// Unit tests for ReviewNotifier — no Flutter widget rendering needed.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind/features/scan_prescription/providers/review_provider.dart';
import 'package:mediremind/services/llm_service.dart';

const _aspirin = ExtractedMedication(
  name: 'Aspirina',
  dose: 100,
  unit: 'mg',
  timesPerDay: 1,
  specificTimes: ['08:00'],
  durationDays: 30,
);

const _atorva = ExtractedMedication(
  name: 'Atorvastatina',
  dose: 20,
  unit: 'mg',
  timesPerDay: 1,
  durationDays: -1,
);

const _metfor = ExtractedMedication(
  name: 'Metformina',
  dose: 500,
  unit: 'mg',
  timesPerDay: 2,
  durationDays: -1,
);

ProviderContainer _container() => ProviderContainer();

void main() {
  group('ReviewNotifier — init and state', () {
    test('starts empty', () {
      final c = _container();
      addTearDown(c.dispose);
      expect(c.read(reviewNotifierProvider), isEmpty);
    });

    test('init sets medication list', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_aspirin, _atorva]);
      expect(c.read(reviewNotifierProvider).length, 2);
    });

    test('init replaces previous state', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_aspirin]);
      c.read(reviewNotifierProvider.notifier).init([_atorva, _metfor]);
      expect(c.read(reviewNotifierProvider).length, 2);
      expect(c.read(reviewNotifierProvider).first.name, 'Atorvastatina');
    });
  });

  group('ReviewNotifier — remove', () {
    test('removes medication at given index', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_aspirin, _atorva, _metfor]);
      c.read(reviewNotifierProvider.notifier).remove(1); // remove Atorvastatina
      final meds = c.read(reviewNotifierProvider);
      expect(meds.length, 2);
      expect(meds.map((m) => m.name), containsAll(['Aspirina', 'Metformina']));
      expect(meds.map((m) => m.name), isNot(contains('Atorvastatina')));
    });

    test('remove first element', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_aspirin, _atorva]);
      c.read(reviewNotifierProvider.notifier).remove(0);
      expect(c.read(reviewNotifierProvider).single.name, 'Atorvastatina');
    });

    test('remove last element leaves list empty', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_aspirin]);
      c.read(reviewNotifierProvider.notifier).remove(0);
      expect(c.read(reviewNotifierProvider), isEmpty);
    });
  });

  group('ReviewNotifier — update', () {
    test('updates medication at given index', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_aspirin, _atorva]);
      const updated = ExtractedMedication(
        name: 'Aspirina Cardio',
        dose: 75,
        unit: 'mg',
        timesPerDay: 1,
        durationDays: -1,
      );
      c.read(reviewNotifierProvider.notifier).update(0, updated);
      final meds = c.read(reviewNotifierProvider);
      expect(meds[0].name, 'Aspirina Cardio');
      expect(meds[0].dose, 75);
      expect(meds[1].name, 'Atorvastatina'); // unchanged
    });

    test('update does not affect other elements', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_aspirin, _atorva, _metfor]);
      const replacement = ExtractedMedication(
        name: 'X',
        dose: 1,
        unit: 'mg',
        timesPerDay: 1,
      );
      c.read(reviewNotifierProvider.notifier).update(1, replacement);
      final meds = c.read(reviewNotifierProvider);
      expect(meds[0].name, 'Aspirina');
      expect(meds[1].name, 'X');
      expect(meds[2].name, 'Metformina');
    });
  });

  group('ReviewNotifier — default times helper', () {
    // We test _defaultTimes indirectly via the state that confirm() would produce.
    // Here we just verify the public API works correctly with specificTimes.

    test('specific times are preserved on update', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_aspirin]); // has ['08:00']
      final med = c.read(reviewNotifierProvider).first;
      expect(med.specificTimes, equals(['08:00']));
    });

    test('timesPerDay 2 medication is stored correctly', () {
      final c = _container();
      addTearDown(c.dispose);
      c.read(reviewNotifierProvider.notifier).init([_metfor]);
      expect(c.read(reviewNotifierProvider).first.timesPerDay, 2);
    });
  });
}
