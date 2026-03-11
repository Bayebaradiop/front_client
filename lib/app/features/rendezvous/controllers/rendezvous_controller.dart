import 'dart:ui';
import 'package:get/get.dart';
import '../../../translate/translation_keys.dart';

class RendezvousController extends GetxController {
  final isLoading = false.obs;
  final selectedTabIndex = 0.obs;
  final selectedRdv = Rxn<Map<String, dynamic>>();

  final rendezVous = <Map<String, dynamic>>[
    {
      'id': 7,
      'statut': 'CONFIRME',
      'motif': 'Consultation générale',
      'date': '2026-03-15',
      'heureDebut': '09:00:00',
      'heureFin': '09:30:00',
      'medecinId': 3,
      'medecinNom': 'Dupont',
      'medecinPrenom': 'Jean',
      'medecinSpecialite': 'Médecine Générale',
      'cabinetId': 1,
      'cabinetNom': 'Cabinet Médical Medibook',
      'cabinetAdresse': '123 Avenue de la Santé, Dakar',
    },
    {
      'id': 8,
      'statut': 'EN_ATTENTE',
      'motif': 'Douleur thoracique',
      'date': '2026-03-18',
      'heureDebut': '10:00:00',
      'heureFin': '10:30:00',
      'medecinId': 4,
      'medecinNom': 'Diallo',
      'medecinPrenom': 'Marie',
      'medecinSpecialite': 'Cardiologie',
      'cabinetId': 1,
      'cabinetNom': 'Cabinet Médical Medibook',
      'cabinetAdresse': '123 Avenue de la Santé, Dakar',
    },
    {
      'id': 9,
      'statut': 'TERMINE',
      'motif': 'Contrôle routine',
      'date': '2026-02-20',
      'heureDebut': '14:00:00',
      'heureFin': '14:30:00',
      'medecinId': 3,
      'medecinNom': 'Dupont',
      'medecinPrenom': 'Jean',
      'medecinSpecialite': 'Médecine Générale',
      'cabinetId': 1,
      'cabinetNom': 'Cabinet Médical Medibook',
      'cabinetAdresse': '123 Avenue de la Santé, Dakar',
    },
    {
      'id': 10,
      'statut': 'ANNULE',
      'motif': 'Consultation dermatologique',
      'date': '2026-02-10',
      'heureDebut': '11:00:00',
      'heureFin': '11:30:00',
      'medecinId': 5,
      'medecinNom': 'Sow',
      'medecinPrenom': 'Amadou',
      'medecinSpecialite': 'Dermatologie',
      'cabinetId': 2,
      'cabinetNom': 'Clinique du Plateau',
      'cabinetAdresse': '45 Rue Carnot, Dakar Plateau',
    },
  ].obs;

  List<Map<String, dynamic>> get tousLesRdv => rendezVous;

  List<Map<String, dynamic>> get rdvEnAttente =>
      rendezVous.where((r) => r['statut'] == 'EN_ATTENTE').toList();

  List<Map<String, dynamic>> get rdvConfirmes =>
      rendezVous.where((r) => r['statut'] == 'CONFIRME').toList();

  List<Map<String, dynamic>> get rdvHistorique => rendezVous
      .where(
          (r) => r['statut'] == 'TERMINE' || r['statut'] == 'ANNULE')
      .toList();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('rdv')) {
        selectedRdv.value = args['rdv'];
      }
    }
    simulateLoading();
  }

  void simulateLoading() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      isLoading.value = false;
    });
  }

  void annulerRdv(int rdvId) {
    final index = rendezVous.indexWhere((r) => r['id'] == rdvId);
    if (index != -1) {
      rendezVous[index] = {...rendezVous[index], 'statut': 'ANNULE'};
      rendezVous.refresh();
      Get.back(); // close dialog
      Get.snackbar(
        Tr.appointmentCancelled.tr,
        Tr.appointmentCancelledMsg.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF43A047),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  bool canCancel(String statut) {
    return statut == 'EN_ATTENTE' || statut == 'CONFIRME';
  }
}
