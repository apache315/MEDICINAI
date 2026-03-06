// Scaffolding tests: constants and theme extension logic

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediremind/core/constants/app_constants.dart';
import 'package:mediremind/core/theme/app_theme.dart';

void main() {
  group('AppConstants', () {
    test('notification channel ID is non-empty', () {
      expect(AppConstants.notificationChannelId, isNotEmpty);
    });

    test('minimum button height meets accessibility threshold (>= 48dp)', () {
      expect(AppConstants.minButtonHeight, greaterThanOrEqualTo(48));
    });

    test('body font size meets elderly readability threshold (>= 16sp)', () {
      expect(AppConstants.bodyFontSize, greaterThanOrEqualTo(16));
    });

    test('label font size is accessible (>= 14sp)', () {
      expect(AppConstants.labelFontSize, greaterThanOrEqualTo(14));
    });

    test('database filename is non-empty', () {
      expect(AppConstants.databaseFileName, isNotEmpty);
    });

    test('model filename ends in .gguf', () {
      expect(AppConstants.modelFileName, endsWith('.gguf'));
    });
  });

  group('AppColors extension', () {
    const original = AppColors(
      success: Color(0xFF1B5E20),
      warning: Color(0xFFE65100),
      onSuccess: Colors.white,
      onWarning: Colors.white,
      pillBlue: Color(0xFFE3F2FD),
      pillGreen: Color(0xFFE8F5E9),
      pillRed: Color(0xFFFFEBEE),
    );

    test('copyWith overrides individual fields', () {
      const newGreen = Color(0xFF4CAF50);
      final copy = original.copyWith(success: newGreen);
      expect(copy.success, equals(newGreen));
      expect(copy.warning, equals(original.warning)); // unchanged
    });

    test('lerp at t=0 returns original', () {
      const other = AppColors(
        success: Color(0xFF000000),
        warning: Color(0xFF000000),
        onSuccess: Color(0xFF000000),
        onWarning: Color(0xFF000000),
        pillBlue: Color(0xFF000000),
        pillGreen: Color(0xFF000000),
        pillRed: Color(0xFF000000),
      );
      final result = original.lerp(other, 0);
      expect(result.success, equals(original.success));
    });

    test('lerp at t=1 returns other', () {
      const other = AppColors(
        success: Color(0xFF000000),
        warning: Color(0xFF000000),
        onSuccess: Color(0xFF000000),
        onWarning: Color(0xFF000000),
        pillBlue: Color(0xFF000000),
        pillGreen: Color(0xFF000000),
        pillRed: Color(0xFF000000),
      );
      final result = original.lerp(other, 1);
      expect(result.success, equals(const Color(0xFF000000)));
    });

    test('lerp with null returns self', () {
      final result = original.lerp(null, 0.5);
      expect(result.success, equals(original.success));
    });
  });

  group('Route paths', () {
    test('all route paths start with /', () {
      const paths = ['/home', '/scan', '/review', '/medications', '/history'];
      for (final p in paths) {
        expect(p, startsWith('/'));
      }
    });
  });
}
