import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderLeftColor;
  final double borderRadius;
  final Color? backgroundColor;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderLeftColor,
    this.borderRadius = 20,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkCardBackground : AppColors.cardBackground);

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: borderLeftColor != null
            ? Border(left: BorderSide(color: borderLeftColor!, width: 4))
            : Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
                width: 1,
              ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
