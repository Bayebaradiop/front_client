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
import '../controllers/rendezvous_controller.dart';
import '../../../translate/translation_keys.dart';

class MesRdvView extends StatelessWidget {
  final bool embedded;
  const MesRdvView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RendezvousController());

    return Scaffold(
      appBar: embedded
          ? null
          : CustomAppBar(title: Tr.myAppointments.tr),
      body: Column(
        children: [
          if (embedded)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(Tr.myAppointments.tr,
                    style: AppTextStyles.heading2),
              ),
            ),
          // TabBar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: AppColors.divider.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Obx(() => Row(
                  children: [
                    _TabItem(
                      label: Tr.all.tr,
                      isSelected: controller.selectedTabIndex.value == 0,
                      onTap: () => controller.selectedTabIndex.value = 0,
                    ),
                    _TabItem(
                      label: Tr.pending.tr,
                      isSelected: controller.selectedTabIndex.value == 1,
                      onTap: () => controller.selectedTabIndex.value = 1,
                    ),
                    _TabItem(
                      label: Tr.confirmed.tr,
                      isSelected: controller.selectedTabIndex.value == 2,
                      onTap: () => controller.selectedTabIndex.value = 2,
                    ),
                    _TabItem(
                      label: Tr.history.tr,
                      isSelected: controller.selectedTabIndex.value == 3,
                      onTap: () => controller.selectedTabIndex.value = 3,
                    ),
                  ],
                )),
          ),

          // Liste
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const ShimmerLoading(itemCount: 4, height: 130);
              }

              List<Map<String, dynamic>> list;
              switch (controller.selectedTabIndex.value) {
                case 1:
                  list = controller.rdvEnAttente;
                  break;
                case 2:
                  list = controller.rdvConfirmes;
                  break;
                case 3:
                  list = controller.rdvHistorique;
                  break;
                default:
                  list = controller.tousLesRdv;
              }

              if (list.isEmpty) {
                return EmptyState(
                  icon: Iconsax.calendar_1,
                  title: Tr.noAppointments.tr,
                  subtitle: Tr.bookFirstAppointment.tr,
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => controller.simulateLoading(),
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final rdv = list[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _RdvCard(
                              rdv: rdv,
                              controller: controller,
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

// ─── TAB ITEM ──────────────────────────────────────────────────
class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── RDV CARD ──────────────────────────────────────────────────
class _RdvCard extends StatelessWidget {
  final Map<String, dynamic> rdv;
  final RendezvousController controller;
  const _RdvCard({required this.rdv, required this.controller});

  Color _statusColor(String statut) {
    switch (statut) {
      case 'EN_ATTENTE':
        return AppColors.statusEnAttente;
      case 'CONFIRME':
        return AppColors.statusConfirme;
      case 'TERMINE':
        return AppColors.statusTermine;
      case 'ANNULE':
        return AppColors.statusAnnule;
      default:
        return AppColors.textLight;
    }
  }

  String _statusLabel(String statut) {
    switch (statut) {
      case 'EN_ATTENTE':
        return Tr.statusPending.tr;
      case 'CONFIRME':
        return Tr.statusConfirmed.tr;
      case 'TERMINE':
        return Tr.statusCompleted.tr;
      case 'ANNULE':
        return Tr.statusCancelled.tr;
      default:
        return statut;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statut = rdv['statut'] as String;
    final color = _statusColor(statut);
    final heureDebut =
        (rdv['heureDebut'] as String).substring(0, 5);
    final heureFin =
        (rdv['heureFin'] as String).substring(0, 5);

    return CustomCard(
      borderLeftColor: color,
      onTap: () =>
          Get.toNamed(AppRoutes.rdvDetail, arguments: {'rdv': rdv}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Text(
                  '${(rdv['medecinPrenom'] as String)[0]}${(rdv['medecinNom'] as String)[0]}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${rdv['medecinPrenom']} ${rdv['medecinNom']}',
                      style: AppTextStyles.bodyBold,
                    ),
                    Text(
                      rdv['medecinSpecialite'] ?? '',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _statusLabel(statut),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.calendar_1,
                    size: 14, color: AppColors.textLight),
                const SizedBox(width: 6),
                Text(rdv['date'] ?? '',
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(width: 14),
                const Icon(Iconsax.clock,
                    size: 14, color: AppColors.textLight),
                const SizedBox(width: 6),
                Text('$heureDebut - $heureFin',
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w500)),
                const Spacer(),
                const Icon(Iconsax.hospital,
                    size: 14, color: AppColors.textLight),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    rdv['cabinetNom'] ?? '',
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (controller.canCancel(statut)) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showCancelDialog(context),
                icon: const Icon(Iconsax.close_circle,
                    size: 16, color: AppColors.error),
                label: Text(
                  Tr.cancel.tr,
                  style: const TextStyle(
                      color: AppColors.error, fontSize: 13),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.warning_2,
                  color: AppColors.error, size: 22),
            ),
            const SizedBox(width: 10),
            Text(Tr.cancelRdv.tr),
          ],
        ),
        content: Text(
          Tr.cancelIrreversible.tr,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(Tr.noKeep.tr),
          ),
          ElevatedButton(
            onPressed: () => controller.annulerRdv(rdv['id']),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(Tr.yesCancel.tr),
          ),
        ],
      ),
    );
  }
}
