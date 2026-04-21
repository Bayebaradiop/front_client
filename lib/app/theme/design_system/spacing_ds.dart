/// Design System Spacing
/// Échelle d'espacement standardisée pour la cohérence visuelle
/// Approche: 4px base unit (multiples de 4 pour l'alignement grid)
class DSSpacing {
  DSSpacing._();

  // ─── 4PX BASE UNIT ────────────────────────────────────────
  static const double xs = 4;

  // ─── SCALE (Multiples of 4) ───────────────────────────────
  static const double sm = 8; // 2x
  static const double md = 12; // 3x
  static const double lg = 16; // 4x
  static const double xl = 24; // 6x
  static const double xxl = 32; // 8x
  static const double xxxl = 48; // 12x

  // ─── COMMONLY USED COMBINATIONS ────────────────────────────
  
  /// Default padding for cards, containers
  static const double cardPadding = lg; // 16px
  
  /// Default margin between sections
  static const double sectionSpacing = xxl; // 32px
  
  /// Default margin between items in list
  static const double itemSpacing = lg; // 16px
  
  /// Button padding: horizontal
  static const double buttonPaddingH = xl; // 24px
  
  /// Button padding: vertical
  static const double buttonPaddingV = lg; // 16px

  /// Input field padding
  static const double inputPadding = md; // 12px

  /// Dialog padding
  static const double dialogPadding = xxl; // 32px

  // ─── GRID & LAYOUT ────────────────────────────────────────
  
  /// Top padding for SafeArea content
  static const double topSafe = lg; // 16px
  
  /// Bottom padding for off-screen safe area
  static const double bottomSafe = xl; // 24px
  
  /// Horizontal screen margin (mobile-first)
  static const double screenMargin = lg; // 16px
}
