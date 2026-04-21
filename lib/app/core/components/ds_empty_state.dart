import 'package:flutter/material.dart';
import '../../theme/design_system/colors_ds.dart';
import '../../theme/design_system/typography_ds.dart';
import '../../theme/design_system/spacing_ds.dart';
import 'ds_button.dart';

/// Empty state displayed when no data is available
class DSEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final double iconSize;

  const DSEmptyState({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.actionLabel,
    this.onActionPressed,
    this.iconSize = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.screenMargin,
          vertical: DSSpacing.sectionSpacing,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: iconSize + DSSpacing.xxl,
              height: iconSize + DSSpacing.xxl,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DSColors.primary.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: DSColors.primary,
              ),
            ),
            SizedBox(height: DSSpacing.xxxl),
            // Title
            Text(
              title,
              style: DSTypography.headingMedium.copyWith(
                color: isDarkMode
                    ? DSColors.darkTextPrimary
                    : DSColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: DSSpacing.md),
              Text(
                subtitle!,
                style: DSTypography.bodyLarge.copyWith(
                  color: isDarkMode
                      ? DSColors.darkTextSecondary
                      : DSColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (actionLabel != null) ...[
              SizedBox(height: DSSpacing.xxxl),
              DSButton(
                label: actionLabel!,
                onPressed: onActionPressed,
                size: Size.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
