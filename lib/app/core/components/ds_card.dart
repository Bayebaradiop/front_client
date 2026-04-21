import 'package:flutter/material.dart';
import '../../theme/design_system/colors_ds.dart';
import '../../theme/design_system/spacing_ds.dart';
import '../../theme/design_system/border_radius_ds.dart';

/// Reusable card component with elevation and proper styling
class DSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;

  const DSCard({
    Key? key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.backgroundColor,
    this.elevation = 2,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDarkMode ? DSColors.darkSurface : DSColors.surfaceLight);

    return Material(
      elevation: elevation,
      borderRadius: borderRadius ?? DSBorderRadius.mediumRadius,
      color: bgColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? DSBorderRadius.mediumRadius,
        child: Container(
          width: width,
          height: height,
          padding: padding ?? EdgeInsets.all(DSSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? DSBorderRadius.mediumRadius,
            border: Border.all(
              color: isDarkMode
                  ? DSColors.darkBorder.withOpacity(0.3)
                  : DSColors.borderLight.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
