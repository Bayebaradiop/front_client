import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/medecin_model.dart';
import '../../../models/specialite_model.dart';
import '../../../models/rendezvous_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/cabinet_logo.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../rendezvous/views/mes_rdv_view.dart';
import '../../../translate/translation_keys.dart';
import '../../../theme/theme_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            _HomeContent(controller: controller),
            const MesRdvView(embedded: true),
            _SearchContent(controller: controller),
            _ProfileContent(controller: controller),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Iconsax.home_2),
              activeIcon: const Icon(Iconsax.home_25),
              label: Tr.home.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Iconsax.calendar_1),
              activeIcon: const Icon(Iconsax.calendar),
              label: Tr.appointments.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Iconsax.search_normal_1),
              activeIcon: const Icon(Iconsax.search_normal),
              label: Tr.search.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Iconsax.profile_circle),
              activeIcon: const Icon(Iconsax.profile_circle5),
              label: Tr.profile.tr,
            ),
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
        color: AppColors.primary,
        onRefresh: () => controller.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UserAvatar(
                          photoUrl: controller.currentUser.value?.photo,
                          initials:
                              '${(controller.currentUser.value?.prenom ?? '').isNotEmpty ? controller.currentUser.value!.prenom![0] : ''}'
                              '${(controller.currentUser.value?.nom ?? '').isNotEmpty ? controller.currentUser.value!.nom![0] : ''}',
                          radius: 24,
                          backgroundColor: Colors.white24,
                          textColor: Colors.white,
                          fontSize: 16,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${Tr.hello.tr}, ${controller.currentUser.value?.prenom ?? ''} 👋',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                Tr.howAreYou.tr,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.notification,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Barre de recherche
                    GestureDetector(
                      onTap: () => controller.changeTab(2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.search_normal_1,
                              color: AppColors.textLight,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                Tr.searchDoctorSpecialty.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Prochain RDV
              Obx(() {
                final rdv = controller.prochainRdv.value;
                if (rdv == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Tr.nextAppointment.tr,
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 10),
                      _ProchainRdvCard(rdv: rdv),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Cabinets
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Tr.medicalCabinets.tr, style: AppTextStyles.heading3),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.cabinets),
                      child: Text(Tr.seeAll.tr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => controller.isLoading.value
                    ? SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: 3,
                          itemBuilder: (_, __) =>
                              const ShimmerCard(width: 240, height: 130),
                        ),
                      )
                    : SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: controller.cabinets.length,
                          itemBuilder: (_, i) => _CabinetHorizontalCard(
                            cabinet: controller.cabinets[i],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // Spécialités
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Tr.specialties.tr, style: AppTextStyles.heading3),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.specialites),
                      child: Text(Tr.seeAll.tr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ShimmerLoading(itemCount: 2, height: 70),
                      )
                    : _SpecialitesGrid(specialites: controller.specialites),
              ),
              const SizedBox(height: 24),

              // Top Médecins
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Tr.doctors.tr, style: AppTextStyles.heading3),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.medecins),
                      child: Text(Tr.seeAll.tr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => controller.isLoading.value
                    ? SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: 3,
                          itemBuilder: (_, __) =>
                              const ShimmerCard(width: 150, height: 170),
                        ),
                      )
                    : SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: controller.medecins.length > 6
                              ? 6
                              : controller.medecins.length,
                          itemBuilder: (_, i) => _MedecinHorizontalCard(
                            medecin: controller.medecins[i],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── PROCHAIN RDV CARD ─────────────────────────────────────────
class _ProchainRdvCard extends StatelessWidget {
  final RendezVousModel rdv;
  const _ProchainRdvCard({required this.rdv});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
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
              UserAvatar(
                photoUrl: rdv.medecinPhoto,
                initials:
                    '${(rdv.medecinPrenom ?? '').isNotEmpty ? rdv.medecinPrenom![0] : ''}'
                    '${(rdv.medecinNom ?? '').isNotEmpty ? rdv.medecinNom![0] : ''}',
                radius: 22,
                backgroundColor: Colors.white24,
                textColor: Colors.white,
                fontSize: 14,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${rdv.medecinPrenom} ${rdv.medecinNom}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      rdv.medecinSpecialite ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rdv.statut ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.calendar_1, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  rdv.date ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Iconsax.clock, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${(rdv.heureDebut ?? '').length >= 5 ? rdv.heureDebut!.substring(0, 5) : ''} - ${(rdv.heureFin ?? '').length >= 5 ? rdv.heureFin!.substring(0, 5) : ''}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
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
    final color = AppColors.fromHex(cabinet.couleurPrimaire ?? '#007bff');
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.cabinetDetail, arguments: cabinet),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CabinetLogo(
              logoUrl: cabinet.logo,
              size: 44,
              borderRadius: 12,
              accentColor: color,
            ),
            const SizedBox(height: 10),
            Text(
              cabinet.nom ?? '',
              style: AppTextStyles.bodyBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Iconsax.location, size: 13, color: AppColors.textLight),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    cabinet.adresse ?? '',
                    style: AppTextStyles.caption,
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

// ─── MEDECIN HORIZONTAL CARD ───────────────────────────────────
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
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserAvatar(
              photoUrl: medecin.photo,
              initials:
                  '${(medecin.prenom ?? '').isNotEmpty ? medecin.prenom![0] : ''}'
                  '${(medecin.nom ?? '').isNotEmpty ? medecin.nom![0] : ''}',
              radius: 36,
              fontSize: 22,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Dr. ${medecin.prenom ?? ''}',
                style: AppTextStyles.bodyBold.copyWith(fontSize: 13),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                medecin.specialiteNom ?? '',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                medecin.cabinetNom ?? '',
                style: AppTextStyles.caption.copyWith(fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SPECIALITES GRID ──────────────────────────────────────────
class _SpecialitesGrid extends StatelessWidget {
  final List<SpecialiteModel> specialites;
  const _SpecialitesGrid({required this.specialites});

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'medical':
        return Iconsax.health;
      case 'heart':
        return Iconsax.heart;
      case 'skin':
        return Iconsax.brush_1;
      case 'baby':
        return Iconsax.lovely;
      case 'eye':
        return Iconsax.eye;
      case 'tooth':
        return Iconsax.shield_tick;
      default:
        return Iconsax.health;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: specialites.length,
        itemBuilder: (_, i) {
          final spec = specialites[i];
          return GestureDetector(
            onTap: () => Get.toNamed(
              AppRoutes.medecins,
              arguments: {'specialiteId': spec.id},
            ),
            child: Container(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIcon(''),
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    spec.nom ?? '',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(Tr.search.tr, style: AppTextStyles.heading2),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) => controller.searchQuery.value = v,
              decoration: InputDecoration(
                hintText: Tr.searchDoctorCabinet.tr,
                prefixIcon: const Icon(
                  Iconsax.search_normal_1,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 16),
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
                        color: AppColors.textLight.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(Tr.noResults.tr, style: AppTextStyles.body),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Médecins
                    if ((controller.searchFilter.value == 'all' ||
                            controller.searchFilter.value == 'doctors') &&
                        controller.filteredMedecins.isNotEmpty) ...[
                      Text(Tr.doctors.tr, style: AppTextStyles.heading3),
                      const SizedBox(height: 8),
                      ...controller.filteredMedecins
                          .take(5)
                          .map((m) => _SearchMedecinTile(medecin: m)),
                      const SizedBox(height: 16),
                    ],
                    // Cabinets
                    if ((controller.searchFilter.value == 'all' ||
                            controller.searchFilter.value == 'cabinets') &&
                        controller.filteredCabinets.isNotEmpty) ...[
                      Text(Tr.cabinets.tr, style: AppTextStyles.heading3),
                      const SizedBox(height: 8),
                      ...controller.filteredCabinets
                          .take(5)
                          .map((c) => _SearchCabinetTile(cabinet: c)),
                      const SizedBox(height: 16),
                    ],
                    // Spécialités
                    if ((controller.searchFilter.value == 'all' ||
                            controller.searchFilter.value == 'specialties') &&
                        controller.filteredSpecialites.isNotEmpty) ...[
                      Text(Tr.specialties.tr, style: AppTextStyles.heading3),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? AppColors.darkCardBackground : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isDark
                      ? AppColors.darkDivider
                      : AppColors.textLight.withValues(alpha: 0.3)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
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
          Text(Tr.quickAccess.tr, style: AppTextStyles.heading3),
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
            radius: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${medecin.prenom ?? ''} ${medecin.nom ?? ''}',
                  style: AppTextStyles.bodyBold,
                ),
                Text(
                  medecin.specialiteNom ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.textLight,
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
            size: 44,
            borderRadius: 12,
            accentColor: AppColors.fromHex(
              cabinet.couleurPrimaire ?? '#007bff',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cabinet.nom ?? '', style: AppTextStyles.bodyBold),
                Text(cabinet.adresse ?? '', style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.textLight,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.health,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(specialite.nom ?? '', style: AppTextStyles.bodyBold),
          ),
          Text(
            Tr.seeDoctors.tr,
            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.primary,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.textLight,
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Obx(
              () => GestureDetector(
                onTap: () => Get.find<AuthController>().pickAndUploadPhoto(),
                child: Stack(
                  children: [
                    UserAvatar(
                      photoUrl: controller.currentUser.value?.photo,
                      initials:
                          '${(controller.currentUser.value?.prenom ?? '').isNotEmpty ? controller.currentUser.value!.prenom![0] : ''}'
                          '${(controller.currentUser.value?.nom ?? '').isNotEmpty ? controller.currentUser.value!.nom![0] : ''}',
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                      fontSize: 32,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Iconsax.camera,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                '${controller.currentUser.value?.prenom ?? ''} ${controller.currentUser.value?.nom ?? ''}',
                style: AppTextStyles.heading2,
              ),
            ),
            Text(
              controller.currentUser.value?.email ?? '',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 32),
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
            _ProfileMenuItem(
              icon: Iconsax.notification,
              title: Tr.notifications.tr,
              onTap: () {},
            ),
            // Dark mode toggle
            Builder(
              builder: (context) {
                final themeCtrl = Get.find<ThemeController>();
                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  onTap: themeCtrl.toggleTheme,
                  child: Row(
                    children: [
                      Icon(
                        Get.isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          Tr.darkMode.tr,
                          style: AppTextStyles.bodyBold,
                        ),
                      ),
                      Switch.adaptive(
                        value: Get.isDarkMode,
                        activeTrackColor: AppColors.primary,
                        onChanged: (_) => themeCtrl.toggleTheme(),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
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
                    title: Text(Tr.disconnect.tr),
                    content: Text(Tr.disconnectConfirm.tr),
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
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color ?? AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyBold.copyWith(
                color: color ?? AppColors.textPrimary,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: color ?? AppColors.textLight,
          ),
        ],
      ),
    );
  }
}
