import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/utils/calendar_utils.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/medecin_model.dart';
import '../../../models/specialite_model.dart';
import '../../../models/rendezvous_model.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../theme/app_colors.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/cabinet_logo.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../rendezvous/views/mes_rdv_view.dart';
import '../../../translate/translation_keys.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: DSColors.background,
      body: Obx(
        () => Stack(
          children: [
            IndexedStack(
              index: controller.currentIndex.value,
              children: [
                _HomeContent(controller: controller),
                const MesRdvView(embedded: true),
                _SearchContent(controller: controller),
                _ProfileContent(controller: controller),
              ],
            ),

            // Floating Navigation Bar (Doctolib style)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _CustomFloatingNavBar(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FLOATING NAVIGATION BAR ───────────────────────────────────
class _CustomFloatingNavBar extends StatelessWidget {
  final HomeController controller;
  const _CustomFloatingNavBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: DSColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Iconsax.home_2,
              activeIcon: Iconsax.home_25,
              label: Tr.home.tr,
              isSelected: controller.currentIndex.value == 0,
              onTap: () => controller.changeTab(0),
            ),
            _NavBarItem(
              icon: Iconsax.calendar_1,
              activeIcon: Iconsax.calendar,
              label: Tr.appointments.tr,
              isSelected: controller.currentIndex.value == 1,
              onTap: () => controller.changeTab(1),
            ),
            _NavBarItem(
              icon: Iconsax.search_normal_1,
              activeIcon: Iconsax.search_normal,
              label: Tr.search.tr,
              isSelected: controller.currentIndex.value == 2,
              onTap: () => controller.changeTab(2),
            ),
            _NavBarItem(
              icon: Iconsax.profile_circle,
              activeIcon: Iconsax.profile_circle5,
              label: Tr.profile.tr,
              isSelected: controller.currentIndex.value == 3,
              onTap: () => controller.changeTab(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? DSColors.primaryUltraLight
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? DSColors.primary : DSColors.textSecondary,
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: DSTypography.labelSmall.copyWith(
                  color: DSColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── HOME CONTENT ──────────────────────────────────────────────
class _HomeContent extends StatelessWidget {
  final HomeController controller;
  const _HomeContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: DSColors.primary,
        onRefresh: () => controller.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Médical Exécutif
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _HomeHero(controller: controller),
              ),

              const SizedBox(height: 20),

              // Rendez-vous à venir (Prochain RDV)
              Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProchainRdvSkeleton(),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                }
                final rdv = controller.prochainRdv.value;
                if (rdv == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(title: Tr.nextAppointment.tr),
                      const SizedBox(height: 10),
                      _ProchainRdvCard(rdv: rdv),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }),

              // Spécialités Médicales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionHeader(
                  title: Tr.specialties.tr,
                  actionLabel: Tr.seeAll.tr,
                  onAction: () => Get.toNamed(AppRoutes.specialites),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => controller.isLoading.value
                    ? const FilterPillsSkeleton(itemCount: 5)
                    : _SpecialitesHorizontalList(specialites: controller.specialites),
              ),

              const SizedBox(height: 20),

              // Médecins Recommandés / Disponibles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionHeader(
                  title: Tr.doctors.tr,
                  actionLabel: Tr.seeAll.tr,
                  onAction: () => Get.toNamed(AppRoutes.medecins),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => controller.isLoading.value
                    ? SizedBox(
                        height: 210,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          itemCount: 3,
                          itemBuilder: (_, __) =>
                              const ShimmerCard(width: 170, height: 200),
                        ),
                      )
                    : SizedBox(
                        height: 210,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          itemCount: controller.medecins.length > 6
                              ? 6
                              : controller.medecins.length,
                          itemBuilder: (_, i) => _MedecinHorizontalCard(
                            medecin: controller.medecins[i],
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // Cabinets Médicaux
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionHeader(
                  title: Tr.medicalCabinets.tr,
                  actionLabel: Tr.seeAll.tr,
                  onAction: () => Get.toNamed(AppRoutes.cabinets),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => controller.isLoading.value
                    ? SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          itemCount: 3,
                          itemBuilder: (_, __) =>
                              const ShimmerCard(width: 240, height: 160),
                        ),
                      )
                    : SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          itemCount: controller.cabinets.length,
                          itemBuilder: (_, i) => _CabinetHorizontalCard(
                            cabinet: controller.cabinets[i],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── HERO BANNER ───────────────────────────────────────────────
class _HomeHero extends StatelessWidget {
  final HomeController controller;
  const _HomeHero({required this.controller});

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser.value;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DSColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: DSColors.primaryDark.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête profil & notifications
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                ),
                child: UserAvatar(
                  photoUrl: user?.photo,
                  initials:
                      '${(user?.prenom ?? '').isNotEmpty ? user!.prenom![0] : ''}'
                      '${(user?.nom ?? '').isNotEmpty ? user!.nom![0] : ''}',
                  radius: 20,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  textColor: DSColors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(DateTime.now().hour >= 5 && DateTime.now().hour < 18) ? 'Bonjour' : 'Bonsoir'}, ${user?.prenom ?? ''}',
                      style: DSTypography.headingSmall.copyWith(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Trouvez votre médecin et réservez',
                      style: DSTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: const Icon(
                    Iconsax.notification,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barre de recherche interactive
          GestureDetector(
            onTap: () => controller.changeTab(2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.search_normal_1,
                    color: DSColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      Tr.searchDoctorSpecialty.tr,
                      style: DSTypography.bodyMedium.copyWith(
                        color: DSColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: DSColors.primaryUltraLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Rechercher',
                      style: DSTypography.labelSmall.copyWith(
                        color: DSColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: DSTypography.headingSmall.copyWith(
            color: DSColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: DSTypography.labelMedium.copyWith(
                color: DSColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── PROCHAIN RDV CARD (DYNAMIC ISLAND STYLE WITH LIVE COUNTDOWN) ──────
class _ProchainRdvCard extends StatefulWidget {
  final RendezVousModel rdv;
  const _ProchainRdvCard({required this.rdv});

  @override
  State<_ProchainRdvCard> createState() => _ProchainRdvCardState();
}

class _ProchainRdvCardState extends State<_ProchainRdvCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _calculateCountdown() {
    final dateStr = widget.rdv.date;
    final timeStr = widget.rdv.heureDebut;
    if (dateStr == null || timeStr == null) return 'Prochainement';

    try {
      final formattedTime = timeStr.length >= 5 ? timeStr.substring(0, 5) : timeStr;
      DateTime? rdvDate;
      if (dateStr.contains('-')) {
        rdvDate = DateTime.parse('${dateStr}T$formattedTime:00');
      } else if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          rdvDate = DateTime.parse('${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}T$formattedTime:00');
        }
      }

      if (rdvDate != null) {
        final now = DateTime.now();
        final diff = rdvDate.difference(now);

        if (diff.isNegative) {
          if (diff.inHours.abs() < 2) return 'En cours';
          return 'Aujourd\'hui';
        }

        if (diff.inMinutes < 60) {
          return 'Dans ${diff.inMinutes} min';
        } else if (diff.inHours < 24) {
          final hours = diff.inHours;
          final mins = diff.inMinutes % 60;
          return mins > 0 ? 'Dans ${hours}h${mins.toString().padLeft(2, '0')}' : 'Dans ${hours}h';
        } else if (diff.inDays == 1) {
          return 'Demain à $formattedTime';
        } else {
          return 'Dans ${diff.inDays} jours';
        }
      }
    } catch (_) {}

    return 'Prochain RDV';
  }

  @override
  Widget build(BuildContext context) {
    final rdv = widget.rdv;
    final doctorName = 'Dr. ${rdv.medecinPrenom ?? ''} ${rdv.medecinNom ?? ''}'.trim();
    final timeRange =
        '${(rdv.heureDebut ?? '').length >= 5 ? rdv.heureDebut!.substring(0, 5) : ''} - ${(rdv.heureFin ?? '').length >= 5 ? rdv.heureFin!.substring(0, 5) : ''}';
    final countdown = _calculateCountdown();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Island Pill Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        countdown.toUpperCase(),
                        style: DSTypography.labelSmall.copyWith(
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormatter.formatFullFrenchDate(rdv.date),
                  style: DSTypography.bodySmall.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Doctor Details Row
            Row(
              children: [
                UserAvatar(
                  photoUrl: rdv.medecinPhoto,
                  initials:
                      '${(rdv.medecinPrenom ?? '').isNotEmpty ? rdv.medecinPrenom![0] : ''}'
                      '${(rdv.medecinNom ?? '').isNotEmpty ? rdv.medecinNom![0] : ''}',
                  radius: 24,
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  textColor: Colors.white,
                  fontSize: 16,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: DSTypography.headingSmall.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rdv.medecinSpecialite ?? '',
                        style: DSTypography.bodySmall.copyWith(
                          color: DSColors.primaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Heure & Adresse Row
            Row(
              children: [
                const Icon(Iconsax.clock, size: 14, color: Colors.white70),
                const SizedBox(width: 6),
                Text(
                  timeRange,
                  style: DSTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (rdv.cabinetNom != null) ...[
                  const SizedBox(width: 12),
                  const Icon(Iconsax.hospital, size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      rdv.cabinetNom!,
                      style: DSTypography.bodySmall.copyWith(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Get.toNamed(AppRoutes.rdvDetail, arguments: {'rdv': rdv.toJson()});
                    },
                    icon: const Icon(Iconsax.ticket, size: 15, color: Colors.white),
                    label: Text(
                      'Voir Billet',
                      style: DSTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DSColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      CalendarUtils().exportAppointmentToCalendar(
                        doctorName: doctorName,
                        specialty: rdv.medecinSpecialite ?? '',
                        date: rdv.date ?? '',
                        timeRange: timeRange,
                        cabinetAddress: rdv.cabinetAdresse,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Iconsax.calendar_add, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── CABINET HORIZONTAL CARD ───────────────────────────────────
class _CabinetHorizontalCard extends StatelessWidget {
  final CabinetModel cabinet;
  const _CabinetHorizontalCard({required this.cabinet});

  @override
  Widget build(BuildContext context) {
    final accentColor = DSColors.fromHex(cabinet.couleurPrimaire ?? '#0F766E');
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.cabinetDetail, arguments: cabinet),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: DSColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: DSColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CabinetLogo(
                  logoUrl: cabinet.logo,
                  size: 34,
                  borderRadius: 10,
                  accentColor: accentColor,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: DSColors.primaryUltraLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    Tr.cabinet.tr,
                    style: DSTypography.labelSmall.copyWith(
                      color: DSColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              cabinet.nom ?? '',
              style: DSTypography.headingSmall.copyWith(
                color: DSColors.textPrimary,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Iconsax.location, size: 13, color: DSColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    cabinet.adresse ?? '',
                    style: DSTypography.bodySmall.copyWith(
                      color: DSColors.textSecondary,
                      fontSize: 12,
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
    );
  }
}

// ─── MEDECIN HORIZONTAL CARD (FIXED CTA "Prendre RDV") ─────────
class _MedecinHorizontalCard extends StatelessWidget {
  final MedecinModel medecin;
  const _MedecinHorizontalCard({required this.medecin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.medecinDetail,
        arguments: {
          'medecin': {
            'id': medecin.id,
            'prenom': medecin.prenom,
            'nom': medecin.nom,
            'photo': medecin.photo,
            'specialiteNom': medecin.specialiteNom,
            'specialiteId': medecin.specialiteId,
            'cabinetNom': medecin.cabinetNom,
            'cabinetId': medecin.cabinetId,
          },
        },
      ),
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: DSColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: DSColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Avatar avec indicateur disponible (point vert)
            Stack(
              children: [
                UserAvatar(
                  photoUrl: medecin.photo,
                  initials:
                      '${(medecin.prenom ?? '').isNotEmpty ? medecin.prenom![0] : ''}'
                      '${(medecin.nom ?? '').isNotEmpty ? medecin.nom![0] : ''}',
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
            const SizedBox(height: 8),
            Text(
              'Dr. ${medecin.prenom ?? ''} ${medecin.nom ?? ''}',
              style: DSTypography.labelLarge.copyWith(
                color: DSColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              medecin.specialiteNom ?? '',
              style: DSTypography.labelSmall.copyWith(
                color: DSColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Bouton d'action médical explicite "Prendre RDV"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: DSColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Prendre RDV',
                style: DSTypography.labelSmall.copyWith(
                  color: DSColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SPECIALITES HORIZONTAL LIST ───────────────────────────────
class _SpecialitesHorizontalList extends StatelessWidget {
  final List<SpecialiteModel> specialites;
  const _SpecialitesHorizontalList({required this.specialites});

  IconData _getIcon(int index) {
    final icons = [
      Iconsax.health,
      Iconsax.heart5,
      Iconsax.flash_1,
      Iconsax.lovely,
      Iconsax.eye,
      Iconsax.shield_tick,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: specialites.length,
        itemBuilder: (_, i) {
          final spec = specialites[i];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.medecins,
                arguments: {'specialiteId': spec.id},
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: DSColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: DSColors.primaryUltraLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIcon(i),
                        color: DSColors.primary,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      spec.nom ?? '',
                      style: DSTypography.labelSmall.copyWith(
                        color: DSColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── SEARCH CONTENT ────────────────────────────────────────────
class _SearchContent extends StatelessWidget {
  final HomeController controller;
  const _SearchContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              Tr.search.tr,
              style: DSTypography.headingMedium.copyWith(
                color: DSColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) => controller.searchQuery.value = v,
              style: DSTypography.bodyLarge.copyWith(color: DSColors.textPrimary),
              decoration: InputDecoration(
                hintText: Tr.searchDoctorCabinet.tr,
                prefixIcon: const Icon(
                  Iconsax.search_normal_1,
                  color: DSColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => Wrap(
                spacing: 8,
                children: [
                  _FilterChip(
                    label: Tr.allFilter.tr,
                    selected: controller.searchFilter.value == 'all',
                    onTap: () => controller.searchFilter.value = 'all',
                  ),
                  _FilterChip(
                    label: Tr.doctors.tr,
                    selected: controller.searchFilter.value == 'doctors',
                    onTap: () => controller.searchFilter.value = 'doctors',
                  ),
                  _FilterChip(
                    label: Tr.cabinets.tr,
                    selected: controller.searchFilter.value == 'cabinets',
                    onTap: () => controller.searchFilter.value = 'cabinets',
                  ),
                  _FilterChip(
                    label: Tr.specialties.tr,
                    selected: controller.searchFilter.value == 'specialties',
                    onTap: () => controller.searchFilter.value = 'specialties',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Results
          Expanded(
            child: Obx(() {
              if (controller.searchQuery.value.isEmpty) {
                return _SearchQuickAccess(controller: controller);
              }
              if (!controller.hasSearchResults) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.search_normal_1,
                        size: 48,
                        color: DSColors.textLight.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(Tr.noResults.tr, style: DSTypography.bodyMedium),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((controller.searchFilter.value == 'all' ||
                            controller.searchFilter.value == 'doctors') &&
                        controller.filteredMedecins.isNotEmpty) ...[
                      Text(Tr.doctors.tr, style: DSTypography.headingSmall),
                      const SizedBox(height: 8),
                      ...controller.filteredMedecins
                          .take(5)
                          .map((m) => _SearchMedecinTile(medecin: m)),
                      const SizedBox(height: 16),
                    ],
                    if ((controller.searchFilter.value == 'all' ||
                            controller.searchFilter.value == 'cabinets') &&
                        controller.filteredCabinets.isNotEmpty) ...[
                      Text(Tr.cabinets.tr, style: DSTypography.headingSmall),
                      const SizedBox(height: 8),
                      ...controller.filteredCabinets
                          .take(5)
                          .map((c) => _SearchCabinetTile(cabinet: c)),
                      const SizedBox(height: 16),
                    ],
                    if ((controller.searchFilter.value == 'all' ||
                            controller.searchFilter.value == 'specialties') &&
                        controller.filteredSpecialites.isNotEmpty) ...[
                      Text(Tr.specialties.tr, style: DSTypography.headingSmall),
                      const SizedBox(height: 8),
                      ...controller.filteredSpecialites
                          .take(5)
                          .map((s) => _SearchSpecialiteTile(specialite: s)),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? DSColors.primary : DSColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? DSColors.primary : DSColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: DSTypography.labelSmall.copyWith(
            color: selected ? DSColors.white : DSColors.textPrimary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SearchQuickAccess extends StatelessWidget {
  final HomeController controller;
  const _SearchQuickAccess({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Tr.quickAccess.tr, style: DSTypography.headingSmall),
          const SizedBox(height: 12),
          _QuickAccessTile(
            icon: Iconsax.hospital,
            title: Tr.medicalCabinets.tr,
            subtitle: Tr.findNearby.tr,
            onTap: () => Get.toNamed(AppRoutes.cabinets),
          ),
          _QuickAccessTile(
            icon: Iconsax.menu_board,
            title: Tr.specialties.tr,
            subtitle: Tr.browseBySpecialty.tr,
            onTap: () => Get.toNamed(AppRoutes.specialites),
          ),
          _QuickAccessTile(
            icon: Iconsax.user_search,
            title: Tr.doctors.tr,
            subtitle: Tr.allAvailableDoctors.tr,
            onTap: () => Get.toNamed(AppRoutes.medecins),
          ),
        ],
      ),
    );
  }
}

class _SearchMedecinTile extends StatelessWidget {
  final MedecinModel medecin;
  const _SearchMedecinTile({required this.medecin});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => Get.toNamed(
        AppRoutes.medecinDetail,
        arguments: {
          'medecin': {
            'id': medecin.id,
            'prenom': medecin.prenom,
            'nom': medecin.nom,
            'photo': medecin.photo,
            'specialiteNom': medecin.specialiteNom,
            'specialiteId': medecin.specialiteId,
            'cabinetNom': medecin.cabinetNom,
            'cabinetId': medecin.cabinetId,
          },
        },
      ),
      child: Row(
        children: [
          UserAvatar(
            photoUrl: medecin.photo,
            initials:
                '${(medecin.prenom ?? '').isNotEmpty ? medecin.prenom![0] : ''}'
                '${(medecin.nom ?? '').isNotEmpty ? medecin.nom![0] : ''}',
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${medecin.prenom ?? ''} ${medecin.nom ?? ''}',
                  style: DSTypography.labelLarge,
                ),
                Text(
                  medecin.specialiteNom ?? '',
                  style: DSTypography.bodySmall.copyWith(
                    color: DSColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: DSColors.primary,
              borderRadius: BorderRadius.circular(10),
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
    );
  }
}

class _SearchCabinetTile extends StatelessWidget {
  final CabinetModel cabinet;
  const _SearchCabinetTile({required this.cabinet});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => Get.toNamed(AppRoutes.cabinetDetail, arguments: cabinet),
      child: Row(
        children: [
          CabinetLogo(
            logoUrl: cabinet.logo,
            size: 40,
            borderRadius: 10,
            accentColor: DSColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cabinet.nom ?? '', style: DSTypography.labelLarge),
                Text(cabinet.adresse ?? '', style: DSTypography.bodySmall),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: DSColors.textLight,
          ),
        ],
      ),
    );
  }
}

class _SearchSpecialiteTile extends StatelessWidget {
  final SpecialiteModel specialite;
  const _SearchSpecialiteTile({required this.specialite});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () => Get.toNamed(
        AppRoutes.medecins,
        arguments: {'specialiteId': specialite.id},
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DSColors.primaryUltraLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Iconsax.health,
              color: DSColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(specialite.nom ?? '', style: DSTypography.labelLarge),
          ),
          Text(
            'Voir les médecins',
            style: DSTypography.labelSmall.copyWith(color: DSColors.primary),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: DSColors.primary,
          ),
        ],
      ),
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _QuickAccessTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DSColors.primaryUltraLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: DSColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: DSTypography.labelLarge),
                Text(subtitle, style: DSTypography.bodySmall),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: DSColors.textLight,
          ),
        ],
      ),
    );
  }
}

// ─── PROFILE CONTENT ───────────────────────────────────────────
class _ProfileContent extends StatelessWidget {
  final HomeController controller;
  const _ProfileContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser.value;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: DSColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: DSColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () => Get.find<AuthController>().pickAndUploadPhoto(),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: DSColors.primary, width: 2),
                            ),
                            child: UserAvatar(
                              photoUrl: controller.currentUser.value?.photo,
                              initials:
                                  '${(controller.currentUser.value?.prenom ?? '').isNotEmpty ? controller.currentUser.value!.prenom![0] : ''}'
                                  '${(controller.currentUser.value?.nom ?? '').isNotEmpty ? controller.currentUser.value!.nom![0] : ''}',
                              radius: 38,
                              backgroundColor: DSColors.primaryUltraLight,
                              textColor: DSColors.primary,
                              fontSize: 24,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: DSColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.camera,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Text(
                      '${controller.currentUser.value?.prenom ?? ''} ${controller.currentUser.value?.nom ?? ''}',
                      style: DSTypography.headingMedium.copyWith(
                        color: DSColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.email ?? '',
                    style: DSTypography.bodyMedium.copyWith(
                      color: DSColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _ProfileMenuItem(
              icon: Iconsax.user_edit,
              title: Tr.myProfile.tr,
              onTap: () => Get.toNamed(AppRoutes.profile),
            ),
            _ProfileMenuItem(
              icon: Iconsax.calendar_1,
              title: Tr.myAppointments.tr,
              onTap: () => controller.changeTab(1),
            ),

            const SizedBox(height: 12),

            _ProfileMenuItem(
              icon: Iconsax.logout,
              title: Tr.logout.tr,
              color: AppColors.error,
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(Tr.disconnect.tr, style: DSTypography.headingSmall),
                    content: Text(Tr.disconnectConfirm.tr, style: DSTypography.bodyMedium),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(Tr.cancel.tr),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          final authCtrl = Get.find<AuthController>();
                          authCtrl.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: Text(Tr.disconnect.tr),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? DSColors.primary;
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: itemColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: itemColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: DSTypography.labelLarge.copyWith(
                color: color ?? DSColors.textPrimary,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: color ?? DSColors.textLight,
          ),
        ],
      ),
    );
  }
}
