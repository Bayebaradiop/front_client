import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/widgets/cabinet_logo.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/medecin_model.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../controllers/cabinet_controller.dart';

class CabinetDetailView extends StatelessWidget {
  const CabinetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CabinetController>();
    final cabinet = controller.selectedCabinet.value ??
        (Get.arguments is CabinetModel ? Get.arguments as CabinetModel : null);

    return Scaffold(
      backgroundColor: DSColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // En-tête Plat Moderne sans Dégradé
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: DSColors.primaryDark,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 18, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: DSColors.primaryDark,
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: Colors.white, width: 3.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CabinetLogo(
                              logoUrl: cabinet?.logo,
                              size: 92,
                              borderRadius: 22,
                              accentColor: DSColors.primary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            cabinet?.nom ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: DSTypography.headingMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 21,
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

          // Contenu Principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carte Coordonnées Réelles du Cabinet
                  _CabinetInfoCard(cabinet: cabinet),
                  const SizedBox(height: 20),

                  // Spécialités du Cabinet
                  _SpecialitesSection(controller: controller),
                  const SizedBox(height: 24),

                  // Équipe Médicale Rattachée
                  _EquipeSection(cabinet: cabinet, controller: controller),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CARTE COORDONNÉES DU CABINET ────────────────────────────────
class _CabinetInfoCard extends StatelessWidget {
  final CabinetModel? cabinet;
  const _CabinetInfoCard({required this.cabinet});

  @override
  Widget build(BuildContext context) {
    if (cabinet == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DSColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations du Cabinet',
            style: DSTypography.headingSmall.copyWith(
              color: DSColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          if (cabinet!.adresse != null && cabinet!.adresse!.isNotEmpty) ...[
            _InfoRow(
              icon: Iconsax.location,
              title: 'Adresse',
              value: cabinet!.adresse!,
            ),
            const SizedBox(height: 10),
          ],
          if (cabinet!.telephone != null && cabinet!.telephone!.isNotEmpty) ...[
            _InfoRow(
              icon: Iconsax.call,
              title: 'Téléphone',
              value: cabinet!.telephone!,
            ),
            const SizedBox(height: 10),
          ],
          if (cabinet!.email != null && cabinet!.email!.isNotEmpty) ...[
            _InfoRow(
              icon: Iconsax.sms,
              title: 'Email',
              value: cabinet!.email!,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: DSColors.primaryUltraLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: DSColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: DSTypography.labelSmall.copyWith(
                  color: DSColors.textLight,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: DSTypography.bodyMedium.copyWith(
                  color: DSColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── SECTION SPÉCIALITÉS ───────────────────────────────────────
class _SpecialitesSection extends StatelessWidget {
  final CabinetController controller;
  const _SpecialitesSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSpecialites.value) {
        return const FilterPillsSkeleton(itemCount: 4);
      }
      final specs = controller.specialitesDuCabinet;
      if (specs.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spécialités Disponibles (${specs.length})',
            style: DSTypography.headingSmall.copyWith(
              color: DSColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: specs.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: DSColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.health, size: 14, color: DSColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      s.nom ?? '',
                      style: DSTypography.labelSmall.copyWith(
                        color: DSColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}

// ─── SECTION ÉQUIPE MÉDICALE ───────────────────────────────────
class _EquipeSection extends StatelessWidget {
  final CabinetModel? cabinet;
  final CabinetController controller;

  const _EquipeSection({required this.cabinet, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const MedecinCardSkeleton(itemCount: 2);
      }
      final medecins = controller.medecinsDuCabinet;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Médecins Rattachés (${medecins.length})',
            style: DSTypography.headingSmall.copyWith(
              color: DSColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          if (medecins.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DSColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DSColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.user_search, color: DSColors.textLight, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Aucun médecin directement rattaché pour le moment.',
                      style: DSTypography.bodySmall.copyWith(color: DSColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ...medecins.map((med) => _MedecinCardItem(medecin: med)),
          ],
        ],
      );
    });
  }
}

class _MedecinCardItem extends StatelessWidget {
  final MedecinModel medecin;
  const _MedecinCardItem({required this.medecin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DSColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: DSColors.borderLight, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: UserAvatar(
              photoUrl: medecin.photo,
              initials:
                  '${(medecin.prenom ?? '').isNotEmpty ? medecin.prenom![0] : ''}'
                  '${(medecin.nom ?? '').isNotEmpty ? medecin.nom![0] : ''}',
              radius: 32,
              backgroundColor: DSColors.primaryUltraLight,
              textColor: DSColors.primary,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${medecin.prenom ?? ''} ${medecin.nom ?? ''}',
                  style: DSTypography.headingSmall.copyWith(
                    color: DSColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  medecin.specialiteNom ?? 'Médecin',
                  style: DSTypography.bodySmall.copyWith(
                    color: DSColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Get.toNamed(
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
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DSColors.primaryUltraLight,
              foregroundColor: DSColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Prendre RDV',
              style: DSTypography.labelSmall.copyWith(
                color: DSColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
