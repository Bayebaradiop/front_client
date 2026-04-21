import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/user_avatar.dart';
import '../controllers/medecin_controller.dart';
import '../../../translate/translation_keys.dart';

class MedecinDetailView extends StatelessWidget {
  const MedecinDetailView({super.key});

  String get _locale => Get.locale?.toString() ?? 'fr_FR';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedecinController>();

    return Scaffold(
      body: Obx(() {
        final medecin = controller.selectedMedecin.value;
        if (medecin == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Profil médecin header
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primaryDark, AppColors.primary],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        UserAvatar(
                          photoUrl: medecin['photo'] as String?,
                          initials:
                              '${(medecin['prenom'] as String)[0]}${(medecin['nom'] as String)[0]}',
                          radius: 42,
                          backgroundColor: Colors.white24,
                          textColor: Colors.white,
                          fontSize: 28,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Dr. ${medecin['prenom']} ${medecin['nom']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            medecin['specialiteNom'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          medecin['cabinetNom'] ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
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
                    // Titre section
                    Text(Tr.chooseDate.tr, style: AppTextStyles.heading3),
                    const SizedBox(height: 12),

                    // Calendrier hebdomadaire
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatWeekRange(
                                          controller.weekStart.value,
                                        ),
                                        style: AppTextStyles.bodyBold.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.selectedDate.value == null
                                            ? Tr.noSlotsThisWeek.tr
                                            : _formatReadableDate(
                                                DateFormat(
                                                  'yyyy-MM-dd',
                                                  _locale,
                                                ).format(
                                                  controller
                                                      .selectedDate
                                                      .value!,
                                                ),
                                              ),
                                        style: AppTextStyles.caption.copyWith(
                                          color:
                                              controller.selectedDate.value ==
                                                  null
                                              ? AppColors.textLight
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  children: [
                                    _WeekNavigationButton(
                                      icon: Icons.chevron_left_rounded,
                                      tooltip: Tr.previousWeek.tr,
                                      onPressed:
                                          controller.canGoToPreviousWeek &&
                                              !controller
                                                  .isLoadingCreneaux
                                                  .value
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
                                      onPressed:
                                          controller.isLoadingCreneaux.value
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
                              const SizedBox(
                                height: 96,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            else
                              SizedBox(
                                height: 108,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  itemCount: controller.weekDates.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 4),
                                  itemBuilder: (_, index) {
                                    final date = controller.weekDates[index];
                                    final isSelected = controller
                                        .isSelectedDate(date);
                                    final isAvailable = controller
                                        .hasSlotsForDate(date);
                                    final primaryTextColor = isSelected
                                        ? Colors.white
                                        : isAvailable
                                        ? AppColors.textPrimary
                                        : AppColors.textLight;
                                    final secondaryTextColor = isSelected
                                        ? Colors.white70
                                        : isAvailable
                                        ? AppColors.textSecondary
                                        : AppColors.textLight;

                                    return SizedBox(
                                      width: 56,
                                      child: Opacity(
                                        opacity: isAvailable ? 1 : 0.65,
                                        child: GestureDetector(
                                          onTap: isAvailable
                                              ? () {
                                                  HapticFeedback.lightImpact();
                                                  controller.selectDate(date);
                                                }
                                              : null,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                              4,
                                              8,
                                              4,
                                              6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : isAvailable
                                                  ? AppColors.cardBackground
                                                  : AppColors.background,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : isAvailable
                                                    ? AppColors.primary
                                                          .withValues(
                                                            alpha: 0.18,
                                                          )
                                                    : AppColors.divider,
                                              ),
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color: AppColors.primary
                                                            .withValues(
                                                              alpha: 0.28,
                                                            ),
                                                        blurRadius: 10,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 14,
                                                  child: Center(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        _formatDayLabel(date),
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              secondaryTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                SizedBox(
                                                  height: 34,
                                                  child: Center(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        '${date.day}',
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              primaryTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                SizedBox(
                                                  height: 14,
                                                  child: Center(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        _formatMonthLabel(date),
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              secondaryTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : isAvailable
                                                        ? AppColors.primary
                                                        : Colors.transparent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                    const SizedBox(height: 24),

                    // Créneaux disponibles
                    Text(Tr.availableSlots.tr, style: AppTextStyles.heading3),
                    const SizedBox(height: 12),

                    Obx(() {
                      if (controller.isLoadingCreneaux.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      if (controller.selectedDate.value == null) {
                        return EmptyState(
                          icon: Iconsax.clock,
                          title: Tr.noSlotsThisWeek.tr,
                          subtitle: Tr.tryAnotherDate.tr,
                        );
                      }
                      if (controller.creneaux.isEmpty) {
                        return EmptyState(
                          icon: Iconsax.clock,
                          title: Tr.noSlots.tr,
                          subtitle: Tr.tryAnotherDate.tr,
                        );
                      }
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.creneaux.map((creneau) {
                          final isDisponible = creneau['disponible'] == true;
                          final isSelected =
                              controller.selectedCreneau.value?['id'] ==
                              creneau['id'];
                          final heureDebut = (creneau['heureDebut'] as String)
                              .substring(0, 5);
                          final heureFin = (creneau['heureFin'] as String)
                              .substring(0, 5);

                          return GestureDetector(
                            onTap: isDisponible
                                ? () => controller.selectCreneau(creneau)
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: !isDisponible
                                    ? AppColors.divider.withValues(alpha: 0.5)
                                    : isSelected
                                    ? AppColors.primary
                                    : AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(14),
                                border: isDisponible && !isSelected
                                    ? Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                      )
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                '$heureDebut - $heureFin',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: !isDisponible
                                      ? AppColors.textLight
                                      : isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                  decoration: !isDisponible
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 24),

                    // Motif
                    Text(
                      Tr.consultationReason.tr,
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.motifController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: Tr.describeReason.tr,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 48),
                          child: Icon(
                            Iconsax.document_text,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bouton confirmer
                    Obx(
                      () => CustomButton(
                        text: Tr.confirmAppointment.tr,
                        isLoading: controller.isBooking.value,
                        icon: Iconsax.calendar_tick,
                        onPressed: () {
                          _showConfirmDialog(context, controller);
                        },
                      ),
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

  void _showConfirmDialog(BuildContext context, MedecinController controller) {
    final creneau = controller.selectedCreneau.value;
    final medecin = controller.selectedMedecin.value;

    if (creneau == null || medecin == null) {
      Get.snackbar(
        Tr.error.tr,
        Tr.selectSlotError.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.calendar_tick,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(Tr.confirm.tr),
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
          TextButton(onPressed: () => Get.back(), child: Text(Tr.cancel.tr)),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.confirmBooking();
            },
            child: Text(Tr.confirm.tr),
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

    if (start.year == end.year) {
      return '${Tr.weekOf.tr} ${DateFormat('d MMM', _locale).format(start)} - ${DateFormat('d MMM y', _locale).format(end)}';
    }

    return '${Tr.weekOf.tr} ${DateFormat('d MMM y', _locale).format(start)} - ${DateFormat('d MMM y', _locale).format(end)}';
  }

  String _formatReadableDate(String? rawDate) {
    final parsedDate = rawDate == null ? null : DateTime.tryParse(rawDate);
    if (parsedDate == null) return rawDate ?? '';

    return _capitalize(DateFormat('EEEE d MMMM y', _locale).format(parsedDate));
  }

  String _formatDayLabel(DateTime date) {
    return DateFormat(
      'EEE',
      _locale,
    ).format(date).replaceAll('.', '').toUpperCase();
  }

  String _formatMonthLabel(DateTime date) {
    return DateFormat('MMM', _locale).format(date).replaceAll('.', '');
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
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
        color: isEnabled
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.divider.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              icon,
              color: isEnabled ? AppColors.primary : AppColors.textLight,
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
            width: 70,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}
