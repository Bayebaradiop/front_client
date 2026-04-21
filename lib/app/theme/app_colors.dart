import 'package:flutter/material.dart';

/// Design System - Couleurs MediBook
/// Couleur principale: BLEU (#1976D2)
class AppColors {
  // ═══════════════════════════════════════════════════════════════
  // COULEURS PRIMAIRES - BLEU MEDICAL
  // ═══════════════════════════════════════════════════════════════
  
  /// Bleu principal - confiance, santé
  static const Color primary = Color(0xFF1976D2);
  
  /// Bleu clair - accents, highlights
  static const Color primaryLight = Color(0xFF64B5F6);
  
  /// Bleu foncé - texte sur fond clair, appbar
  static const Color primaryDark = Color(0xFF0D47A1);
  
  /// Bleu très clair - backgrounds subtils
  static const Color primaryUltraLight = Color(0xFFE3F2FD);
  
  /// Secondary white
  static const Color secondary = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════
  // BACKGROUNDS
  // ═══════════════════════════════════════════════════════════════
  
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════
  // COULEURS DE TEXTE
  // ═══════════════════════════════════════════════════════════════
  
  /// Texte principal - bleu foncé pour contraste
  static const Color textPrimary = Color(0xFF0D47A1);
  
  /// Texte secondaire - gris foncé
  static const Color textSecondary = Color(0xFF475569);
  
  /// Texte light - gris moyen
  static const Color textLight = Color(0xFF94A3B8);
  
  /// Texte blanc
  static const Color textWhite = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════
  // STATUTS RDV
  // ═══════════════════════════════════════════════════════════════
  
  /// En attente - Orange
  static const Color statusEnAttente = Color(0xFFF59E0B);
  
  /// Confirmé - Bleu
  static const Color statusConfirme = Color(0xFF1976D2);
  
  /// Terminé - Gris
  static const Color statusTermine = Color(0xFF64748B);
  
  /// Annulé - Rouge
  static const Color statusAnnule = Color(0xFFEF4444);

  // ═══════════════════════════════════════════════════════════════
  // COULEURS UTILITAIRES
  // ═══════════════════════════════════════════════════════════════
  
  /// Erreur - Rouge
  static const Color error = Color(0xFFDC2626);
  
  /// Succès - Vert émeraude
  static const Color success = Color(0xFF10B981);
  
  /// Warning - Orange
  static const Color warning = Color(0xFFF59E0B);
  
  /// Info - Bleu
  static const Color info = Color(0xFF3B82F6);
  
  static const Color divider = Color(0xFFE2E8F0);
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF1F5F9);

  // ═══════════════════════════════════════════════════════════════
  // DARK MODE
  // ═══════════════════════════════════════════════════════════════
  
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextLight = Color(0xFF64748B);
  static const Color darkDivider = Color(0xFF334155);
  static const Color darkShimmerBase = Color(0xFF1E293B);
  static const Color darkShimmerHighlight = Color(0xFF334155);

  // ═══════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════
  
  /// Gradient splash screen - Bleu
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D47A1), Color(0xFF64B5F6)],
  );

  /// Gradient header cards - Bleu subtil
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
  );

  // ═══════════════════════════════════════════════════════════════
  // UTILITAIRE - COULEUR DEPUIS HEX
  // ═══════════════════════════════════════════════════════════════
  
  /// Convertit une chaîne hex en Color
  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
