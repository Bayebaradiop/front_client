import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System Typography
/// Échelle typographique standardisée avec line-height optimisé
class DSTypography {
  DSTypography._();

  // ─── FONT FAMILY ──────────────────────────────────────────
  static TextStyle get _baseStyle => GoogleFonts.inter();

  // ─── DISPLAY & HEADINGS ───────────────────────────────────

  /// Display Large: 48px / bold
  static TextStyle get displayLarge => _baseStyle.copyWith(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.2, // 57.6px
    letterSpacing: -0.5,
  );

  /// Display Medium: 40px / bold
  static TextStyle get displayMedium => _baseStyle.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.25,
  );

  /// Display Small: 32px / bold
  static TextStyle get displaySmall => _baseStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  /// Heading 1: 36px / bold
  static TextStyle get headingLarge => _baseStyle.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    height: 1.25,
    letterSpacing: -0.2,
  );

  /// Heading 2: 28px / semibold
  static TextStyle get headingMedium => _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.1,
  );

  /// Heading 3: 22px / semibold
  static TextStyle get headingSmall => _baseStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  /// Subtitle: 18px / medium
  static TextStyle get subtitleLarge => _baseStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// Subtitle Small: 16px / medium
  static TextStyle get subtitleSmall => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  // ─── BODY ──────────────────────────────────────────────────

  /// Body Large: 16px / regular (par défaut)
  static TextStyle get bodyLarge => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.15,
  );

  /// Body Medium: 14px / regular
  static TextStyle get bodyMedium => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// Body Small: 14px / regular (MINIMUM for accessibility)
  static TextStyle get bodySmall => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.25,
  );

  // ─── LABELS & CAPTIONS ────────────────────────────────────

  /// Label Large: 16px / semibold (buttons)
  static TextStyle get labelLarge => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.5,
  );

  /// Label Medium: 13px / semibold
  static TextStyle get labelMedium => _baseStyle.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.5,
  );

  /// Label Small: 12px / semibold (badges, chips - smallest readable)
  static TextStyle get labelSmall => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.5,
  );

  /// Caption: 14px / regular (minimum - helper text)
  static TextStyle get caption => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0.4,
  );

  /// Overline: 11px / semibold (rare)
  static TextStyle get overline => _baseStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 1.5,
  );

  // ─── SEMANTIC STYLES ──────────────────────────────────────

  /// Bold version of any style
  static TextStyle bold(TextStyle style) =>
      style.copyWith(fontWeight: FontWeight.bold);

  /// Semibold version of any style
  static TextStyle semibold(TextStyle style) =>
      style.copyWith(fontWeight: FontWeight.w600);

  /// With custom color
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);
}
