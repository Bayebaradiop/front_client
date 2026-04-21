import 'package:flutter/material.dart';
import '../../theme/design_system/colors_ds.dart';
import '../../theme/design_system/typography_ds.dart';
import '../../theme/design_system/spacing_ds.dart';
import '../../theme/design_system/border_radius_ds.dart';

/// Primary action button with multiple variants
class DSButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Variant variant;
  final Size size;
  final Widget? icon;
  final bool iconOnLeft;
  final double? width;
  final double? height;

  const DSButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = Variant.primary,
    this.size = Size.medium,
    this.icon,
    this.iconOnLeft = true,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<DSButton> createState() => _DSButtonState();
}

enum Variant { primary, secondary, tertiary, danger, disabled }

enum Size { small, medium, large }

class _DSButtonState extends State<DSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressed() {
    _controller.forward().then((_) {
      _controller.reverse();
      if (widget.onPressed != null && !widget.isDisabled && !widget.isLoading) {
        widget.onPressed!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Determine colors based on variant
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    switch (widget.variant) {
      case Variant.primary:
        backgroundColor = DSColors.primary;
        foregroundColor = Colors.white;
        borderColor = DSColors.primary;
        break;
      case Variant.secondary:
        backgroundColor = isDarkMode
            ? DSColors.darkSurface.withOpacity(0.5)
            : DSColors.surfaceLight;
        foregroundColor = isDarkMode ? DSColors.darkTextPrimary : DSColors.textPrimary;
        borderColor = isDarkMode ? DSColors.darkBorder : DSColors.borderLight;
        break;
      case Variant.tertiary:
        backgroundColor = Colors.transparent;
        foregroundColor = DSColors.primary;
        borderColor = DSColors.primary;
        break;
      case Variant.danger:
        backgroundColor = DSColors.error;
        foregroundColor = Colors.white;
        borderColor = DSColors.error;
        break;
      case Variant.disabled:
        backgroundColor = isDarkMode ? DSColors.darkSurface : DSColors.surfaceLight;
        foregroundColor = isDarkMode ? DSColors.darkTextSecondary : DSColors.textSecondary;
        borderColor = Colors.transparent;
        break;
    }

    // Apply disabled state
    if (widget.isDisabled || widget.isLoading) {
      backgroundColor = backgroundColor.withOpacity(0.5);
      foregroundColor = foregroundColor.withOpacity(0.5);
    }

    // Determine sizing
    final (double paddingH, double paddingV, double fontSize) = switch (widget.size) {
      Size.small => (DSSpacing.lg, DSSpacing.sm, 14.0),
      Size.medium => (DSSpacing.buttonPaddingH, DSSpacing.buttonPaddingV, 16.0),
      Size.large => (DSSpacing.xxxl, DSSpacing.xl, 18.0),
    };

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isDisabled || widget.isLoading ? null : _onPressed,
            borderRadius: DSBorderRadius.mediumRadius,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: DSBorderRadius.mediumRadius,
                border: Border.all(
                  color: borderColor,
                  width: widget.variant == Variant.tertiary ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null && widget.iconOnLeft) ...[
                    widget.icon!,
                    SizedBox(width: DSSpacing.sm),
                  ],
                  if (widget.isLoading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(foregroundColor),
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        widget.label,
                        style: DSTypography.labelLarge.copyWith(
                          color: foregroundColor,
                          fontSize: fontSize,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (widget.icon != null && !widget.iconOnLeft) ...[
                    SizedBox(width: DSSpacing.sm),
                    widget.icon!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
