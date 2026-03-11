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
import '../controllers/specialite_controller.dart';
import '../../../translate/translation_keys.dart';

class SpecialitesView extends StatelessWidget {
  const SpecialitesView({super.key});

  IconData _getSpecialiteIcon(String nom) {
    final lower = nom.toLowerCase();
    if (lower.contains('général')) return Iconsax.health;
    if (lower.contains('cardio')) return Iconsax.heart;
    if (lower.contains('dermato')) return Iconsax.brush_1;
    if (lower.contains('pédia')) return Iconsax.lovely;
    if (lower.contains('ophtalmo')) return Iconsax.eye;
    if (lower.contains('dent')) return Iconsax.shield_tick;
    return Iconsax.health;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpecialiteController());

    return Scaffold(
      appBar: CustomAppBar(title: Tr.specialties.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ShimmerLoading(itemCount: 6, height: 90);
        }
        if (controller.specialites.isEmpty) {
          return EmptyState(
            icon: Iconsax.menu_board,
            title: Tr.noSpecialties.tr,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => controller.simulateLoading(),
          child: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: controller.specialites.length,
              itemBuilder: (context, index) {
                final spec = controller.specialites[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: CustomCard(
                        onTap: () => Get.toNamed(AppRoutes.medecins,
                            arguments: {'specialiteId': spec['id']}),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: Icon(
                                _getSpecialiteIcon(spec['nom'] ?? ''),
                                color: AppColors.primary,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(spec['nom'] ?? '',
                                      style: AppTextStyles.bodyBold),
                                  const SizedBox(height: 2),
                                  Text(
                                    spec['description'] ?? '',
                                    style: AppTextStyles.caption,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.hospital,
                                          size: 12,
                                          color: AppColors.textLight),
                                      const SizedBox(width: 4),
                                      Text(
                                        spec['cabinetNom'] ?? '',
                                        style: AppTextStyles.caption
                                            .copyWith(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: AppColors.textLight),
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
    );
  }
}
