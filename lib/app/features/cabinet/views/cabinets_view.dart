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
import '../../../core/widgets/cabinet_logo.dart';
import '../../../routes/app_routes.dart';
import '../controllers/cabinet_controller.dart';
import '../../../translate/translation_keys.dart';

class CabinetsView extends StatelessWidget {
  const CabinetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CabinetController>();

    return Scaffold(
      appBar: CustomAppBar(title: Tr.medicalCabinets.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ShimmerLoading(itemCount: 5, height: 110);
        }
        if (controller.cabinets.isEmpty) {
          return EmptyState(
            icon: Iconsax.hospital,
            title: Tr.noCabinets.tr,
            subtitle: Tr.comeBackLater.tr,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.refresh(),
          child: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: controller.cabinets.length,
              itemBuilder: (context, index) {
                final cabinet = controller.cabinets[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: CustomCard(
                        onTap: () {
                          controller.selectCabinet(cabinet);
                          Get.toNamed(AppRoutes.cabinetDetail,
                              arguments: cabinet);
                        },
                        child: Row(
                          children: [
                            CabinetLogo(
                              logoUrl: cabinet.logo,
                              size: 52,
                              borderRadius: 14,
                              accentColor: AppColors.primary,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(cabinet.nom ?? '',
                                      style: AppTextStyles.bodyBold),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.location,
                                          size: 14,
                                          color: AppColors.textLight),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          cabinet.adresse ?? '',
                                          style: AppTextStyles.caption,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.call,
                                          size: 14,
                                          color: AppColors.textLight),
                                      const SizedBox(width: 4),
                                      Text(
                                        cabinet.telephone ?? '',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded,
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
