import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/design_system/index.dart';

/// Accessible Button - Niveau Expert UX
/// Inclut: haptic feedback, states, loading, disabled
class AccessibleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool fullWidth;

  const AccessibleButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _height,
      child: variant == ButtonVariant.text
          ? TextButton(
              onPressed: isDisabled ? null : _handleTap,
              style: TextButton.styleFrom(
                foregroundColor: DSColors.primary,
                disabledForegroundColor: DSColors.textSecondary,
                padding: _padding,
              ),
              child: _buildChild(),
            )
          : variant == ButtonVariant.outlined
          ? OutlinedButton(
              onPressed: isDisabled ? null : _handleTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: DSColors.primary,
                disabledForegroundColor: DSColors.textSecondary,
                side: BorderSide(color: DSColors.primary, width: 2),
                padding: _padding,
              ),
              child: _buildChild(),
            )
          : ElevatedButton(
              onPressed: isDisabled ? null : _handleTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: DSColors.primary,
                foregroundColor: DSColors.white,
                disabledBackgroundColor: DSColors.border,
                disabledForegroundColor: DSColors.textSecondary,
                elevation: 2,
                padding: _padding,
              ),
              child: _buildChild(),
            ),
    );
  }

  void _handleTap() {
    if (isLoading) return;
    HapticFeedback.lightImpact();
    onPressed?.call();
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.primary
                ? DSColors.white
                : DSColors.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize),
          const SizedBox(width: 8),
          Text(label, style: DSTypography.labelLarge),
        ],
      );
    }

    return Text(label, style: DSTypography.labelLarge);
  }

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double get _iconSize {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

enum ButtonVariant { primary, outlined, text }

enum ButtonSize { small, medium, large }
