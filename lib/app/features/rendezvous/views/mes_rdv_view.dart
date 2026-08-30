import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/calendar_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../translate/translation_keys.dart';
import '../controllers/rendezvous_controller.dart';

class MesRdvView extends StatelessWidget {
  final bool embedded;
  const MesRdvView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RendezvousController>();

    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: embedded
          ? null
          : AppBar(
              title: Text(
                Tr.myAppointments.tr,
                style: DSTypography.headingSmall.copyWith(
                  color: DSColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              backgroundColor: DSColors.background,
              elevation: 0,
              centerTitle: true,
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _RdvHero(controller: controller),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => _RdvFilterBar(
                selectedIndex: controller.selectedTabIndex.value,
                onChanged: (index) => controller.selectedTabIndex.value = index,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ShimmerLoading(itemCount: 4, height: 168),
                );
              }

              final list = _currentList(controller);
              if (list.isEmpty) {
                return EmptyState(
                  icon: Iconsax.calendar_1,
                  title: Tr.noAppointments.tr,
                  subtitle: 'Planifiez votre premier rendez-vous avec un praticien.',
                );
              }

              return RefreshIndicator(
                color: DSColors.primary,
                onRefresh: () async => controller.refresh(),
                child: AnimationLimiter(
                  child: ListView.builder(
                    // Marge inférieure généreuse (140px) pour éviter le chevauchement avec la barre de navigation
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final rdv = list[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 350),
                        child: SlideAnimation(
                          verticalOffset: 24,
                          child: FadeInAnimation(
                            child: _RdvCard(rdv: rdv, controller: controller),
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

  List<Map<String, dynamic>> _currentList(RendezvousController controller) {
    switch (controller.selectedTabIndex.value) {
      case 0:
        return controller.rdvConfirmes;
      case 1:
        return controller.rdvHistorique;
      case 2:
      default:
        return controller.tousLesRdv;
    }
  }
}

// ─── HERO CARTE D'ENTÊTE ─────────────────────────────────────
class _RdvHero extends StatelessWidget {
  final RendezvousController controller;
  const _RdvHero({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DSColors.primaryDark,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.calendar_tick, color: Color(0xFF10B981), size: 22),
              const SizedBox(width: 8),
              Text(
                'ESPACE RENDEZ-VOUS',
                style: DSTypography.labelSmall.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Gestion Simplifiée des Consultations',
            style: DSTypography.headingSmall.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => Row(
              children: [
                _HeroPill(
                  value: '${controller.tousLesRdv.length}',
                  label: 'Total',
                  color: const Color(0xFF38BDF8),
                ),
                const SizedBox(width: 8),
                _HeroPill(
                  value: '${controller.rdvConfirmes.length}',
                  label: 'Confirmés',
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                _HeroPill(
                  value: '${controller.rdvHistorique.length}',
                  label: 'Historique',
                  color: const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _HeroPill({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: DSTypography.headingSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: DSTypography.labelSmall.copyWith(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── BARRE DE FILTRES SEGMENTÉE ──────────────────────────────
class _RdvFilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _RdvFilterBar({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [Tr.confirmed.tr, Tr.history.tr, Tr.all.tr];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DSColors.borderLight),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? DSColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  items[index],
                  textAlign: TextAlign.center,
                  style: DSTypography.labelSmall.copyWith(
                    color: isSelected ? Colors.white : DSColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── CARTE DE RENDEZ-VOUS (ROBUSTE & DEFENSIVE) ──────────────
class _RdvCard extends StatelessWidget {
  final Map<String, dynamic> rdv;
  final RendezvousController controller;
  const _RdvCard({required this.rdv, required this.controller});

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

  @override
  Widget build(BuildContext context) {
    final String statut = rdv['statut']?.toString() ?? 'EN_ATTENTE';
    final Color color = _statusColor(statut);
    
    final String rawDebut = rdv['heureDebut']?.toString() ?? '';
    final String rawFin = rdv['heureFin']?.toString() ?? '';
    final String heureDebut = rawDebut.length >= 5 ? rawDebut.substring(0, 5) : rawDebut;
    final String heureFin = rawFin.length >= 5 ? rawFin.substring(0, 5) : rawFin;

    final String doctorPrenom = rdv['medecinPrenom']?.toString() ?? '';
    final String doctorNom = rdv['medecinNom']?.toString() ?? '';
    final String doctorSpecialite = rdv['medecinSpecialite']?.toString() ?? '';
    final String cabinetNom = rdv['cabinetNom']?.toString() ?? '';
    final String cabinetAdresse = rdv['cabinetAdresse']?.toString() ?? '';
    final String dateStr = rdv['date']?.toString() ?? '';
    final String photoUrl = rdv['medecinPhoto']?.toString() ?? '';
    
    final String doctorName = 'Dr. $doctorPrenom $doctorNom'.trim();

    String initials = '';
    if (doctorPrenom.isNotEmpty) initials += doctorPrenom[0].toUpperCase();
    if (doctorNom.isNotEmpty) initials += doctorNom[0].toUpperCase();
    if (initials.isEmpty) initials = 'DR';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DSColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            Get.toNamed(AppRoutes.rdvDetail, arguments: {'rdv': rdv});
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête Médecin + Statut Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAvatar(
                      photoUrl: photoUrl.isNotEmpty ? photoUrl : null,
                      initials: initials,
                      radius: 24,
                      backgroundColor: DSColors.primaryUltraLight,
                      textColor: DSColors.primary,
                      fontSize: 14,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName.isEmpty ? 'Praticien MediBook' : doctorName,
                            style: DSTypography.headingSmall.copyWith(
                              color: DSColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            doctorSpecialite,
                            style: DSTypography.bodySmall.copyWith(
                              color: DSColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          if (cabinetNom.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              cabinetNom,
                              style: DSTypography.bodySmall.copyWith(
                                color: DSColors.textSecondary,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Statut Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        _statusLabel(statut).toUpperCase(),
                        style: DSTypography.labelSmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Informations de Date & Heure (Box Immersive)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: DSColors.primaryUltraLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: DSColors.primaryLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _MetaItem(
                              icon: Iconsax.calendar_1,
                              label: 'Date',
                              value: DateFormatter.formatFullFrenchDate(dateStr),
                            ),
                          ),
                          Container(
                            height: 28,
                            width: 1,
                            color: DSColors.borderLight,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetaItem(
                              icon: Iconsax.clock,
                              label: 'Heure',
                              value: '$heureDebut - $heureFin',
                            ),
                          ),
                        ],
                      ),
                      if (cabinetAdresse.isNotEmpty) ...[
                        const Divider(height: 16),
                        _MetaItem(
                          icon: Iconsax.location,
                          label: 'Adresse',
                          value: cabinetAdresse,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Barre d'Actions Intégrée (Billet, Agenda, Annuler)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Get.toNamed(AppRoutes.rdvDetail, arguments: {'rdv': rdv});
                        },
                        icon: const Icon(Iconsax.ticket, size: 14, color: Colors.white),
                        label: Text(
                          'Voir Billet',
                          style: DSTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DSColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          CalendarUtils().exportAppointmentToCalendar(
                            doctorName: doctorName,
                            specialty: doctorSpecialite,
                            date: dateStr,
                            timeRange: '$heureDebut - $heureFin',
                            cabinetAddress: cabinetAdresse,
                          );
                        },
                        icon: const Icon(
                          Iconsax.calendar_add,
                          size: 14,
                          color: DSColors.primary,
                        ),
                        label: Text(
                          'Agenda',
                          style: DSTypography.labelSmall.copyWith(
                            color: DSColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: DSColors.primary,
                          side: const BorderSide(color: DSColors.primaryLight),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (controller.canCancel(statut)) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          _showCancelDialog(context);
                        },
                        icon: const Icon(Iconsax.close_circle, color: Color(0xFFEF4444), size: 22),
                        tooltip: 'Annuler Rendez-vous',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.warning_2, color: Color(0xFFEF4444), size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                Tr.cancelRdv.tr,
                style: DSTypography.labelLarge.copyWith(
                  color: DSColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          Tr.cancelIrreversible.tr,
          style: DSTypography.bodyMedium.copyWith(
            color: DSColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              Tr.noKeep.tr,
              style: DSTypography.labelMedium.copyWith(
                color: DSColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              final id = rdv['id'];
              if (id != null && id is int) {
                controller.annulerRdv(id);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              Tr.yesCancel.tr,
              style: DSTypography.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: DSColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: DSTypography.labelSmall.copyWith(
                  color: DSColors.textLight,
                  fontWeight: FontWeight.w800,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: DSTypography.bodySmall.copyWith(
                  color: DSColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
