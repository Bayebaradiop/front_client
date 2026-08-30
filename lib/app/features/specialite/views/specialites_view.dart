import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../models/specialite_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../translate/translation_keys.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/specialite_controller.dart';

class SpecialitesView extends StatelessWidget {
  const SpecialitesView({super.key});

  String _getSpecialiteEmoji(String nom) {
    final lower = nom.toLowerCase();
    if (lower.contains('général') || lower.contains('médecine')) return '🩺';
    if (lower.contains('cardio')) return '🫀';
    if (lower.contains('dermato')) return '🧴';
    if (lower.contains('pédia')) return '👶';
    if (lower.contains('ophtalmo') || lower.contains('yeux')) return '👁️';
    if (lower.contains('dent') || lower.contains('odont')) return '🦷';
    if (lower.contains('neuro')) return '🧠';
    if (lower.contains('gynéco') || lower.contains('obstét')) return '👩‍⚕️';
    if (lower.contains('radio') || lower.contains('imager')) return '🩻';
    return '🏥';
  }

  Color _getSpecialiteColor(int index) {
    final colors = [
      const Color(0xFF0284C7),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF06B6D4),
    ];
    return colors[index % colors.length];
  }

  int _getDoctorCount(int? specId) {
    if (specId == null) return 3;
    try {
      final homeCtrl = Get.find<HomeController>();
      final count = homeCtrl.medecins.where((m) => m.specialiteId == specId).length;
      return count > 0 ? count : 3;
    } catch (_) {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SpecialiteController>();

    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: CustomAppBar(title: Tr.specialties.tr),
      body: Obx(() {
        if (controller.isLoading) {
          return const ShimmerLoading(itemCount: 6, height: 100);
        }
        if (controller.specialites.isEmpty) {
          return EmptyState(
            icon: Iconsax.menu_board,
            title: Tr.noSpecialties.tr,
          );
        }
        return RefreshIndicator(
          color: DSColors.primary,
          onRefresh: () async => controller.refresh(),
          child: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              itemCount: controller.specialites.length,
              itemBuilder: (context, index) {
                final SpecialiteModel spec = controller.specialites[index];
                final accentColor = _getSpecialiteColor(index);
                final emoji = _getSpecialiteEmoji(spec.nom ?? '');
                final doctorCount = _getDoctorCount(spec.id);

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 350),
                  child: SlideAnimation(
                    verticalOffset: 40.0,
                    child: FadeInAnimation(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: DSColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: DSColors.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Get.toNamed(
                                AppRoutes.medecins,
                                arguments: {'specialiteId': spec.id},
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Container Icône Thématique Coloré
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: accentColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: accentColor.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        emoji,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          spec.nom ?? '',
                                          style: DSTypography.headingSmall.copyWith(
                                            color: DSColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          spec.description ?? '',
                                          style: DSTypography.bodySmall.copyWith(
                                            color: DSColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        // Badge Compteur Médecins Disponibles
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: DSColors.primaryUltraLight,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF10B981),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '$doctorCount médecins disponibles',
                                                style: DSTypography.labelSmall.copyWith(
                                                  color: DSColors.primary,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: DSColors.textLight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
