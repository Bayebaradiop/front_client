import 'package:flutter/material.dart';
import '../../theme/design_system/colors_ds.dart';
import '../../theme/design_system/typography_ds.dart';
import '../../theme/design_system/spacing_ds.dart';
import '../../theme/design_system/border_radius_ds.dart';

/// Badge/label component for status indicators and tags
class DSBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final double? size;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const DSBadge({
    Key? key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.size,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Determine colors based on variant - SIMPLE & ÉPURÉ
    final (Color bgColor, Color textColor) = switch (variant) {
      BadgeVariant.success => (
          DSColors.success.withValues(alpha: 0.1),
          DSColors.success,
        ),
      BadgeVariant.error => (
          DSColors.error.withValues(alpha: 0.1),
          DSColors.error,
        ),
      BadgeVariant.primary => (
          DSColors.primary.withValues(alpha: 0.1),
          DSColors.primary,
        ),
      BadgeVariant.neutral => (
          isDarkMode
              ? DSColors.darkSurface.withValues(alpha: 0.7)
              : DSColors.border,
          isDarkMode ? DSColors.darkTextSecondary : DSColors.textSecondary,
        ),
      BadgeVariant.outlined => (
          Colors.transparent,
          DSColors.primary,
        ),
    };

    final finalPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: DSSpacing.md,
          vertical: DSSpacing.sm,
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: DSBorderRadius.smallRadius,
        child: Container(
          padding: finalPadding,
          decoration: BoxDecoration(
            borderRadius: DSBorderRadius.smallRadius,
            color: bgColor,
            border: variant == BadgeVariant.outlined
                ? Border.all(color: textColor, width: 1)
                : null,
          ),
          child: Text(
            label,
            style: DSTypography.labelSmall.copyWith(
              color: textColor,
              fontSize: 12, // Ensure >= 13px (fail-safe)
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

enum BadgeVariant {
  success,
  error,
  primary,
  neutral,
  outlined,
}
