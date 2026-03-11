import 'dart:ui';
import 'package:get/get.dart';
import '../../../translate/translation_keys.dart';

class MedecinController extends GetxController {
  final isLoading = false.obs;
  final selectedSpecialiteId = Rxn<int>();
  final selectedCabinetId = Rxn<int>();
  final selectedMedecin = Rxn<Map<String, dynamic>>();

  // Données créneaux pour la page détail
  final selectedDate = DateTime.now().obs;
  final selectedCreneau = Rxn<Map<String, dynamic>>();
  final motifController = ''.obs;
  final isBooking = false.obs;

  final medecins = <Map<String, dynamic>>[
    {
      'id': 3,
      'prenom': 'Jean',
      'nom': 'Dupont',
      'photo': null,
      'telephone': '+221330000002',
      'email': 'jean.dupont@medibook.com',
      'specialiteId': 1,
      'specialiteNom': 'Médecine Générale',
      'cabinetId': 1,
      'cabinetNom': 'Cabinet Médical Medibook',
    },
    {
      'id': 4,
      'prenom': 'Marie',
      'nom': 'Diallo',
      'photo': null,
      'telephone': '+221330000003',
      'email': 'marie.diallo@medibook.com',
      'specialiteId': 2,
      'specialiteNom': 'Cardiologie',
      'cabinetId': 1,
      'cabinetNom': 'Cabinet Médical Medibook',
    },
    {
      'id': 5,
      'prenom': 'Amadou',
      'nom': 'Sow',
      'photo': null,
      'telephone': '+221330000004',
      'email': 'amadou.sow@plateau.com',
      'specialiteId': 3,
      'specialiteNom': 'Dermatologie',
      'cabinetId': 2,
      'cabinetNom': 'Clinique du Plateau',
    },
    {
      'id': 6,
      'prenom': 'Aissatou',
      'nom': 'Ba',
      'photo': null,
      'telephone': '+221330000005',
      'email': 'aissatou.ba@almadies.com',
      'specialiteId': 4,
      'specialiteNom': 'Pédiatrie',
      'cabinetId': 3,
      'cabinetNom': 'Centre Médical Almadies',
    },
  ].obs;

  final specialitesFilter = <Map<String, dynamic>>[
    {'id': null, 'nom': 'Toutes'},
    {'id': 1, 'nom': 'Médecine Générale'},
    {'id': 2, 'nom': 'Cardiologie'},
    {'id': 3, 'nom': 'Dermatologie'},
    {'id': 4, 'nom': 'Pédiatrie'},
  ].obs;

  final creneaux = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get medecinsFiltres {
    return medecins.where((m) {
      if (selectedSpecialiteId.value != null &&
          m['specialiteId'] != selectedSpecialiteId.value) {
        return false;
      }
      if (selectedCabinetId.value != null &&
          m['cabinetId'] != selectedCabinetId.value) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args.containsKey('specialiteId')) {
        selectedSpecialiteId.value = args['specialiteId'];
      }
      if (args.containsKey('cabinetId')) {
        selectedCabinetId.value = args['cabinetId'];
      }
      if (args.containsKey('medecin')) {
        selectedMedecin.value = args['medecin'];
        loadCreneaux();
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

  void filterBySpecialite(int? specialiteId) {
    selectedSpecialiteId.value = specialiteId;
  }

  void selectMedecin(Map<String, dynamic> medecin) {
    selectedMedecin.value = medecin;
    loadCreneaux();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    loadCreneaux();
  }

  void loadCreneaux() {
    final date = selectedDate.value;
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    creneaux.value = [
      {
        'id': 1,
        'date': dateStr,
        'heureDebut': '08:00:00',
        'heureFin': '08:30:00',
        'disponible': true,
        'medecinId': selectedMedecin.value?['id'],
        'medecinNom': selectedMedecin.value?['nom'],
        'medecinPrenom': selectedMedecin.value?['prenom'],
      },
      {
        'id': 2,
        'date': dateStr,
        'heureDebut': '08:30:00',
        'heureFin': '09:00:00',
        'disponible': true,
        'medecinId': selectedMedecin.value?['id'],
        'medecinNom': selectedMedecin.value?['nom'],
        'medecinPrenom': selectedMedecin.value?['prenom'],
      },
      {
        'id': 3,
        'date': dateStr,
        'heureDebut': '09:00:00',
        'heureFin': '09:30:00',
        'disponible': false,
        'medecinId': selectedMedecin.value?['id'],
        'medecinNom': selectedMedecin.value?['nom'],
        'medecinPrenom': selectedMedecin.value?['prenom'],
      },
      {
        'id': 4,
        'date': dateStr,
        'heureDebut': '09:30:00',
        'heureFin': '10:00:00',
        'disponible': true,
        'medecinId': selectedMedecin.value?['id'],
        'medecinNom': selectedMedecin.value?['nom'],
        'medecinPrenom': selectedMedecin.value?['prenom'],
      },
      {
        'id': 5,
        'date': dateStr,
        'heureDebut': '10:00:00',
        'heureFin': '10:30:00',
        'disponible': true,
        'medecinId': selectedMedecin.value?['id'],
        'medecinNom': selectedMedecin.value?['nom'],
        'medecinPrenom': selectedMedecin.value?['prenom'],
      },
      {
        'id': 6,
        'date': dateStr,
        'heureDebut': '10:30:00',
        'heureFin': '11:00:00',
        'disponible': true,
        'medecinId': selectedMedecin.value?['id'],
        'medecinNom': selectedMedecin.value?['nom'],
        'medecinPrenom': selectedMedecin.value?['prenom'],
      },
      {
        'id': 7,
        'date': dateStr,
        'heureDebut': '14:00:00',
        'heureFin': '14:30:00',
        'disponible': true,
        'medecinId': selectedMedecin.value?['id'],
        'medecinNom': selectedMedecin.value?['nom'],
        'medecinPrenom': selectedMedecin.value?['prenom'],
      },
      {
        'id': 8,
        'date': dateStr,
        'heureDebut': '14:30:00',
        'heureFin': '15:00:00',
        'disponible': true,
        'medecinId': selectedMedecin.value?['id'],
        'medecinNom': selectedMedecin.value?['nom'],
        'medecinPrenom': selectedMedecin.value?['prenom'],
      },
    ];
  }

  void selectCreneau(Map<String, dynamic> creneau) {
    if (creneau['disponible'] == true) {
      selectedCreneau.value = creneau;
    }
  }

  void confirmBooking() {
    if (selectedCreneau.value == null) {
      Get.snackbar(
        Tr.error.tr,
        Tr.selectSlotError.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }
    if (motifController.value.isEmpty) {
      Get.snackbar(
        Tr.error.tr,
        Tr.enterReasonError.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }

    isBooking.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isBooking.value = false;
      Get.back();
      Get.snackbar(
        Tr.appointmentConfirmed.tr,
        Tr.appointmentConfirmedMsg.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF43A047),
        colorText: const Color(0xFFFFFFFF),
      );
    });
  }
}
