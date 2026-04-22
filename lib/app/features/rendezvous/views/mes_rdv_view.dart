import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/design_system/index.dart';
import '../../../translate/translation_keys.dart';
import '../controllers/rendezvous_controller.dart';

class MesRdvView extends StatelessWidget {
  final bool embedded;
  const MesRdvView({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RendezvousController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: embedded
          ? null
          : AppBar(
              title: Text(
                Tr.myAppointments.tr,
                style: DSTypography.headingSmall.copyWith(
                  color: DSColors.white,
                  fontSize: 20,
                ),
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: DSColors.white,
              elevation: 0,
              centerTitle: true,
            ),
      body: Column(
        children: [
          if (embedded)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  DSSpacing.screenMargin,
                  DSSpacing.lg,
                  DSSpacing.screenMargin,
                  0,
                ),
                child: _RdvHero(controller: controller),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.fromLTRB(
                DSSpacing.screenMargin,
                DSSpacing.lg,
                DSSpacing.screenMargin,
                0,
              ),
              child: _RdvIntro(controller: controller),
            ),
          SizedBox(height: DSSpacing.lg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: DSSpacing.screenMargin),
            child: Obx(
              () => _RdvFilterBar(
                selectedIndex: controller.selectedTabIndex.value,
                onChanged: (index) => controller.selectedTabIndex.value = index,
              ),
            ),
          ),
          SizedBox(height: DSSpacing.md),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DSSpacing.screenMargin,
                  ),
                  child: const ShimmerLoading(itemCount: 4, height: 168),
                );
              }

              final list = _currentList(controller);
              if (list.isEmpty) {
                return EmptyState(
                  icon: Iconsax.calendar_1,
                  title: Tr.noAppointments.tr,
                  subtitle: 'Planifiez votre premier rendez-vous.',
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => controller.refresh(),
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: DSSpacing.screenMargin,
                      right: DSSpacing.screenMargin,
                      top: DSSpacing.xs,
                      bottom: DSSpacing.bottomSafe,
                    ),
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
      case 1:
        return controller.rdvEnAttente;
      case 2:
        return controller.rdvConfirmes;
      case 3:
        return controller.rdvHistorique;
      default:
        return controller.tousLesRdv;
    }
  }
}

class _RdvHero extends StatelessWidget {
  final RendezvousController controller;
  const _RdvHero({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withAlpha(24),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.myAppointments.tr,
            style: DSTypography.labelLarge.copyWith(
              color: DSColors.white.withAlpha(225),
            ),
          ),
          SizedBox(height: DSSpacing.sm),
          Text(
            'Vos rendez-vous, plus simplement.',
            style: DSTypography.headingSmall.copyWith(
              color: DSColors.white,
              fontSize: 22,
              height: 1.2,
            ),
          ),
          SizedBox(height: DSSpacing.sm),
          Text(
            'Retrouvez l\'essentiel en un coup d\'oeil.',
            style: DSTypography.bodyMedium.copyWith(
              color: DSColors.white.withAlpha(214),
            ),
          ),
          SizedBox(height: DSSpacing.lg),
          Obx(
            () => Wrap(
              spacing: DSSpacing.sm,
              runSpacing: DSSpacing.sm,
              children: [
                _HeroPill(
                  value: '${controller.tousLesRdv.length}',
                  label: Tr.all.tr,
                ),
                _HeroPill(
                  value: '${controller.rdvEnAttente.length}',
                  label: Tr.pending.tr,
                ),
                _HeroPill(
                  value: '${controller.rdvConfirmes.length}',
                  label: Tr.confirmed.tr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RdvIntro extends StatelessWidget {
  final RendezvousController controller;
  const _RdvIntro({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.myAppointments.tr,
            style: DSTypography.headingSmall.copyWith(
              color: DSColors.textPrimary,
            ),
          ),
          SizedBox(height: DSSpacing.xs),
          Text(
            '${controller.tousLesRdv.length} rendez-vous dans votre espace.',
            style: DSTypography.bodyMedium.copyWith(
              color: DSColors.textSecondary,
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

  const _HeroPill({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DSSpacing.md,
        vertical: DSSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: DSColors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DSColors.white.withAlpha(28)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: DSTypography.labelLarge.copyWith(color: DSColors.white),
            ),
            TextSpan(
              text: label,
              style: DSTypography.bodySmall.copyWith(
                color: DSColors.white.withAlpha(214),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RdvFilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _RdvFilterBar({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [Tr.all.tr, Tr.pending.tr, Tr.confirmed.tr, Tr.history.tr];

    return Container(
      padding: EdgeInsets.all(DSSpacing.xs),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DSColors.borderLight),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: EdgeInsets.symmetric(vertical: DSSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  items[index],
                  textAlign: TextAlign.center,
                  style: DSTypography.labelSmall.copyWith(
                    color: isSelected ? DSColors.white : DSColors.textSecondary,
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
    final statut = (rdv['statut'] as String?) ?? 'EN_ATTENTE';
    final color = _statusColor(statut);
    final rawDebut = (rdv['heureDebut'] as String?) ?? '';
    final rawFin = (rdv['heureFin'] as String?) ?? '';
    final heureDebut = rawDebut.length >= 5
        ? rawDebut.substring(0, 5)
        : rawDebut;
    final heureFin = rawFin.length >= 5 ? rawFin.substring(0, 5) : rawFin;

    return Container(
      margin: EdgeInsets.only(bottom: DSSpacing.md),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DSColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () =>
              Get.toNamed(AppRoutes.rdvDetail, arguments: {'rdv': rdv}),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(DSSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(DSSpacing.xs),
                      decoration: BoxDecoration(
                        color: color.withAlpha(18),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: UserAvatar(
                        photoUrl: rdv['medecinPhoto'] as String?,
                        initials:
                            '${((rdv['medecinPrenom'] as String?) ?? '').isNotEmpty ? (rdv['medecinPrenom'] as String)[0] : ''}'
                            '${((rdv['medecinNom'] as String?) ?? '').isNotEmpty ? (rdv['medecinNom'] as String)[0] : ''}',
                        radius: 22,
                        backgroundColor: color,
                        textColor: DSColors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: DSSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${rdv['medecinPrenom'] ?? ''} ${rdv['medecinNom'] ?? ''}',
                            style: DSTypography.labelLarge.copyWith(
                              color: DSColors.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: DSSpacing.xs),
                          Text(
                            rdv['medecinSpecialite'] ?? '',
                            style: DSTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          if (((rdv['cabinetNom'] ?? '') as String)
                              .isNotEmpty) ...[
                            SizedBox(height: DSSpacing.xs),
                            Text(
                              rdv['cabinetNom'] ?? '',
                              style: DSTypography.bodySmall.copyWith(
                                color: DSColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: DSSpacing.sm),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: DSSpacing.sm,
                        vertical: DSSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: color.withAlpha(16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusLabel(statut),
                        style: DSTypography.labelSmall.copyWith(color: color),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DSSpacing.md),
                Container(
                  padding: EdgeInsets.all(DSSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryUltraLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primaryLight.withAlpha(60),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _MetaItem(
                              icon: Iconsax.calendar_1,
                              label: Tr.date.tr,
                              value: rdv['date'] ?? '',
                            ),
                          ),
                          SizedBox(width: DSSpacing.sm),
                          Expanded(
                            child: _MetaItem(
                              icon: Iconsax.clock,
                              label: Tr.time.tr,
                              value: '$heureDebut - $heureFin',
                            ),
                          ),
                        ],
                      ),
                      if (((rdv['cabinetAdresse'] ?? '') as String)
                          .isNotEmpty) ...[
                        SizedBox(height: DSSpacing.sm),
                        _MetaItem(
                          icon: Iconsax.location,
                          label: Tr.address.tr,
                          value: rdv['cabinetAdresse'] ?? '',
                        ),
                      ],
                    ],
                  ),
                ),
                if (controller.canCancel(statut)) ...[
                  SizedBox(height: DSSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showCancelDialog(context),
                          icon: const Icon(
                            Iconsax.close_circle,
                            size: 16,
                            color: AppColors.error,
                          ),
                          label: Text(
                            Tr.cancel.tr,
                            style: DSTypography.labelMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: DSSpacing.sm,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(DSSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.warning_2,
                color: AppColors.error,
                size: 22,
              ),
            ),
            SizedBox(width: DSSpacing.sm),
            Expanded(
              child: Text(
                Tr.cancelRdv.tr,
                style: DSTypography.labelLarge.copyWith(
                  color: DSColors.textPrimary,
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
          TextButton(onPressed: () => Get.back(), child: Text(Tr.noKeep.tr)),
          ElevatedButton(
            onPressed: () => controller.annulerRdv(rdv['id']),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(Tr.yesCancel.tr),
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
        Icon(icon, size: 16, color: AppColors.primary),
        SizedBox(width: DSSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: DSTypography.labelSmall.copyWith(
                  color: DSColors.textSecondary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: DSTypography.bodyMedium.copyWith(
                  color: DSColors.textPrimary,
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
