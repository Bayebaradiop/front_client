import 'package:flutter/material.dart';

/// Design System Border Radius
/// Échelle de border radius standardisée pour la cohérence visuelle
class DSBorderRadius {
  DSBorderRadius._();

  // ─── SMALL (Subtle roundness) ──────────────────────────────
  /// 6px - for small inputs, badges, chips
  static const double small = 6;
  static BorderRadius smallRadius = BorderRadius.circular(small);

  // ─── MEDIUM (Standard) ────────────────────────────────────
  /// 12px - for buttons, cards, sheets (default)
  static const double medium = 12;
  static BorderRadius mediumRadius = BorderRadius.circular(medium);

  // ─── LARGE (Prominent) ────────────────────────────────────
  /// 20px - for dialogs, large containers
  static const double large = 20;
  static BorderRadius largeRadius = BorderRadius.circular(large);

  /// 24px - for extra-large containers (hero sections)
  static const double extraLarge = 24;
  static BorderRadius extraLargeRadius = BorderRadius.circular(extraLarge);

  // ─── UTILITIES ────────────────────────────────────────────
  
  /// Full border radius for circular elements (buttons, avatars)
  static const double circular = 999;
  static BorderRadius circularRadius = BorderRadius.circular(circular);

  /// Top corners only (bottom sheets, modals from bottom)
  static BorderRadius topOnly({
    double radius = medium,
  }) =>
      BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );

  /// Bottom corners only
  static BorderRadius bottomOnly({
    double radius = medium,
  }) =>
      BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
}
