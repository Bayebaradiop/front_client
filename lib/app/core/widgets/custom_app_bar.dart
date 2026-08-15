import 'package:flutter/material.dart';
import '../../theme/design_system/colors_ds.dart';
import '../../theme/design_system/typography_ds.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? DSColors.surface;
    final fg = foregroundColor ?? DSColors.textPrimary;

    return AppBar(
      title: Text(
        title,
        style: DSTypography.headingSmall.copyWith(
          color: fg,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: bg,
      foregroundColor: fg,
      scrolledUnderElevation: 0.5,
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: DSColors.primaryUltraLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: fg),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            )
          : null,
      actions: actions,
      elevation: 0,
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: DSColors.borderLight,
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
