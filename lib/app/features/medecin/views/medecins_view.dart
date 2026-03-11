import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../routes/app_routes.dart';
import '../controllers/medecin_controller.dart';
import '../../../translate/translation_keys.dart';

class MedecinsView extends StatelessWidget {
  const MedecinsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedecinController>();

    return Scaffold(
      appBar: CustomAppBar(title: Tr.doctors.tr),
      body: Column(
        children: [
          // Filtres spécialités (chips horizontaux)
          Container(
            color: AppColors.cardBackground,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 40,
              child: Obx(() => ListView.builder(
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
                        child: ChoiceChip(
                          label: Text(spec['nom'] ?? ''),
                          selected: isSelected,
                          onSelected: (_) =>
                              controller.filterBySpecialite(spec['id']),
                          selectedColor:
                              AppColors.primary.withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ),

          // Liste médecins
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const ShimmerLoading(itemCount: 4, height: 100);
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
                color: AppColors.primary,
                onRefresh: () async => controller.simulateLoading(),
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: medecins.length,
                    itemBuilder: (context, index) {
                      final med = medecins[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: CustomCard(
                              onTap: () {
                                controller.selectMedecin(med);
                                Get.toNamed(AppRoutes.medecinDetail,
                                    arguments: {'medecin': med});
                              },
                              child: Row(
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: AppColors.primary
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      '${(med['prenom'] as String)[0]}${(med['nom'] as String)[0]}',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dr. ${med['prenom']} ${med['nom']}',
                                          style: AppTextStyles.bodyBold,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(Iconsax.health,
                                                size: 13,
                                                color:
                                                    AppColors.primary),
                                            const SizedBox(width: 4),
                                            Text(
                                              med['specialiteNom'] ??
                                                  '',
                                              style:
                                                  AppTextStyles.caption
                                                      .copyWith(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                                Iconsax.hospital,
                                                size: 13,
                                                color: AppColors
                                                    .textLight),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                med['cabinetNom'] ??
                                                    '',
                                                style: AppTextStyles
                                                    .caption,
                                                maxLines: 1,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons
                                        .arrow_forward_ios_rounded,
                                    size: 16,
                                    color: AppColors.textLight,
                                  ),
                                ],
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
