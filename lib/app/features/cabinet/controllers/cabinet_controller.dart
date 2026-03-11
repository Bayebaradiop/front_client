import 'package:get/get.dart';

class CabinetController extends GetxController {
  final isLoading = false.obs;
  final selectedCabinet = Rxn<Map<String, dynamic>>();

  final cabinets = <Map<String, dynamic>>[
    {
      'id': 1,
      'nom': 'Cabinet Médical Medibook',
      'adresse': '123 Avenue de la Santé, Dakar',
      'telephone': '+221 33 123 45 67',
      'email': 'contact@medibook.com',
      'couleurPrimaire': '#007bff',
      'couleurSecondaire': '#ffffff',
    },
    {
      'id': 2,
      'nom': 'Clinique du Plateau',
      'adresse': '45 Rue Carnot, Dakar Plateau',
      'telephone': '+221 33 456 78 90',
      'email': 'contact@plateau-clinique.com',
      'couleurPrimaire': '#6f42c1',
      'couleurSecondaire': '#ffffff',
    },
    {
      'id': 3,
      'nom': 'Centre Médical Almadies',
      'adresse': '78 Route des Almadies, Dakar',
      'telephone': '+221 33 789 01 23',
      'email': 'contact@almadies-medical.com',
      'couleurPrimaire': '#e83e8c',
      'couleurSecondaire': '#ffffff',
    },
  ].obs;

  final specialitesDuCabinet = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      selectedCabinet.value = Get.arguments as Map<String, dynamic>;
      loadSpecialites();
    }
    simulateLoading();
  }

  void simulateLoading() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      isLoading.value = false;
    });
  }

  void selectCabinet(Map<String, dynamic> cabinet) {
    selectedCabinet.value = cabinet;
    loadSpecialites();
  }

  void loadSpecialites() {
    specialitesDuCabinet.value = [
      {
        'id': 1,
        'nom': 'Médecine Générale',
        'description': 'Consultations de médecine générale',
        'cabinetId': selectedCabinet.value?['id'],
        'cabinetNom': selectedCabinet.value?['nom'],
      },
      {
        'id': 2,
        'nom': 'Cardiologie',
        'description': 'Soins du cœur et du système cardiovasculaire',
        'cabinetId': selectedCabinet.value?['id'],
        'cabinetNom': selectedCabinet.value?['nom'],
      },
      {
        'id': 3,
        'nom': 'Dermatologie',
        'description': 'Soins de la peau',
        'cabinetId': selectedCabinet.value?['id'],
        'cabinetNom': selectedCabinet.value?['nom'],
      },
    ];
  }
}
