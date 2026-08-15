import 'package:flutter/material.dart';

/// Design System Colors - Modern Executive Medical Aesthetics
class DSColors {
  DSColors._();

  // ─── PRIMARY (TEAL & CYAN MEDICAL EXECUTIVE) ────────────────────────────────
  static const Color primary = Color(0xFF0F766E); // Teal médical riche & captivant
  static const Color primaryDark = Color(0xFF115E59); // Teal profond
  static const Color primaryLight = Color(0xFF14B8A6); // Cyan/Teal vif & frais
  static const Color primaryUltraLight = Color(0xFFF0FDFA); // Fond très doux ultra-clean

  // ─── NEUTRAL SCALE (SLATE MEDICAL CLEAN) ──────────────────────────
  // Light Mode
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900 - Contraste parfait
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textLight = Color(0xFF94A3B8); // Slate 400
  static const Color background = Color(0xFFF8FAFC); // Slate clean ultra-lumineux
  static const Color surface = Color(0xFFFFFFFF); // Blanc pur cartes
  static const Color border = Color(0xFFF1F5F9); // Bordures subtiles
  static const Color borderLight = Color(0xFFE2E8F0);

  // Dark Mode
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // ─── SEMANTIC & STATUTS ─────────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF06B6D4);

  // ─── UTILITY ────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  // ─── ALIASES ────────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFFFFFFF);
}
