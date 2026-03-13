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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedecinController>();
    final motifCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
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
                          initials: '${(medecin['prenom'] as String)[0]}${(medecin['nom'] as String)[0]}',
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
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            medecin['specialiteNom'] ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          medecin['cabinetNom'] ?? '',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
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
                    Text(Tr.chooseDate.tr,
                        style: AppTextStyles.heading3),
                    const SizedBox(height: 12),

                    // Calendrier horizontal (7 jours)
                    Obx(() => SizedBox(
                      height: 90,
                      child: Row(
                        children: List.generate(7, (i) {
                          final date =
                              DateTime.now().add(Duration(days: i));
                          final isSelected = controller
                                      .selectedDate.value.day ==
                                  date.day &&
                              controller.selectedDate.value.month ==
                                  date.month;
                          final dayName = DateFormat('EEE', 'fr_FR')
                              .format(date)
                              .toUpperCase();
                          final dayNum = date.day.toString();
                          final monthName =
                              DateFormat('MMM', 'fr_FR').format(date);

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                controller.selectDate(date);
                              },
                              child: AnimatedScale(
                                scale: isSelected ? 1.08 : 1.0,
                                duration:
                                    const Duration(milliseconds: 200),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.cardBackground,
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    border: isSelected
                                        ? null
                                        : Border.all(
                                            color: AppColors.divider),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 10,
                                              offset:
                                                  const Offset(0, 4),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayName,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white70
                                              : AppColors.textLight,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dayNum,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        monthName,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isSelected
                                              ? Colors.white70
                                              : AppColors.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )),
                    const SizedBox(height: 24),

                    // Créneaux disponibles
                    Text(Tr.availableSlots.tr,
                        style: AppTextStyles.heading3),
                    const SizedBox(height: 12),

                    Obx(() {
                      if (controller.creneaux.isEmpty) {
                        return EmptyState(
                          icon: Iconsax.clock,
                          title: Tr.noSlots.tr,
                          subtitle:
                              Tr.tryAnotherDate.tr,
                        );
                      }
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.creneaux.map((creneau) {
                          final isDisponible =
                              creneau['disponible'] == true;
                          final isSelected =
                              controller.selectedCreneau.value?['id'] ==
                                  creneau['id'];
                          final heureDebut =
                              (creneau['heureDebut'] as String)
                                  .substring(0, 5);
                          final heureFin =
                              (creneau['heureFin'] as String)
                                  .substring(0, 5);

                          return GestureDetector(
                            onTap: isDisponible
                                ? () =>
                                    controller.selectCreneau(creneau)
                                : null,
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: !isDisponible
                                    ? AppColors.divider
                                        .withValues(alpha: 0.5)
                                    : isSelected
                                        ? AppColors.primary
                                        : AppColors.cardBackground,
                                borderRadius:
                                    BorderRadius.circular(14),
                                border: isDisponible && !isSelected
                                    ? Border.all(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.3))
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset:
                                              const Offset(0, 2),
                                        )
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
                    Text(Tr.consultationReason.tr,
                        style: AppTextStyles.heading3),
                    const SizedBox(height: 12),
                    TextField(
                      controller: motifCtrl,
                      maxLines: 3,
                      onChanged: (v) =>
                          controller.motifController.value = v,
                      decoration: InputDecoration(
                        hintText:
                            Tr.describeReason.tr,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 48),
                          child: Icon(Iconsax.document_text,
                              color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bouton confirmer
                    Obx(() => CustomButton(
                          text: Tr.confirmAppointment.tr,
                          isLoading: controller.isBooking.value,
                          icon: Iconsax.calendar_tick,
                          onPressed: () {
                            _showConfirmDialog(context, controller);
                          },
                        )),
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

  void _showConfirmDialog(
      BuildContext context, MedecinController controller) {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.calendar_tick,
                  color: AppColors.primary, size: 22),
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
              value: creneau['date'] ?? '',
            ),
            _DialogInfoRow(
              label: Tr.time.tr,
              value:
                  '${(creneau['heureDebut'] as String).substring(0, 5)} - ${(creneau['heureFin'] as String).substring(0, 5)}',
            ),
            _DialogInfoRow(
              label: Tr.reason.tr,
              value: controller.motifController.value.isEmpty
                  ? Tr.notSpecified.tr
                  : controller.motifController.value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(Tr.cancel.tr),
          ),
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
            child: Text(label,
                style: AppTextStyles.caption
                    .copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}
