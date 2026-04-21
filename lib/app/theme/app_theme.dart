import 'package:flutter/material.dart';
import 'design_system/colors_ds.dart';
import 'design_system/typography_ds.dart';
import 'design_system/spacing_ds.dart';
import 'design_system/border_radius_ds.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DSColors.primary,
      primary: DSColors.primary,
      surface: DSColors.surface,
      error: DSColors.error,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: DSColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: DSColors.primary,
      foregroundColor: DSColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: DSTypography.headingSmall.copyWith(color: DSColors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DSColors.primary,
        foregroundColor: DSColors.white,
        disabledBackgroundColor: DSColors.border,
        disabledForegroundColor: DSColors.textSecondary,
        elevation: 2,
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.buttonPaddingH,
          vertical: DSSpacing.buttonPaddingV,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: DSBorderRadius.mediumRadius,
        ),
        textStyle: DSTypography.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DSColors.primary,
        disabledForegroundColor: DSColors.textSecondary,
        side: BorderSide(color: DSColors.primary, width: 2),
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.buttonPaddingH,
          vertical: DSSpacing.buttonPaddingV,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: DSBorderRadius.mediumRadius,
        ),
        textStyle: DSTypography.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DSColors.primary,
        disabledForegroundColor: DSColors.textSecondary,
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.lg,
          vertical: DSSpacing.md,
        ),
        textStyle: DSTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DSColors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: DSSpacing.inputPadding,
        vertical: DSSpacing.inputPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.borderLight, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.borderLight, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.error, width: 2),
      ),
      hintStyle: DSTypography.bodyLarge.copyWith(
        color: DSColors.textSecondary.withAlpha(153),
      ),
      labelStyle: DSTypography.labelMedium.copyWith(
        color: DSColors.textPrimary,
      ),
      errorStyle: DSTypography.caption.copyWith(color: DSColors.error),
    ),
    cardTheme: CardThemeData(
      color: DSColors.surfaceLight,
      elevation: 2,
      shadowColor: Colors.black.withAlpha(25),
      shape: RoundedRectangleBorder(borderRadius: DSBorderRadius.mediumRadius),
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DSColors.surfaceLight,
      selectedItemColor: DSColors.primary,
      unselectedItemColor: DSColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: DSTypography.labelSmall,
      unselectedLabelStyle: DSTypography.labelSmall,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: DSColors.primary,
      unselectedLabelColor: DSColors.textSecondary,
      indicatorColor: DSColors.primary,
      labelStyle: DSTypography.labelLarge,
      unselectedLabelStyle: DSTypography.bodyMedium,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: DSColors.background,
      selectedColor: DSColors.primary.withAlpha(38),
      labelStyle: DSTypography.labelMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: DSColors.borderLight),
    ),
    dividerTheme: DividerThemeData(
      color: DSColors.borderLight.withAlpha(128),
      thickness: 1,
      space: DSSpacing.itemSpacing,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DSColors.primary,
      primary: DSColors.primary,
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
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DSColors.primary,
        foregroundColor: DSColors.white,
        disabledBackgroundColor: DSColors.darkBorder,
        disabledForegroundColor: DSColors.darkTextSecondary,
        elevation: 2,
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.buttonPaddingH,
          vertical: DSSpacing.buttonPaddingV,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: DSBorderRadius.mediumRadius,
        ),
        textStyle: DSTypography.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DSColors.primary,
        side: BorderSide(color: DSColors.primary, width: 2),
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.buttonPaddingH,
          vertical: DSSpacing.buttonPaddingV,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: DSBorderRadius.mediumRadius,
        ),
        textStyle: DSTypography.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DSColors.primary,
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.lg,
          vertical: DSSpacing.md,
        ),
        textStyle: DSTypography.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DSColors.darkSurface.withAlpha(128),
      contentPadding: EdgeInsets.symmetric(
        horizontal: DSSpacing.inputPadding,
        vertical: DSSpacing.inputPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.darkBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.darkBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: DSBorderRadius.mediumRadius,
        borderSide: BorderSide(color: DSColors.error, width: 2),
      ),
      hintStyle: DSTypography.bodyLarge.copyWith(
        color: DSColors.darkTextSecondary.withAlpha(128),
      ),
      labelStyle: DSTypography.labelMedium.copyWith(
        color: DSColors.darkTextPrimary,
      ),
      errorStyle: DSTypography.caption.copyWith(color: DSColors.error),
    ),
    cardTheme: CardThemeData(
      color: DSColors.darkSurface,
      elevation: 2,
      shadowColor: Colors.black.withAlpha(77),
      shape: RoundedRectangleBorder(borderRadius: DSBorderRadius.mediumRadius),
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DSColors.darkSurface,
      selectedItemColor: DSColors.primary,
      unselectedItemColor: DSColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: DSTypography.labelSmall,
      unselectedLabelStyle: DSTypography.labelSmall,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: DSColors.primary,
      unselectedLabelColor: DSColors.darkTextSecondary,
      indicatorColor: DSColors.primary,
      labelStyle: DSTypography.labelLarge,
      unselectedLabelStyle: DSTypography.bodyMedium,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: DSColors.darkBackground,
      selectedColor: DSColors.primary.withAlpha(64),
      labelStyle: DSTypography.labelMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: DSColors.darkBorder),
    ),
    dividerTheme: DividerThemeData(
      color: DSColors.darkBorder.withAlpha(77),
      thickness: 1,
      space: DSSpacing.itemSpacing,
    ),
  );
}
