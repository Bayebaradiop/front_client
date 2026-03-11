import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../../rendezvous/views/mes_rdv_view.dart';
import '../../../translate/translation_keys.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              _HomeContent(controller: controller),
              const MesRdvView(embedded: true),
              _SearchContent(controller: controller),
              _ProfileContent(controller: controller),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
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
          )),
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
        onRefresh: () async => controller.simulateLoading(),
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
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white24,
                          child: Icon(Iconsax.user,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${Tr.hello.tr}, ${controller.userName.value} 👋',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                Tr.howAreYou.tr,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.notification,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Barre de recherche
                    GestureDetector(
                      onTap: () => controller.changeTab(2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Iconsax.search_normal_1,
                                color: AppColors.textLight, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              Tr.searchDoctorSpecialty.tr,
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.textLight),
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
                      Text(Tr.nextAppointment.tr,
                          style: AppTextStyles.heading3),
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
              Obx(() => controller.isLoading.value
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
                    )),
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
              Obx(() => controller.isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ShimmerLoading(itemCount: 2, height: 70),
                    )
                  : _SpecialitesGrid(
                      specialites: controller.specialites)),
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
  final Map<String, dynamic> rdv;
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
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
                child: Icon(Iconsax.user, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${rdv['medecinPrenom']} ${rdv['medecinNom']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      rdv['medecinSpecialite'] ?? '',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rdv['statut'] ?? '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
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
                const Icon(Iconsax.calendar_1,
                    color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  rdv['date'] ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Iconsax.clock, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${(rdv['heureDebut'] as String).substring(0, 5)} - ${(rdv['heureFin'] as String).substring(0, 5)}',
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
  final Map<String, dynamic> cabinet;
  const _CabinetHorizontalCard({required this.cabinet});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.fromHex(cabinet['couleurPrimaire'] ?? '#007bff');
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Iconsax.hospital, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              cabinet['nom'] ?? '',
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
                    cabinet['adresse'] ?? '',
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

// ─── SPECIALITES GRID ──────────────────────────────────────────
class _SpecialitesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> specialites;
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
            onTap: () => Get.toNamed(AppRoutes.medecins,
                arguments: {'specialiteId': spec['id']}),
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
                    child: Icon(_getIcon(spec['icon'] ?? ''),
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    spec['nom'] ?? '',
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w500),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Tr.search.tr, style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: Tr.searchDoctorCabinet.tr,
                prefixIcon: const Icon(Iconsax.search_normal_1,
                    color: AppColors.primary),
                suffixIcon: const Icon(Iconsax.setting_4,
                    color: AppColors.textLight),
              ),
            ),
            const SizedBox(height: 24),
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
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: AppColors.textLight),
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
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Iconsax.user, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
                  controller.userName.value,
                  style: AppTextStyles.heading2,
                )),
            Text('fatou.sall@email.com', style: AppTextStyles.body),
            const SizedBox(height: 32),
            _ProfileMenuItem(
              icon: Iconsax.user_edit,
              title: Tr.myProfile.tr,
              onTap: () {},
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
            _ProfileMenuItem(
              icon: Iconsax.setting_2,
              title: Tr.settings.tr,
              onTap: () {},
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
                    content: Text(
                        Tr.disconnectConfirm.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(Tr.cancel.tr),
                      ),
                      ElevatedButton(
                        onPressed: () => Get.offAllNamed('/login'),
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
              style: AppTextStyles.bodyBold
                  .copyWith(color: color ?? AppColors.textPrimary),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: color ?? AppColors.textLight),
        ],
      ),
    );
  }
}
