import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_system/index.dart';
import '../../translate/translation_keys.dart';

mixin SnackbarMixin {
  /// Affiche un Toast d'erreur moderne avec design style iOS / Glassmorphism
  void showError(
    String message, {
    String? title,
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final isDark = Get.isDarkMode;
    final displayTitle = title ?? Tr.error.tr;

    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.danger,
              color: AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayTitle,
                  style: DSTypography.labelLarge.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: DSTypography.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.85)
                        : AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                Get.back();
                onRetry();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                backgroundColor: AppColors.error.withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Réessayer',
                style: DSTypography.labelSmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
      messageText: const SizedBox.shrink(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.95)
          : Colors.white.withValues(alpha: 0.96),
      barBlur: 20,
      colorText: isDark ? Colors.white : AppColors.textPrimary,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 20,
      borderWidth: 1,
      borderColor: isDark
          ? AppColors.error.withValues(alpha: 0.3)
          : AppColors.error.withValues(alpha: 0.25),
      boxShadows: [
        BoxShadow(
          color: AppColors.error.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      duration: duration,
      maxWidth: 550,
    );
  }

  /// Affiche un Toast de succès moderne
  void showSuccess(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final isDark = Get.isDarkMode;

    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.tick_circle,
              color: AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: DSTypography.labelLarge.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: DSTypography.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.85)
                        : AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      messageText: const SizedBox.shrink(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.95)
          : Colors.white.withValues(alpha: 0.96),
      barBlur: 20,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 20,
      borderWidth: 1,
      borderColor: AppColors.success.withValues(alpha: 0.25),
      boxShadows: [
        BoxShadow(
          color: AppColors.success.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
      ],
      duration: duration,
      maxWidth: 550,
    );
  }

  /// Affiche un Toast d'avertissement moderne
  void showWarning(
    String title,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final isDark = Get.isDarkMode;

    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.warning_2,
              color: AppColors.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: DSTypography.labelLarge.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: DSTypography.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.85)
                        : AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      messageText: const SizedBox.shrink(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.95)
          : Colors.white.withValues(alpha: 0.96),
      barBlur: 20,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 20,
      borderWidth: 1,
      borderColor: AppColors.warning.withValues(alpha: 0.25),
      boxShadows: [
        BoxShadow(
          color: AppColors.warning.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
      ],
      duration: duration,
      maxWidth: 550,
    );
  }

  /// Affiche une modale BottomSheet pour les erreurs critiques avec bouton d'action
  void showCriticalErrorDialog({
    required String title,
    required String message,
    String? retryText,
    VoidCallback? onRetry,
  }) {
    final isDark = Get.isDarkMode;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.danger,
                size: 36,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: DSTypography.headingSmall.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: DSTypography.bodyMedium.copyWith(
                color: isDark ? DSColors.darkTextSecondary : AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: isDark ? Colors.white24 : AppColors.divider,
                      ),
                    ),
                    child: Text(
                      'Fermer',
                      style: DSTypography.labelMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onRetry();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        retryText ?? 'Réessayer',
                        style: DSTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
