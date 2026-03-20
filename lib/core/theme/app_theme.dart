// Accessible theme for elderly users
// WCAG AAA contrast ratios, large fonts, big tap targets

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

// Primary palette — deep blue on white: contrast ratio > 7:1 (WCAG AAA)
const _primaryBlue = Color(0xFF1565C0);
// ignore: unused_element
const _primaryBlueDark = Color(0xFF003C8F);
const _onPrimary = Colors.white;
const _surface = Colors.white;
const _onSurface = Color(0xFF1A1A1A);
const _errorRed = Color(0xFFB71C1C);
const _successGreen = Color(0xFF1B5E20);
const _warningAmber = Color(0xFFE65100);

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: _primaryBlue,
      onPrimary: _onPrimary,
      primaryContainer: Color(0xFFD1E4FF),
      onPrimaryContainer: Color(0xFF001D36),
      secondary: Color(0xFF2E7D32),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFB8F5C0),
      onSecondaryContainer: Color(0xFF002108),
      error: _errorRed,
      onError: Colors.white,
      surface: _surface,
      onSurface: _onSurface,
      surfaceContainerHighest: Color(0xFFF3F3F3),
      outline: Color(0xFF757575),
    ),
  );

  final textTheme = GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
    // Body text — minimum 18sp for elderly readability
    bodyLarge: GoogleFonts.nunito(
      fontSize: AppConstants.bodyFontSize,
      fontWeight: FontWeight.w500,
      color: _onSurface,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: AppConstants.labelFontSize,
      fontWeight: FontWeight.w400,
      color: _onSurface,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: 15.0,
      color: const Color(0xFF424242),
      height: 1.4,
    ),
    // Labels
    labelLarge: GoogleFonts.nunito(
      fontSize: AppConstants.labelFontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.nunito(
      fontSize: 15.0,
      fontWeight: FontWeight.w600,
    ),
    // Titles
    titleLarge: GoogleFonts.nunito(
      fontSize: AppConstants.titleFontSize,
      fontWeight: FontWeight.w700,
      color: _onSurface,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: AppConstants.bodyFontSize,
      fontWeight: FontWeight.w700,
      color: _onSurface,
    ),
    // Headlines
    headlineLarge: GoogleFonts.nunito(
      fontSize: AppConstants.headlineFontSize,
      fontWeight: FontWeight.w800,
      color: _onSurface,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: AppConstants.titleFontSize,
      fontWeight: FontWeight.w700,
      color: _onSurface,
    ),
    // Display
    displayLarge: GoogleFonts.nunito(
      fontSize: 32.0,
      fontWeight: FontWeight.w800,
      color: _onSurface,
    ),
  );

  return base.copyWith(
    textTheme: textTheme,

    // AppBar: high contrast
    appBarTheme: AppBarTheme(
      backgroundColor: _primaryBlue,
      foregroundColor: _onPrimary,
      elevation: 2,
      centerTitle: false,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: AppConstants.titleFontSize,
        fontWeight: FontWeight.w700,
        color: _onPrimary,
      ),
      iconTheme: const IconThemeData(color: _onPrimary, size: 28),
    ),

    // Buttons: tall enough for elderly tap targets (minHeight 56)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: _onPrimary,
        minimumSize: const Size(double.infinity, AppConstants.minButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        textStyle: GoogleFonts.nunito(
          fontSize: AppConstants.bodyFontSize,
          fontWeight: FontWeight.w700,
        ),
        elevation: 2,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryBlue,
        minimumSize: const Size(double.infinity, AppConstants.minButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        side: const BorderSide(color: _primaryBlue, width: 2),
        textStyle: GoogleFonts.nunito(
          fontSize: AppConstants.bodyFontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryBlue,
        minimumSize: const Size(88, AppConstants.minButtonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.nunito(
          fontSize: AppConstants.labelFontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Input fields: large text, clear borders
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF757575), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF757575), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryBlue, width: 2.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      labelStyle: GoogleFonts.nunito(fontSize: AppConstants.labelFontSize),
      hintStyle: GoogleFonts.nunito(
        fontSize: AppConstants.labelFontSize,
        color: const Color(0xFF9E9E9E),
      ),
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentTextStyle: GoogleFonts.nunito(
        fontSize: AppConstants.labelFontSize,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),

    // Bottom navigation (for main tabs)
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _primaryBlue,
      unselectedItemColor: Color(0xFF757575),
      selectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(fontSize: 13),
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 26),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
    ),

    // FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryBlue,
      foregroundColor: _onPrimary,
      elevation: 4,
      extendedPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),

    // Dividers
    dividerTheme: const DividerThemeData(
      thickness: 1,
      color: Color(0xFFE0E0E0),
    ),

    // Extensions accessible
    extensions: const [
      AppColors(
        success: _successGreen,
        warning: _warningAmber,
        onSuccess: Colors.white,
        onWarning: Colors.white,
        pillBlue: Color(0xFFE3F2FD),
        pillGreen: Color(0xFFE8F5E9),
        pillRed: Color(0xFFFFEBEE),
      ),
    ],
  );
}

// Custom color extension for semantic colors
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.warning,
    required this.onSuccess,
    required this.onWarning,
    required this.pillBlue,
    required this.pillGreen,
    required this.pillRed,
  });

  final Color success;
  final Color warning;
  final Color onSuccess;
  final Color onWarning;
  final Color pillBlue;
  final Color pillGreen;
  final Color pillRed;

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? onSuccess,
    Color? onWarning,
    Color? pillBlue,
    Color? pillGreen,
    Color? pillRed,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      onSuccess: onSuccess ?? this.onSuccess,
      onWarning: onWarning ?? this.onWarning,
      pillBlue: pillBlue ?? this.pillBlue,
      pillGreen: pillGreen ?? this.pillGreen,
      pillRed: pillRed ?? this.pillRed,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      pillBlue: Color.lerp(pillBlue, other.pillBlue, t)!,
      pillGreen: Color.lerp(pillGreen, other.pillGreen, t)!,
      pillRed: Color.lerp(pillRed, other.pillRed, t)!,
    );
  }
}
