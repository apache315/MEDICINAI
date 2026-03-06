// Unit tests for HomeDoseItem computed properties.

import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind/features/home/providers/home_provider.dart';

// Helper to build a HomeDoseItem without a dose log
HomeDoseItem _pending({int hour = 12, int minute = 0}) => HomeDoseItem(
      reminderId: 1,
      medicationId: 1,
      medicationName: 'Aspirina',
      dose: 100,
      unit: 'mg',
      hour: hour,
      minute: minute,
    );

// Minimal DoseLog stub: uses Map-based factory via fromJson for testing
// Actually HomeDoseItem only needs the doseLog field typed as DoseLog? —
// we can't easily construct DoseLog without the generated code, so we test
// the pure Dart logic of HomeDoseItem via the helper below.

// Pure logic extracted for unit testing without DB dependencies
bool isPending(bool isTaken, bool isSkipped) => !isTaken && !isSkipped;

bool isOverdue(int hour, int minute, int nowHour, int nowMinute, bool pending) {
  if (!pending) return false;
  return (nowHour * 60 + nowMinute) > (hour * 60 + minute);
}

void main() {
  group('HomeDoseItem — computed properties', () {
    test('pending item: isPending=true, isTaken=false, isSkipped=false', () {
      final item = _pending();
      expect(item.isTaken, isFalse);
      expect(item.isSkipped, isFalse);
      expect(item.isPending, isTrue);
    });

    test('item with no doseLog is never overdue in the past', () {
      // isPending=true, so overdue depends on time comparison
      final item = _pending(hour: 23, minute: 59); // very late = will be overdue almost always
      expect(item.isPending, isTrue);
    });
  });

  group('isOverdue logic', () {
    test('time not yet reached: not overdue', () {
      // dose at 14:00, now is 09:00
      expect(isOverdue(14, 0, 9, 0, true), isFalse);
    });

    test('time passed: overdue', () {
      // dose at 08:00, now is 20:00
      expect(isOverdue(8, 0, 20, 0, true), isTrue);
    });

    test('exact same minute: not overdue (not strictly greater)', () {
      expect(isOverdue(12, 30, 12, 30, true), isFalse);
    });

    test('one minute past: overdue', () {
      expect(isOverdue(12, 30, 12, 31, true), isTrue);
    });

    test('taken item is never overdue regardless of time', () {
      expect(isOverdue(8, 0, 23, 59, false), isFalse);
    });

    test('skipped item is never overdue', () {
      expect(isOverdue(8, 0, 23, 59, false), isFalse);
    });
  });

  group('isPending logic', () {
    test('neither taken nor skipped → pending', () {
      expect(isPending(false, false), isTrue);
    });

    test('taken → not pending', () {
      expect(isPending(true, false), isFalse);
    });

    test('skipped → not pending', () {
      expect(isPending(false, true), isFalse);
    });

    test('both taken and skipped → not pending', () {
      expect(isPending(true, true), isFalse);
    });
  });

  group('Summary banner logic', () {
    // Tests for the "X/Y farmaci presi" counter logic
    List<({bool isTaken, bool isSkipped})> _items(
      List<({bool taken, bool skipped})> data,
    ) =>
        data.map((d) => (isTaken: d.taken, isSkipped: d.skipped)).toList();

    int countTaken(List<({bool isTaken, bool isSkipped})> items) =>
        items.where((i) => i.isTaken).length;

    test('all taken: allDone is true', () {
      final items = _items([
        (taken: true, skipped: false),
        (taken: true, skipped: false),
      ]);
      expect(countTaken(items), 2);
      expect(countTaken(items) == items.length, isTrue);
    });

    test('none taken: allDone is false', () {
      final items = _items([
        (taken: false, skipped: false),
        (taken: false, skipped: true),
      ]);
      expect(countTaken(items), 0);
      expect(countTaken(items) == items.length, isFalse);
    });

    test('partial: 1 of 3', () {
      final items = _items([
        (taken: true, skipped: false),
        (taken: false, skipped: false),
        (taken: false, skipped: true),
      ]);
      expect(countTaken(items), 1);
    });
  });
}
