import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../theme/design_system/colors_ds.dart';
import '../../../theme/design_system/typography_ds.dart';
import '../../../translate/translation_keys.dart';
import '../controllers/medecin_controller.dart';

class MedecinDetailView extends StatelessWidget {
  const MedecinDetailView({super.key});

  String get _locale => Get.locale?.toString() ?? 'fr_FR';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedecinController>();

    return Scaffold(
      backgroundColor: DSColors.background,
      body: Obx(() {
        final medecin = controller.selectedMedecin.value;
        if (medecin == null) {
          return const DoctorDetailSkeleton();
        }

        final doctorName = 'Dr. ${medecin['prenom']} ${medecin['nom']}';
        final hasSelectedSlot = controller.selectedCreneau.value != null;

        return Stack(
          children: [
            CustomScrollView(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Executive Header
                SliverAppBar(
                  expandedHeight: 340,
                  pinned: true,
                  backgroundColor: DSColors.primaryDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.25),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: UserAvatar(
                                photoUrl: medecin['photo'] as String?,
                                initials:
                                    '${(medecin['prenom'] as String)[0]}${(medecin['nom'] as String)[0]}',
                                radius: 80,
                                backgroundColor: Colors.white24,
                                textColor: Colors.white,
                                fontSize: 44,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              doctorName,
                              style: DSTypography.headingMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Text(
                                medecin['specialiteNom'] ?? '',
                                style: DSTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Iconsax.location, size: 14, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(
                                  medecin['cabinetNom'] ?? '',
                                  style: DSTypography.bodySmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header: Date Selection
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: DSColors.primaryUltraLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Iconsax.calendar_1, size: 18, color: DSColors.primary),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              Tr.chooseDate.tr,
                              style: DSTypography.headingSmall.copyWith(
                                color: DSColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Week Calendar Component
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.all(16),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _formatWeekRange(controller.weekStart.value),
                                            style: DSTypography.labelLarge.copyWith(
                                              color: DSColors.primary,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            controller.selectedDate.value == null
                                                ? Tr.noSlotsThisWeek.tr
                                                : _formatReadableDate(
                                                    DateFormat('yyyy-MM-dd', _locale).format(
                                                      controller.selectedDate.value!,
                                                    ),
                                                  ),
                                            style: DSTypography.bodySmall.copyWith(
                                              color: DSColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        _WeekNavigationButton(
                                          icon: Icons.chevron_left_rounded,
                                          tooltip: Tr.previousWeek.tr,
                                          onPressed: controller.canGoToPreviousWeek &&
                                                  !controller.isLoadingCreneaux.value
                                              ? () {
                                                  HapticFeedback.lightImpact();
                                                  controller.previousWeek();
                                                }
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        _WeekNavigationButton(
                                          icon: Icons.chevron_right_rounded,
                                          tooltip: Tr.nextWeek.tr,
                                          onPressed: controller.isLoadingCreneaux.value
                                              ? null
                                              : () {
                                                  HapticFeedback.lightImpact();
                                                  controller.nextWeek();
                                                },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (controller.isLoadingCreneaux.value)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: CreneauxSkeleton(),
                                  )
                                else
                                  SizedBox(
                                    height: 104,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: controller.weekDates.length,
                                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                                      itemBuilder: (_, index) {
                                        final date = controller.weekDates[index];
                                        final isSelected = controller.isSelectedDate(date);
                                        final isAvailable = controller.hasSlotsForDate(date);

                                        return GestureDetector(
                                          onTap: isAvailable
                                              ? () {
                                                  HapticFeedback.selectionClick();
                                                  controller.selectDate(date);
                                                }
                                              : null,
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 220),
                                            width: 58,
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? DSColors.primary
                                                  : isAvailable
                                                      ? DSColors.surface
                                                      : DSColors.background,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: isSelected
                                                    ? DSColors.primary
                                                    : isAvailable
                                                        ? DSColors.primaryLight.withValues(alpha: 0.4)
                                                        : DSColors.borderLight,
                                              ),
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color: DSColors.primary.withValues(alpha: 0.3),
                                                        blurRadius: 12,
                                                        offset: const Offset(0, 4),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _formatDayLabel(date),
                                                  style: DSTypography.labelSmall.copyWith(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: isSelected
                                                        ? Colors.white70
                                                        : isAvailable
                                                            ? DSColors.textSecondary
                                                            : DSColors.textLight,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${date.day}',
                                                  style: DSTypography.headingSmall.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 20,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : isAvailable
                                                            ? DSColors.textPrimary
                                                            : DSColors.textLight,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  _formatMonthLabel(date),
                                                  style: DSTypography.labelSmall.copyWith(
                                                    fontSize: 10,
                                                    color: isSelected
                                                        ? Colors.white70
                                                        : isAvailable
                                                            ? DSColors.textSecondary
                                                            : DSColors.textLight,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : isAvailable
                                                            ? DSColors.primary
                                                            : Colors.transparent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Section Header: Slots
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: DSColors.primaryUltraLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Iconsax.clock, size: 18, color: DSColors.primary),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              Tr.availableSlots.tr,
                              style: DSTypography.headingSmall.copyWith(
                                color: DSColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        Obx(() {
                          if (controller.isLoadingCreneaux.value) {
                            return const CreneauxSkeleton();
                          }
                          if (controller.selectedDate.value == null || controller.creneaux.isEmpty) {
                            return EmptyState(
                              icon: Iconsax.clock,
                              title: Tr.noSlots.tr,
                              subtitle: Tr.tryAnotherDate.tr,
                            );
                          }

                          // Group creneaux into Matin and Après-Midi
                          final matinCreneaux = controller.creneaux.where((c) {
                            final h = int.tryParse((c['heureDebut'] as String).split(':')[0]) ?? 0;
                            return h < 12;
                          }).toList();

                          final apremCreneaux = controller.creneaux.where((c) {
                            final h = int.tryParse((c['heureDebut'] as String).split(':')[0]) ?? 0;
                            return h >= 12;
                          }).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (matinCreneaux.isNotEmpty) ...[
                                Row(
                                  children: [
                                    const Icon(Icons.wb_sunny_rounded, size: 16, color: Color(0xFFF59E0B)),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Matin',
                                      style: DSTypography.labelLarge.copyWith(
                                        color: DSColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _SlotWrap(creneaux: matinCreneaux, controller: controller),
                                const SizedBox(height: 20),
                              ],
                              if (apremCreneaux.isNotEmpty) ...[
                                Row(
                                  children: [
                                    const Icon(Icons.nightlight_round, size: 16, color: DSColors.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Après-midi',
                                      style: DSTypography.labelLarge.copyWith(
                                        color: DSColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _SlotWrap(creneaux: apremCreneaux, controller: controller),
                              ],
                            ],
                          );
                        }),
                        const SizedBox(height: 28),

                        // Reason for consultation
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: DSColors.primaryUltraLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Iconsax.document_text, size: 18, color: DSColors.primary),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              Tr.consultationReason.tr,
                              style: DSTypography.headingSmall.copyWith(
                                color: DSColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: controller.motifController,
                          focusNode: controller.motifFocusNode,
                          onTap: () => controller.scrollToMotifField(),
                          maxLines: 3,
                          style: DSTypography.bodyMedium.copyWith(color: DSColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: Tr.describeReason.tr,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Sticky Bottom Action Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Obx(
                    () => CustomButton(
                      text: Tr.confirmAppointment.tr,
                      isLoading: controller.isBooking.value,
                      icon: Iconsax.calendar_tick,
                      onPressed: hasSelectedSlot
                          ? () {
                              HapticFeedback.mediumImpact();
                              _showConfirmDialog(context, controller);
                            }
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showConfirmDialog(BuildContext context, MedecinController controller) {
    final creneau = controller.selectedCreneau.value;
    final medecin = controller.selectedMedecin.value;

    if (creneau == null || medecin == null) return;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: DSColors.surface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: DSColors.primaryUltraLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.calendar_tick, color: DSColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              Tr.confirm.tr,
              style: DSTypography.headingSmall.copyWith(color: DSColors.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DialogInfoRow(
              label: Tr.doctor.tr,
              value: 'Dr. ${medecin['prenom']} ${medecin['nom']}',
            ),
            _DialogInfoRow(
              label: Tr.date.tr,
              value: _formatReadableDate(creneau['date'] as String?),
            ),
            _DialogInfoRow(
              label: Tr.time.tr,
              value:
                  '${(creneau['heureDebut'] as String).substring(0, 5)} - ${(creneau['heureFin'] as String).substring(0, 5)}',
            ),
            _DialogInfoRow(
              label: Tr.reason.tr,
              value: controller.motifController.text.trim().isEmpty
                  ? Tr.notSpecified.tr
                  : controller.motifController.text.trim(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              Tr.cancel.tr,
              style: DSTypography.labelMedium.copyWith(color: DSColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.confirmBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DSColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              Tr.confirm.tr,
              style: DSTypography.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _formatWeekRange(DateTime start) {
    final end = start.add(const Duration(days: 6));
    if (start.month == end.month && start.year == end.year) {
      return '${Tr.weekOf.tr} ${DateFormat('d', _locale).format(start)} - ${DateFormat('d MMM y', _locale).format(end)}';
    }
    return '${Tr.weekOf.tr} ${DateFormat('d MMM', _locale).format(start)} - ${DateFormat('d MMM y', _locale).format(end)}';
  }

  String _formatReadableDate(String? rawDate) {
    final parsedDate = rawDate == null ? null : DateTime.tryParse(rawDate);
    if (parsedDate == null) return rawDate ?? '';
    return _capitalize(DateFormat('EEEE d MMMM y', _locale).format(parsedDate));
  }

  String _formatDayLabel(DateTime date) {
    return DateFormat('EEE', _locale).format(date).replaceAll('.', '').toUpperCase();
  }

  String _formatMonthLabel(DateTime date) {
    return DateFormat('MMM', _locale).format(date).replaceAll('.', '');
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

class _SlotWrap extends StatelessWidget {
  final List<dynamic> creneaux;
  final MedecinController controller;

  const _SlotWrap({required this.creneaux, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: creneaux.map((creneau) {
        final isDisponible = creneau['disponible'] == true;
        final isSelected = controller.selectedCreneau.value?['id'] == creneau['id'];
        final heureDebut = (creneau['heureDebut'] as String).substring(0, 5);
        final heureFin = (creneau['heureFin'] as String).substring(0, 5);

        return GestureDetector(
          onTap: isDisponible
              ? () {
                  HapticFeedback.selectionClick();
                  controller.selectCreneau(creneau);
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: !isDisponible
                  ? DSColors.borderLight.withValues(alpha: 0.4)
                  : isSelected
                      ? DSColors.primary
                      : DSColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? DSColors.primary
                    : isDisponible
                        ? DSColors.primaryLight.withValues(alpha: 0.3)
                        : DSColors.borderLight,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: DSColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              '$heureDebut - $heureFin',
              style: DSTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: !isDisponible
                    ? DSColors.textLight
                    : isSelected
                        ? Colors.white
                        : DSColors.primary,
                decoration: !isDisponible ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _WeekNavigationButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _WeekNavigationButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isEnabled ? DSColors.primaryUltraLight : DSColors.borderLight,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              icon,
              size: 20,
              color: isEnabled ? DSColors.primary : DSColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _DialogInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: DSTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: DSColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: DSTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: DSColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
