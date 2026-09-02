import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/calendar_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../translate/translation_keys.dart';
import '../controllers/rendezvous_controller.dart';

class RdvDetailView extends StatelessWidget {
  const RdvDetailView({super.key});

  Color _statusColor(String statut) {
    switch (statut) {
      case 'EN_ATTENTE':
        return const Color(0xFFF59E0B);
      case 'CONFIRME':
        return const Color(0xFF10B981);
      case 'TERMINE':
        return DSColors.primary;
      case 'ANNULE':
        return const Color(0xFFEF4444);
      default:
        return DSColors.textLight;
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

  IconData _statusIcon(String statut) {
    switch (statut) {
      case 'EN_ATTENTE':
        return Iconsax.clock;
      case 'CONFIRME':
        return Iconsax.tick_circle;
      case 'TERMINE':
        return Iconsax.verify;
      case 'ANNULE':
        return Iconsax.close_circle;
      default:
        return Iconsax.info_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RendezvousController>();

    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('rdv')) {
      final rdvArg = args['rdv'] as Map<String, dynamic>;
      controller.selectedRdv.value = rdvArg;
      controller.loadRdvDetail(rdvArg['id'] as int);
    }

    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: AppBar(
        backgroundColor: DSColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: DSColors.textPrimary, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Détails du Rendez-vous',
          style: DSTypography.headingSmall.copyWith(
            color: DSColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const RdvDetailSkeleton();
        }
        final rdv = controller.selectedRdv.value;
        if (rdv == null) {
          return Center(
            child: Text(
              Tr.appointmentNotFound.tr,
              style: DSTypography.bodyMedium.copyWith(color: DSColors.textSecondary),
            ),
          );
        }

        final statut = (rdv['statut'] as String?) ?? 'EN_ATTENTE';
        final color = _statusColor(statut);
        final rawDebut = (rdv['heureDebut'] as String?) ?? '';
        final rawFin = (rdv['heureFin'] as String?) ?? '';
        final heureDebut = rawDebut.length >= 5 ? rawDebut.substring(0, 5) : rawDebut;
        final heureFin = rawFin.length >= 5 ? rawFin.substring(0, 5) : rawFin;
        final doctorName = 'Dr. ${rdv['medecinPrenom'] ?? ''} ${rdv['medecinNom'] ?? ''}'.trim();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Ticket Boarding Pass Container
              Container(
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: DSColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Status Badge Top Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      child: Row(
                        children: [
                          Icon(_statusIcon(statut), color: color, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            _statusLabel(statut).toUpperCase(),
                            style: DSTypography.labelMedium.copyWith(
                              color: color,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '#RDV-${rdv['id'] ?? ''}',
                            style: DSTypography.labelSmall.copyWith(
                              color: DSColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor Profile Row
                          Row(
                            children: [
                              UserAvatar(
                                photoUrl: rdv['medecinPhoto'] as String?,
                                initials:
                                    '${((rdv['medecinPrenom'] as String?) ?? '').isNotEmpty ? (rdv['medecinPrenom'] as String)[0] : ''}'
                                    '${((rdv['medecinNom'] as String?) ?? '').isNotEmpty ? (rdv['medecinNom'] as String)[0] : ''}',
                                radius: 28,
                                backgroundColor: DSColors.primaryUltraLight,
                                textColor: DSColors.primary,
                                fontSize: 18,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctorName,
                                      style: DSTypography.headingSmall.copyWith(
                                        color: DSColors.textPrimary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      rdv['medecinSpecialite'] ?? '',
                                      style: DSTypography.labelMedium.copyWith(
                                        color: DSColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const DashedDivider(),
                          const SizedBox(height: 20),

                          // Date & Time Block
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Tr.date.tr.toUpperCase(),
                                      style: DSTypography.labelSmall.copyWith(
                                        color: DSColors.textLight,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Iconsax.calendar_1, size: 16, color: DSColors.primary),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            DateFormatter.formatFullFrenchDate(rdv['date'] as String?),
                                            style: DSTypography.labelMedium.copyWith(
                                              color: DSColors.textPrimary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: 36, width: 1, color: DSColors.borderLight),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Tr.time.tr.toUpperCase(),
                                      style: DSTypography.labelSmall.copyWith(
                                        color: DSColors.textLight,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Iconsax.clock, size: 16, color: DSColors.primary),
                                        const SizedBox(width: 6),
                                        Text(
                                          '$heureDebut - $heureFin',
                                          style: DSTypography.labelLarge.copyWith(
                                            color: DSColors.textPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Reason for Visit
                          Text(
                            Tr.reason.tr.toUpperCase(),
                            style: DSTypography.labelSmall.copyWith(
                              color: DSColors.textLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: DSColors.primaryUltraLight.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              rdv['motif'] ?? Tr.notSpecified.tr,
                              style: DSTypography.bodySmall.copyWith(
                                color: DSColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          const DashedDivider(),
                          const SizedBox(height: 20),

                          // Cabinet Address Block
                          Text(
                            Tr.cabinet.tr.toUpperCase(),
                            style: DSTypography.labelSmall.copyWith(
                              color: DSColors.textLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: DSColors.primaryUltraLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Iconsax.hospital, color: DSColors.primary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rdv['cabinetNom'] ?? '',
                                      style: DSTypography.labelLarge.copyWith(
                                        color: DSColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      rdv['cabinetAdresse'] ?? '',
                                      style: DSTypography.bodySmall.copyWith(
                                        color: DSColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons Row
              if (statut == 'CONFIRME') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      CalendarUtils().exportAppointmentToCalendar(
                        doctorName: doctorName,
                        specialty: rdv['medecinSpecialite'] ?? '',
                        date: rdv['date'] ?? '',
                        timeRange: '$heureDebut - $heureFin',
                        cabinetAddress: rdv['cabinetAdresse'],
                      );
                    },
                    icon: const Icon(Iconsax.calendar_add, size: 18, color: Colors.white),
                    label: Text(
                      'Exporter vers mon agenda',
                      style: DSTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DSColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: DSColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              if (controller.canCancel(statut))
                CustomButton(
                  text: Tr.cancelAppointment.tr,
                  backgroundColor: const Color(0xFFEF4444),
                  icon: Iconsax.close_circle,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    _showCancelConfirmationDialog(context, controller, rdv['id']);
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  void _showCancelConfirmationDialog(
    BuildContext context,
    RendezvousController controller,
    dynamic rdvId,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: DSColors.surface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.warning_2, color: Color(0xFFEF4444), size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              Tr.confirm.tr,
              style: DSTypography.headingSmall.copyWith(color: DSColors.textPrimary),
            ),
          ],
        ),
        content: Text(
          Tr.cancelConfirm.tr,
          style: DSTypography.bodyMedium.copyWith(color: DSColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              Tr.no.tr,
              style: DSTypography.labelMedium.copyWith(color: DSColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.annulerRdv(rdvId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              Tr.yesCancel.tr,
              style: DSTypography.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? DSColors.borderLight : Colors.transparent,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
