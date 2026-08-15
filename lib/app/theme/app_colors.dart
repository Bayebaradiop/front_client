import 'package:flutter/material.dart';

/// Design System - Couleurs MediBook Mobile
class AppColors {
  // ═══════════════════════════════════════════════════════════════
  // COULEURS PRIMAIRES - TEAL MEDICAL EXECUTIVE
  // ═══════════════════════════════════════════════════════════════
  
  static const Color primary = Color(0xFF0F766E);
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primaryDark = Color(0xFF115E59);
  static const Color primaryUltraLight = Color(0xFFF0FDFA);
  static const Color secondary = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════
  // BACKGROUNDS & SURFACES
  // ═══════════════════════════════════════════════════════════════
  
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════
  // COULEURS DE TEXTE
  // ═══════════════════════════════════════════════════════════════
  
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════
  // STATUTS RDV
  // ═══════════════════════════════════════════════════════════════
  
  static const Color statusEnAttente = Color(0xFFF59E0B);
  static const Color statusConfirme = Color(0xFF0F766E);
  static const Color statusTermine = Color(0xFF64748B);
  static const Color statusAnnule = Color(0xFFEF4444);

  // ═══════════════════════════════════════════════════════════════
  // COULEURS UTILITAIRES
  // ═══════════════════════════════════════════════════════════════
  
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF06B6D4);
  
  static const Color divider = Color(0xFFF1F5F9);
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // ═══════════════════════════════════════════════════════════════
  // DARK MODE
  // ═══════════════════════════════════════════════════════════════
  
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextLight = Color(0xFF64748B);
  static const Color darkDivider = Color(0xFF334155);
  static const Color darkShimmerBase = Color(0xFF1E293B);
  static const Color darkShimmerHighlight = Color(0xFF334155);

  // ═══════════════════════════════════════════════════════════════
  // GRADIENTS EXECUTIVE
  // ═══════════════════════════════════════════════════════════════
  
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
  );

  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
