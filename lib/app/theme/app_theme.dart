import 'package:flutter/material.dart';
import 'design_system/colors_ds.dart';
import 'design_system/typography_ds.dart';
import 'design_system/spacing_ds.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Plus Jakarta Sans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: DSColors.primary,
      primary: DSColors.primary,
      secondary: DSColors.primaryLight,
      surface: DSColors.surface,
      error: DSColors.error,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: DSColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: DSColors.surface,
      foregroundColor: DSColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: DSTypography.headingSmall.copyWith(
        color: DSColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DSColors.primary,
        foregroundColor: DSColors.white,
        disabledBackgroundColor: DSColors.border,
        disabledForegroundColor: DSColors.textSecondary,
        elevation: 0,
        shadowColor: DSColors.primary.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: DSTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DSColors.primary,
        disabledForegroundColor: DSColors.textSecondary,
        side: const BorderSide(color: DSColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: DSTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DSColors.primary,
        disabledForegroundColor: DSColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: DSTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DSColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: DSColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: DSColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: DSColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: DSColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: DSColors.error, width: 2),
      ),
      hintStyle: DSTypography.bodyMedium.copyWith(
        color: DSColors.textLight,
      ),
      labelStyle: DSTypography.labelMedium.copyWith(
        color: DSColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      errorStyle: DSTypography.caption.copyWith(color: DSColors.error),
    ),
    cardTheme: CardThemeData(
      color: DSColors.surface,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: DSColors.border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DSColors.surface,
      selectedItemColor: DSColors.primary,
      unselectedItemColor: DSColors.textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: DSTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
      unselectedLabelStyle: DSTypography.labelSmall.copyWith(fontWeight: FontWeight.w500),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: DSColors.primary,
      unselectedLabelColor: DSColors.textSecondary,
      indicatorColor: DSColors.primary,
      labelStyle: DSTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
      unselectedLabelStyle: DSTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: DSColors.primaryUltraLight,
      selectedColor: DSColors.primary,
      labelStyle: DSTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      side: BorderSide.none,
    ),
    dividerTheme: const DividerThemeData(
      color: DSColors.border,
      thickness: 1,
      space: DSSpacing.itemSpacing,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Plus Jakarta Sans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: DSColors.primary,
      primary: DSColors.primaryLight,
      surface: DSColors.darkSurface,
      error: DSColors.error,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: DSColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: DSColors.darkSurface,
      foregroundColor: DSColors.darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: DSTypography.headingSmall.copyWith(
        color: DSColors.darkTextPrimary,
        fontWeight: FontWeight.w800,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DSColors.primaryLight,
        foregroundColor: DSColors.black,
        disabledBackgroundColor: DSColors.darkBorder,
        disabledForegroundColor: DSColors.darkTextSecondary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: DSTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    cardTheme: CardThemeData(
      color: DSColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: DSColors.darkBorder, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DSColors.darkSurface,
      selectedItemColor: DSColors.primaryLight,
      unselectedItemColor: DSColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
