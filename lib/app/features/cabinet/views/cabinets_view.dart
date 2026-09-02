import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/widgets/cabinet_logo.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../translate/translation_keys.dart';
import '../controllers/cabinet_controller.dart';

class CabinetsView extends StatelessWidget {
  const CabinetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CabinetController>();

    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: CustomAppBar(title: Tr.medicalCabinets.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CabinetCardSkeleton(itemCount: 5);
        }
        if (controller.cabinets.isEmpty) {
          return EmptyState(
            icon: Iconsax.hospital,
            title: Tr.noCabinets.tr,
            subtitle: Tr.comeBackLater.tr,
          );
        }
        return RefreshIndicator(
          color: DSColors.primary,
          onRefresh: () => controller.refresh(),
          child: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              itemCount: controller.cabinets.length,
              itemBuilder: (context, index) {
                final cabinet = controller.cabinets[index];
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
                          borderRadius: BorderRadius.circular(22),
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
                          borderRadius: BorderRadius.circular(22),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Get.toNamed(
                                AppRoutes.cabinetDetail,
                                arguments: {'cabinet': cabinet},
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CabinetLogo(
                                    logoUrl: cabinet.logo,
                                    size: 54,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cabinet.nom ?? '',
                                          style: DSTypography.headingSmall.copyWith(
                                            color: DSColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Iconsax.location,
                                              size: 14,
                                              color: DSColors.primary,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                cabinet.adresse ?? '',
                                                style: DSTypography.bodySmall.copyWith(
                                                  color: DSColors.textSecondary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (cabinet.telephone != null &&
                                            cabinet.telephone!.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(
                                                Iconsax.call,
                                                size: 14,
                                                color: DSColors.textLight,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                cabinet.telephone!,
                                                style: DSTypography.bodySmall.copyWith(
                                                  color: DSColors.textLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
