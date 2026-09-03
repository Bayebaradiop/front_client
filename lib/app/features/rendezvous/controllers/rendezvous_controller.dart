import 'package:get/get.dart';
import '../../../core/mixins/snackbar_mixin.dart';
import '../../../translate/translation_keys.dart';
import '../viewmodel/rendezvous_viewmodel.dart';
import '../../home/controllers/home_controller.dart';

class RendezvousController extends GetxController with SnackbarMixin {
  final RendezvousViewModel _viewModel;

  RendezvousController(this._viewModel);

  RxBool get isLoading => _viewModel.isLoading;
  final selectedTabIndex = 0.obs;
  final selectedRdv = Rxn<Map<String, dynamic>>();

  final tousLesRdvObs    = <Map<String, dynamic>>[].obs;
  final rdvEnAttenteObs  = <Map<String, dynamic>>[].obs;
  final rdvConfirmesObs  = <Map<String, dynamic>>[].obs;
  final rdvHistoriqueObs = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get rendezVous    => tousLesRdvObs;
  List<Map<String, dynamic>> get tousLesRdv    => tousLesRdvObs;
  List<Map<String, dynamic>> get rdvEnAttente  => rdvEnAttenteObs;
  List<Map<String, dynamic>> get rdvConfirmes  => rdvConfirmesObs;
  List<Map<String, dynamic>> get rdvHistorique => rdvHistoriqueObs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('rdv')) {
        selectedRdv.value = args['rdv'];
      }
    }
    _loadRdv();
  }

  Future<void> _loadRdv() async {
    final error = await _viewModel.fetchTousLesRdv();
    if (error != null) {
      showError(error);
      return;
    }
    _syncLists();
  }

  void _syncLists() {
    Map<String, dynamic> toMap(r) => {
          'id': r.id,
          'statut': r.statut,
          'motif': r.motif,
          'date': r.date,
          'heureDebut': r.heureDebut,
          'heureFin': r.heureFin,
          'medecinId': r.medecinId,
          'medecinNom': r.medecinNom,
          'medecinPrenom': r.medecinPrenom,
          'medecinSpecialite': r.medecinSpecialite,
          'medecinPhoto': r.medecinPhoto,
          'cabinetId': r.cabinetId,
          'cabinetNom': r.cabinetNom,
          'cabinetAdresse': r.cabinetAdresse,
        };
    tousLesRdvObs.value    = _viewModel.tousLesRdv.map(toMap).toList();
    rdvEnAttenteObs.value  = _viewModel.rdvEnAttente.map(toMap).toList();
    rdvConfirmesObs.value  = _viewModel.rdvConfirmes.map(toMap).toList();
    rdvHistoriqueObs.value = _viewModel.rdvHistorique.map(toMap).toList();
  }


  Future<void> refresh() async => await _loadRdv();

  Future<void> loadRdvDetail(int rdvId) async {
    final error = await _viewModel.fetchRdvById(rdvId);
    if (error != null) return;
    final r = _viewModel.selectedRdv.value;
    if (r != null) {
      selectedRdv.value = {
        'id': r.id,
        'statut': r.statut,
        'motif': r.motif,
        'date': r.date,
        'heureDebut': r.heureDebut,
        'heureFin': r.heureFin,
        'medecinId': r.medecinId,
        'medecinNom': r.medecinNom,
        'medecinPrenom': r.medecinPrenom,
        'medecinSpecialite': r.medecinSpecialite,
        'medecinPhoto': r.medecinPhoto,
        'cabinetId': r.cabinetId,
        'cabinetNom': r.cabinetNom,
        'cabinetAdresse': r.cabinetAdresse,
      };
    }
  }

  Future<void> annulerRdv(int rdvId) async {
    final error = await _viewModel.annulerRdv(rdvId);
    if (error != null) {
      showError(error);
      return;
    }
    _syncLists();
    if (selectedRdv.value?['id'] == rdvId) {
      selectedRdv.value = {...selectedRdv.value!, 'statut': 'ANNULE'};
    }
    try {
      Get.find<HomeController>().refresh();
    } catch (_) {}
    showSuccess(Tr.appointmentCancelled.tr, Tr.appointmentCancelledMsg.tr);
  }

  bool canCancel(String statut) {
    return statut == 'EN_ATTENTE' || statut == 'CONFIRME';
  }
}
