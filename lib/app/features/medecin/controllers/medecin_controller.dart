import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../routes/app_routes.dart';
import '../../../translate/translation_keys.dart';
import '../viewmodel/medecin_viewmodel.dart';
import '../../rendezvous/viewmodel/rendezvous_viewmodel.dart';
import '../../rendezvous/controllers/rendezvous_controller.dart';
import '../../home/controllers/home_controller.dart';

class MedecinController extends GetxController with SnackbarMixin {
  final MedecinViewModel _viewModel;
  final RendezvousViewModel _rdvViewModel;

  MedecinController(this._viewModel, this._rdvViewModel);

  // Indicateurs de chargement
  RxBool get isLoading => _viewModel.isLoading;
  RxBool get isLoadingCreneaux => _viewModel.isLoadingDispos;

  final selectedSpecialiteId = Rxn<int>();
  final selectedCabinetId = Rxn<int>();
  final selectedMedecin = Rxn<Map<String, dynamic>>();
  final today = _normalizeDate(DateTime.now());
  late final Rx<DateTime> weekStart = today.obs;

  // Données créneaux pour la page détail
  final selectedDate = Rxn<DateTime>();
  final selectedCreneau = Rxn<Map<String, dynamic>>();
  final motifController = TextEditingController();
  final isBooking = false.obs;

  // Médecins convertis en Map pour les vues
  final medecins = <Map<String, dynamic>>[].obs;
  final specialitesFilter = <Map<String, dynamic>>[].obs;

  final creneaux = <Map<String, dynamic>>[].obs;
  final creneauxParDate = <String, List<Map<String, dynamic>>>{}.obs;

  List<DateTime> get weekDates =>
      List.generate(7, (index) => weekStart.value.add(Duration(days: index)));

  bool get canGoToPreviousWeek => weekStart.value.isAfter(today);
  bool get hasSlotsThisWeek => weekDates.any(hasSlotsForDate);

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
        _resetBookingState();
        loadWeekCreneaux();
      }
    }
    _loadMedecins();
  }

  @override
  void onClose() {
    motifController.dispose();
    super.onClose();
  }

  Future<void> _loadMedecins() async {
    final error = await _viewModel.fetchMedecins(
      specialiteId: selectedSpecialiteId.value,
      cabinetId: selectedCabinetId.value,
    );
    if (error != null) {
      showError(error);
    } else {
      // Convertir les modèles en Map pour les vues
      medecins.value = _viewModel.medecins
          .map(
            (m) => {
              'id': m.id,
              'prenom': m.prenom ?? '',
              'nom': m.nom ?? '',
              'photo': m.photo,
              'telephone': m.telephone ?? '',
              'email': m.email ?? '',
              'specialiteId': m.specialiteId,
              'specialiteNom': m.specialiteNom ?? '',
              'cabinetId': m.cabinetId,
              'cabinetNom': m.cabinetNom ?? '',
            },
          )
          .toList();
      // Reconstruire les filtres de spécialités depuis les données réelles
      final specs = <Map<String, dynamic>>[
        {'id': null, 'nom': Tr.allFilter.tr},
      ];
      final seen = <int?>{};
      for (final m in _viewModel.medecins) {
        if (!seen.contains(m.specialiteId)) {
          seen.add(m.specialiteId);
          specs.add({'id': m.specialiteId, 'nom': m.specialiteNom ?? ''});
        }
      }
      specialitesFilter.value = specs;
    }
  }

  @override
  Future<void> refresh() async {
    await _loadMedecins();
  }

  void filterBySpecialite(int? specialiteId) {
    selectedSpecialiteId.value = specialiteId;
  }

  void selectMedecin(Map<String, dynamic> medecin) {
    selectedMedecin.value = medecin;
    _resetBookingState();
    loadWeekCreneaux();
  }

  void selectDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    if (!hasSlotsForDate(normalizedDate)) return;

    selectedDate.value = normalizedDate;
    selectedCreneau.value = null;
    _syncSelectedDateSlots();
  }

  Future<void> previousWeek() async {
    if (!canGoToPreviousWeek || isLoadingCreneaux.value) return;

    weekStart.value = weekStart.value.subtract(const Duration(days: 7));
    await loadWeekCreneaux(preserveSelectedDate: false);
  }

  Future<void> nextWeek() async {
    if (isLoadingCreneaux.value) return;

    weekStart.value = weekStart.value.add(const Duration(days: 7));
    await loadWeekCreneaux(preserveSelectedDate: false);
  }

  Future<void> loadWeekCreneaux({bool preserveSelectedDate = true}) async {
    final medecinId = selectedMedecin.value?['id'] as int?;
    if (medecinId == null) return;

    final error = await _viewModel.fetchDisponibilitesWeek(
      medecinId,
      startDate: weekStart.value,
    );
    if (error != null) {
      selectedDate.value = null;
      selectedCreneau.value = null;
      creneaux.clear();
      creneauxParDate.clear();
      showError(error);
      return;
    }

    creneauxParDate.value = _viewModel.disponibilitesSemaine.map(
      (date, slots) => MapEntry(date, slots.map(_toCreneauMap).toList()),
    );

    _syncSelectionForCurrentWeek(preserveSelectedDate: preserveSelectedDate);
  }

  void selectCreneau(Map<String, dynamic> creneau) {
    if (creneau['disponible'] == true) {
      selectedCreneau.value = creneau;
    }
  }

  Future<void> confirmBooking() async {
    final motif = motifController.text.trim();

    if (selectedCreneau.value == null) {
      showError(Tr.selectSlotError.tr);
      return;
    }

    isBooking.value = true;
    final error = await _rdvViewModel.createRdv({
      'creneauId': selectedCreneau.value!['id'],
      'motif': motif.isNotEmpty ? motif : 'Consultation',
    });
    isBooking.value = false;

    if (error != null) {
      showError(error);
      return;
    }

    motifController.clear();
    selectedCreneau.value = null;

    // Retourner à home et afficher l'onglet RDV
    Get.until((route) => route.settings.name == AppRoutes.home);
    Get.find<HomeController>().changeTab(1);
    // Rafraîchir la liste des RDV
    try {
      Get.find<RendezvousController>().refresh();
    } catch (_) {}
    showSuccess(Tr.appointmentConfirmed.tr, Tr.appointmentConfirmedMsg.tr);
  }

  bool hasSlotsForDate(DateTime date) {
    return (creneauxParDate[_formatDate(date)] ?? const []).isNotEmpty;
  }

  bool isSelectedDate(DateTime date) {
    return _isSameDate(selectedDate.value, date);
  }

  void _resetBookingState() {
    weekStart.value = today;
    selectedDate.value = today;
    selectedCreneau.value = null;
    motifController.clear();
    creneaux.clear();
    creneauxParDate.clear();
  }

  void _syncSelectionForCurrentWeek({bool preserveSelectedDate = true}) {
    final currentSelection = selectedDate.value;
    DateTime? nextSelection;

    if (preserveSelectedDate &&
        currentSelection != null &&
        _isDateInCurrentWeek(currentSelection) &&
        hasSlotsForDate(currentSelection)) {
      nextSelection = currentSelection;
    } else {
      nextSelection = _firstAvailableDateInWeek();
    }

    selectedDate.value = nextSelection;
    selectedCreneau.value = null;
    _syncSelectedDateSlots();
  }

  void _syncSelectedDateSlots() {
    final date = selectedDate.value;
    if (date == null) {
      creneaux.clear();
      return;
    }

    creneaux.value = List<Map<String, dynamic>>.from(
      creneauxParDate[_formatDate(date)] ?? const [],
    );
  }

  DateTime? _firstAvailableDateInWeek() {
    for (final date in weekDates) {
      if (hasSlotsForDate(date)) {
        return date;
      }
    }
    return null;
  }

  bool _isDateInCurrentWeek(DateTime date) {
    return weekDates.any((weekDate) => _isSameDate(weekDate, date));
  }

  Map<String, dynamic> _toCreneauMap(dynamic c) {
    return {
      'id': c.id,
      'date': c.date,
      'heureDebut': c.heureDebut,
      'heureFin': c.heureFin,
      'disponible': c.disponible,
      'medecinId': c.medecinId,
      'medecinNom': c.medecinNom,
      'medecinPrenom': c.medecinPrenom,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDate(DateTime? first, DateTime? second) {
    if (first == null || second == null) return false;

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
