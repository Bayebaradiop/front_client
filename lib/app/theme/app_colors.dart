import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF66BB6A);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color secondary = Color(0xFFFFFFFF);

  // Background
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // Texte
  static const Color textPrimary = Color(0xFF1B5E20);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Statuts RDV
  static const Color statusEnAttente = Color(0xFFFFA726);
  static const Color statusConfirme = Color(0xFF66BB6A);
  static const Color statusTermine = Color(0xFF78909C);
  static const Color statusAnnule = Color(0xFFEF5350);

  // Utilitaires
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ── Dark mode ────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextLight = Color(0xFF757575);
  static const Color darkDivider = Color(0xFF333333);
  static const Color darkShimmerBase = Color(0xFF2A2A2A);
  static const Color darkShimmerHighlight = Color(0xFF3A3A3A);

  // Gradient splash
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
  );

  // Couleur depuis hex string (pour les cabinets)
  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
