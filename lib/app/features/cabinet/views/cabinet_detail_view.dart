import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../models/cabinet_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/cabinet_logo.dart';
import '../../../routes/app_routes.dart';
import '../controllers/cabinet_controller.dart';
import '../../../translate/translation_keys.dart';

class CabinetDetailView extends StatelessWidget {
  const CabinetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CabinetController>();
    final cabinet = controller.selectedCabinet.value ??
        (Get.arguments is CabinetModel ? Get.arguments as CabinetModel : null);
    final color =
        AppColors.fromHex(cabinet?.couleurPrimaire ?? '#007bff');
    final accentColor =
        AppColors.fromHex(cabinet?.couleurSecondaire ?? '#43A047');
    // Texte sur fond primaire = toujours blanc (lisibilité garantie)
    const textOnPrimary = Colors.white;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header avec couleur du cabinet
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: color,
            foregroundColor: textOnPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: textOnPrimary),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color,
                      color.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CabinetLogo(
                            logoUrl: cabinet?.logo,
                            size: 72,
                            borderRadius: 20,
                            accentColor: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            cabinet?.nom ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: textOnPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Infos du cabinet
                  Text(Tr.information.tr, style: AppTextStyles.heading3),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Iconsax.location,
                    label: Tr.address.tr,
                    value: cabinet?.adresse ?? '',
                    color: color,
                  ),
                  _InfoRow(
                    icon: Iconsax.call,
                    label: Tr.phone.tr,
                    value: cabinet?.telephone ?? '',
                    color: color,
                  ),
                  _InfoRow(
                    icon: Iconsax.sms,
                    label: Tr.email.tr,
                    value: cabinet?.email ?? '',
                    color: color,
                  ),
                  const SizedBox(height: 24),

                  // Spécialités du cabinet
                  Text(Tr.specialties.tr, style: AppTextStyles.heading3),
                  const SizedBox(height: 12),
                  Obx(() {
                        if (controller.isLoadingSpecialites.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Column(
                        children: controller.specialitesDuCabinet.map((spec) {
                          return CustomCard(
                            margin: const EdgeInsets.only(bottom: 8),
                            onTap: () => Get.toNamed(AppRoutes.medecins,
                                arguments: {
                                  'specialiteId': spec.id,
                                  'cabinetId': cabinet?.id,
                                }),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Icon(Iconsax.health,
                                      color: accentColor, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(spec.nom ?? '',
                                          style: AppTextStyles.bodyBold),
                                      Text(
                                        spec.description ?? '',
                                        style: AppTextStyles.caption,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 16, color: color),
                              ],
                            ),
                          );
                        }).toList(),
                        );
                      }),

                  const SizedBox(height: 20),

                  // Bouton voir médecins
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.medecins,
                          arguments: {'cabinetId': cabinet?.id}),
                      icon: const Icon(Iconsax.user_search),
                      label: Text(Tr.seeDoctors.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(value, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
