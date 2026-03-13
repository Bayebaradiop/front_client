import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/user_avatar.dart';
import '../controllers/rendezvous_controller.dart';
import '../../../translate/translation_keys.dart';

class RdvDetailView extends StatelessWidget {
  const RdvDetailView({super.key});

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

    // Set selectedRdv from navigation arguments, then refresh from API
    // so the timeline always reflects the latest status from the database.
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('rdv')) {
      final rdvArg = args['rdv'] as Map<String, dynamic>;
      controller.selectedRdv.value = rdvArg;
      controller.loadRdvDetail(rdvArg['id'] as int);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final rdv = controller.selectedRdv.value;
        if (rdv == null) {
          return Center(child: Text(Tr.appointmentNotFound.tr));
        }

        final statut = (rdv['statut'] as String?) ?? 'EN_ATTENTE';
        final color = _statusColor(statut);
        final rawDebut = (rdv['heureDebut'] as String?) ?? '';
        final rawFin = (rdv['heureFin'] as String?) ?? '';
        final heureDebut = rawDebut.length >= 5 ? rawDebut.substring(0, 5) : rawDebut;
        final heureFin = rawFin.length >= 5 ? rawFin.substring(0, 5) : rawFin;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: color,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.9),
                        color,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Icon(_statusIcon(statut),
                            size: 48, color: Colors.white),
                        const SizedBox(height: 10),
                        Text(
                          _statusLabel(statut),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                    // Timeline visuelle
                    _StatusTimeline(statut: statut),
                    const SizedBox(height: 24),

                    // Info médecin
                    Text(Tr.doctor.tr, style: AppTextStyles.heading3),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          UserAvatar(
                            photoUrl: rdv['medecinPhoto'] as String?,
                            initials: '${((rdv['medecinPrenom'] as String?) ?? '').isNotEmpty ? (rdv['medecinPrenom'] as String)[0] : ''}'
                                '${((rdv['medecinNom'] as String?) ?? '').isNotEmpty ? (rdv['medecinNom'] as String)[0] : ''}',
                            radius: 26,
                            fontSize: 16,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. ${rdv['medecinPrenom']} ${rdv['medecinNom']}',
                                  style: AppTextStyles.bodyBold,
                                ),
                                Text(
                                  rdv['medecinSpecialite'] ?? '',
                                  style: AppTextStyles.caption
                                      .copyWith(
                                          color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info date/heure
                    Text(Tr.dateAndTime.tr, style: AppTextStyles.heading3),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            icon: Iconsax.calendar_1,
                            label: Tr.date.tr,
                            value: rdv['date'] ?? '',
                          ),
                          const Divider(height: 20),
                          _DetailRow(
                            icon: Iconsax.clock,
                            label: Tr.time.tr,
                            value: '$heureDebut - $heureFin',
                          ),
                          const Divider(height: 20),
                          _DetailRow(
                            icon: Iconsax.document_text,
                            label: Tr.reason.tr,
                            value: rdv['motif'] ?? Tr.notSpecified.tr,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info cabinet
                    Text(Tr.cabinet.tr, style: AppTextStyles.heading3),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            icon: Iconsax.hospital,
                            label: Tr.name.tr,
                            value: rdv['cabinetNom'] ?? '',
                          ),
                          const Divider(height: 20),
                          _DetailRow(
                            icon: Iconsax.location,
                            label: Tr.address.tr,
                            value: rdv['cabinetAdresse'] ?? '',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Bouton annuler
                    if (controller.canCancel(statut))
                      CustomButton(
                        text: Tr.cancelAppointment.tr,
                        backgroundColor: AppColors.error,
                        icon: Iconsax.close_circle,
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.error
                                          .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        Iconsax.warning_2,
                                        color: AppColors.error,
                                        size: 22),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(Tr.confirm.tr),
                                ],
                              ),
                              content: Text(
                                Tr.cancelConfirm.tr,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child:
                                      Text(Tr.no.tr),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controller
                                        .annulerRdv(rdv['id']);
                                    Get.back();
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.error,
                                  ),
                                  child: Text(
                                      Tr.yesCancel.tr),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── DETAIL ROW ────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: Text(label, style: AppTextStyles.caption),
        ),
        Expanded(
          child: Text(value, style: AppTextStyles.body),
        ),
      ],
    );
  }
}

// ─── STATUS TIMELINE ───────────────────────────────────────────
class _StatusTimeline extends StatelessWidget {
  final String statut;
  const _StatusTimeline({required this.statut});

  @override
  Widget build(BuildContext context) {
    final steps = ['EN_ATTENTE', 'CONFIRME', 'TERMINE'];
    final isAnnule = statut == 'ANNULE';
    final currentIndex = steps.indexOf(statut);

    final labels = {
      'EN_ATTENTE': Tr.statusPending.tr,
      'CONFIRME': Tr.statusConfirmed.tr,
      'TERMINE': Tr.statusCompleted.tr,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isAnnule
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.close_circle,
                      color: AppColors.error, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  Tr.appointmentCancelledText.tr,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Row(
              children: List.generate(steps.length, (i) {
                final isActive = i <= currentIndex;
                final isLast = i == steps.length - 1;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.divider,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isActive
                                    ? Iconsax.tick_circle5
                                    : Iconsax.clock,
                                color: isActive
                                    ? Colors.white
                                    : AppColors.textLight,
                                size: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              labels[steps[i]] ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.textLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 16),
                            color: i < currentIndex
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}
