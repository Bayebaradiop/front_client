import 'package:get/get.dart';

class SpecialiteController extends GetxController {
  final isLoading = false.obs;

  final specialites = <Map<String, dynamic>>[
    {
      'id': 1,
      'nom': 'Médecine Générale',
      'description': 'Consultations de médecine générale',
      'cabinetId': 1,
      'cabinetNom': 'Cabinet Médical Medibook',
    },
    {
      'id': 2,
      'nom': 'Cardiologie',
      'description': 'Soins du cœur et du système cardiovasculaire',
      'cabinetId': 1,
      'cabinetNom': 'Cabinet Médical Medibook',
    },
    {
      'id': 3,
      'nom': 'Dermatologie',
      'description': 'Soins de la peau et des muqueuses',
      'cabinetId': 2,
      'cabinetNom': 'Clinique du Plateau',
    },
    {
      'id': 4,
      'nom': 'Pédiatrie',
      'description': 'Médecine des enfants et adolescents',
      'cabinetId': 2,
      'cabinetNom': 'Clinique du Plateau',
    },
    {
      'id': 5,
      'nom': 'Ophtalmologie',
      'description': 'Soins des yeux et de la vision',
      'cabinetId': 3,
      'cabinetNom': 'Centre Médical Almadies',
    },
    {
      'id': 6,
      'nom': 'Dentisterie',
      'description': 'Soins dentaires et buccaux',
      'cabinetId': 3,
      'cabinetNom': 'Centre Médical Almadies',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    simulateLoading();
  }

  void simulateLoading() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      isLoading.value = false;
    });
  }
}
