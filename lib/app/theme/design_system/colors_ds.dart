import 'package:flutter/material.dart';

/// Design System Colors - Minimaliste & Élégant
/// Palette épurée: 1 couleur primaire + gradations de gris
class DSColors {
  DSColors._(); // Private constructor

  // ─── PRIMARY (BLEU SEUL) ───────────────────────────────────
  static const Color primary = Color(0xFF2563EB); // Bleu unique & cohérent

  // ─── PRIMARY VARIANTS ────────────────────────────────────────
  static const Color primaryDark = Color(
    0xFF1D4ED8,
  ); // Bleu foncé - pressed state
  static const Color primaryLight = Color(
    0xFF3B82F6,
  ); // Bleu clair - hover state
  static const Color primaryUltraLight = Color(
    0xFFDBEAFE,
  ); // Bleu très clair - backgrounds

  // ─── NEUTRAL SCALE (GRIS SIMPLES) ──────────────────────────
  // Light Mode
  static const Color textPrimary = Color(0xFF1F2937); // Gris foncé pour texte
  static const Color textSecondary = Color(
    0xFF6B7280,
  ); // Gris moyen pour subtitle
  static const Color background = Color(0xFFFAFAFA); // Blanc cassé (très léger)
  static const Color surface = Color(0xFFFFFFFF); // Blanc pur pour cartes
  static const Color border = Color(
    0xFFE5E7EB,
  ); // Gris très léger pour bordures

  // Dark Mode
  static const Color darkTextPrimary = Color(0xFFF3F4F6); // Blanc cassé
  static const Color darkTextSecondary = Color(0xFFD1D5DB); // Gris clair
  static const Color darkBackground = Color(0xFF111827); // Noir pur (fond)
  static const Color darkSurface = Color(0xFF1F2937); // Gris foncé (cartes)
  static const Color darkBorder = Color(0xFF374151); // Gris moyen (bordures)

  // ─── SEMANTIC (MINIMAL) ─────────────────────────────────────
  static const Color error = Color(0xFFDC2626); // Rouge (erreurs seulement)
  static const Color success = Color(
    0xFF0EA5E9,
  ); // Bleu ciel (confirmation - inspiré Doctorlib)

  // ─── UTILITY ────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // ─── COLOR FROM HEX ───────────────────────────────────────────
  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  // ─── ALIASES ────────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE5E7EB);
}
