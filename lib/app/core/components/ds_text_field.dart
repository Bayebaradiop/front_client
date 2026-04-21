import 'package:flutter/material.dart';
import '../../theme/design_system/colors_ds.dart';
import '../../theme/design_system/typography_ds.dart';
import '../../theme/design_system/spacing_ds.dart';
import '../../theme/design_system/border_radius_ds.dart';

/// Accessible text input field with label, error state, and helper text
class DSTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;

  const DSTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
  }) : super(key: key);

  @override
  State<DSTextField> createState() => _DSTextFieldState();
}

class _DSTextFieldState extends State<DSTextField> {
  late FocusNode _internalFocusNode;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
  }

  @override
  void didUpdateWidget(DSTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = _hasError
        ? DSColors.error
        : (_internalFocusNode.hasFocus
            ? DSColors.primary
            : (isDarkMode
                ? DSColors.darkBorder
                : DSColors.borderLight));
    final fillColor = isDarkMode
        ? DSColors.darkSurface.withOpacity(0.5)
        : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(bottom: DSSpacing.sm),
          child: Text(
            widget.label,
            style: DSTypography.labelMedium.copyWith(
              color: isDarkMode
                  ? DSColors.darkTextPrimary
                  : DSColors.textPrimary,
            ),
            semanticsLabel: widget.label,
          ),
        ),
        // Input Field
        Semantics(
          label: '${widget.label} - ${widget.helperText ?? ''}',
          enabled: widget.enabled,
          child: TextField(
            controller: widget.controller,
            focusNode: _internalFocusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            style: DSTypography.bodyLarge.copyWith(
              color: isDarkMode
                  ? DSColors.darkTextPrimary
                  : DSColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText ?? widget.label,
              hintStyle: DSTypography.bodyLarge.copyWith(
                color: isDarkMode
                    ? DSColors.darkTextSecondary.withOpacity(0.5)
                    : DSColors.textSecondary.withOpacity(0.6),
              ),
              filled: true,
              fillColor: fillColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: DSSpacing.inputPadding,
                vertical: DSSpacing.inputPadding,
              ),
              border: OutlineInputBorder(
                borderRadius: DSBorderRadius.mediumRadius,
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: DSBorderRadius.mediumRadius,
                borderSide: BorderSide(
                  color: isDarkMode
                      ? DSColors.darkBorder
                      : DSColors.borderLight,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: DSBorderRadius.mediumRadius,
                borderSide: BorderSide(
                  color: DSColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: DSBorderRadius.mediumRadius,
                borderSide: BorderSide(
                  color: DSColors.error,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: DSBorderRadius.mediumRadius,
                borderSide: BorderSide(
                  color: DSColors.error,
                  width: 2,
                ),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon != null
                  ? GestureDetector(
                      onTap: widget.onSuffixTap,
                      child: widget.suffixIcon,
                    )
                  : null,
              counterStyle: DSTypography.caption.copyWith(
                color: isDarkMode
                    ? DSColors.darkTextSecondary
                    : DSColors.textSecondary,
              ),
            ),
          ),
        ),
        // Helper or Error text
        if (widget.helperText != null && !_hasError) ...[
          SizedBox(height: DSSpacing.xs),
          Text(
            widget.helperText!,
            style: DSTypography.caption.copyWith(
              color: isDarkMode
                  ? DSColors.darkTextSecondary
                  : DSColors.textSecondary,
              fontSize: 12, // Ensure >= 13px minimum (fail-safe)
            ),
          ),
        ] else if (_hasError && widget.errorText != null) ...[
          SizedBox(height: DSSpacing.xs),
          Text(
            widget.errorText!,
            style: DSTypography.caption.copyWith(
              color: DSColors.error,
              fontSize: 12, // Ensure >= 13px minimum (fail-safe)
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
