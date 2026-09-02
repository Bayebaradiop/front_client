import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../routes/app_routes.dart';
import '../controllers/medecin_controller.dart';
import '../../../translate/translation_keys.dart';

class MedecinsView extends StatelessWidget {
  const MedecinsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedecinController>();

    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: CustomAppBar(title: Tr.doctors.tr),
      body: Column(
        children: [
          // Filtres spécialités
          Container(
            color: DSColors.surface,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 40,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const FilterPillsSkeleton();
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.specialitesFilter.length,
                  itemBuilder: (_, i) {
                    final spec = controller.specialitesFilter[i];
                    final isSelected =
                        controller.selectedSpecialiteId.value ==
                            spec['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => controller.filterBySpecialite(spec['id']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? DSColors.primary
                                : DSColors.primaryUltraLight,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? DSColors.primary
                                  : DSColors.borderLight,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: DSColors.primary.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              spec['nom'] ?? '',
                              style: DSTypography.labelSmall.copyWith(
                                color: isSelected
                                    ? DSColors.white
                                    : DSColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          const SizedBox(height: 8),

          // Liste des Médecins
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const MedecinCardSkeleton(itemCount: 5);
              }
              final medecins = controller.medecinsFiltres;
              if (medecins.isEmpty) {
                return EmptyState(
                  icon: Iconsax.user_search,
                  title: Tr.noDoctors.tr,
                  subtitle: Tr.tryAnotherFilter.tr,
                );
              }
              return RefreshIndicator(
                color: DSColors.primary,
                onRefresh: () async => controller.refresh(),
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: medecins.length,
                    itemBuilder: (context, index) {
                      final med = medecins[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 350),
                        child: SlideAnimation(
                          verticalOffset: 24.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CustomCard(
                                onTap: () {
                                  controller.selectMedecin(med);
                                  Get.toNamed(AppRoutes.medecinDetail,
                                      arguments: {'medecin': med});
                                },
                                child: Row(
                                  children: [
                                    // Avatar médecin avec pastille de disponibilité
                                    Stack(
                                      children: [
                                        UserAvatar(
                                          photoUrl: med['photo'] as String?,
                                          initials:
                                              '${((med['prenom'] as String?) ?? '').isNotEmpty ? (med['prenom'] as String)[0] : ''}'
                                              '${((med['nom'] as String?) ?? '').isNotEmpty ? (med['nom'] as String)[0] : ''}',
                                          radius: 26,
                                          backgroundColor: DSColors.primaryUltraLight,
                                          textColor: DSColors.primary,
                                          fontSize: 16,
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF10B981),
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dr. ${med['prenom'] ?? ''} ${med['nom'] ?? ''}',
                                            style: DSTypography.headingSmall.copyWith(
                                              color: DSColors.textPrimary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            med['specialiteNom'] ?? '',
                                            style: DSTypography.labelSmall.copyWith(
                                              color: DSColors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Iconsax.hospital,
                                                size: 13,
                                                color: DSColors.textSecondary,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  med['cabinetNom'] ?? '',
                                                  style: DSTypography.bodySmall.copyWith(
                                                    color: DSColors.textSecondary,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Bouton CTA "Prendre RDV"
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: DSColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: DSColors.primary.withValues(alpha: 0.2),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        'Prendre RDV',
                                        style: DSTypography.labelSmall.copyWith(
                                          color: DSColors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
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
          ),
        ],
      ),
    );
  }
}
