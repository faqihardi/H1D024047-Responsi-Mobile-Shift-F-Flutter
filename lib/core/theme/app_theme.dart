import 'package:flutter/material.dart';

class AppColors {
  static const accent = Color(0xFF2563EB);
  static const bg = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFECECF0);
  static const ink = Color(0xFF18181B);
  static const muted = Color(0xFF71717A);
  static const faint = Color(0xFFA1A1AA);
}

class AppTheme {
  static const font = 'Poppins';

  static TextStyle _s(
    double size,
    FontWeight weight, {
    Color color = AppColors.ink,
    double? spacing,
    double height = 1.35,
  }) => TextStyle(
    fontFamily: font,
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: spacing,
    height: height,
  );

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.accent).copyWith(
      primary: AppColors.accent,
      onPrimary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      error: const Color(0xFFDC2626),
    );

    final text = TextTheme(
      displayMedium: _s(56, FontWeight.w300, spacing: -2, height: 1.05),
      headlineSmall: _s(22, FontWeight.w600, spacing: -0.3),
      titleMedium: _s(15, FontWeight.w600),
      titleSmall: _s(13, FontWeight.w500),
      bodyMedium: _s(14, FontWeight.w400),
      bodySmall: _s(12, FontWeight.w400, color: AppColors.muted),
      labelSmall: _s(11, FontWeight.w500, color: AppColors.faint, spacing: 0.6),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: font,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: text,
      dividerColor: AppColors.border,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.ink,
        titleTextStyle: _s(17, FontWeight.w600),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: _s(14, FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: _s(13, FontWeight.w500),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: _s(13, FontWeight.w400, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearMinHeight: 2,
      ),
    );
  }
}

/// Decoration input
class AppInput {
  static InputDecoration search({Widget? suffix}) => InputDecoration(
    hintText: 'Cari nama kota, mis. Yogyakarta',
    hintStyle: const TextStyle(
      fontFamily: AppTheme.font,
      fontSize: 14,
      color: AppColors.faint,
    ),
    prefixIcon: const Icon(
      Icons.search_rounded,
      size: 20,
      color: AppColors.muted,
    ),
    suffixIcon: suffix,
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.accent, width: 1.4),
    ),
  );
}
