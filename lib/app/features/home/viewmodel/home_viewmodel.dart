import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/error_utils.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/specialite_model.dart';
import '../../../models/medecin_model.dart';
import '../../../models/rendezvous_model.dart';
import '../../../models/auth_model.dart';
import '../repository/home_repository.dart';

class HomeViewModel extends GetxController {
  final HomeRepository _repo;

  HomeViewModel(this._repo);

  final isLoading = false.obs;
  final cabinets = <CabinetModel>[].obs;
  final specialites = <SpecialiteModel>[].obs;
  final medecins = <MedecinModel>[].obs;
  final prochainRdv = Rxn<RendezVousModel>();
  final currentUser = Rxn<AuthModel>();

  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _storage.listenKey('user', (value) {
      if (value != null) {
        currentUser.value =
            AuthModel.fromJson(Map<String, dynamic>.from(value));
      } else {
        currentUser.value = null;
      }
    });
    fetchAll();
  }

  void _loadUser() {
    final data = _storage.read('user');
    if (data != null) {
      currentUser.value =
          AuthModel.fromJson(Map<String, dynamic>.from(data));
    }
  }

  Future<String?> fetchAll() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repo.getCabinets(),
        _repo.getSpecialites(),
        _repo.getRdvConfirmes(),
        _repo.getMedecins(),
      ]);

      // Cabinets
      final rCabinets = results[0];
      if (rCabinets.statusCode == 200) {
        final List data = rCabinets.body is List
            ? rCabinets.body
            : (rCabinets.body['data'] ?? []);
        cabinets.value = data.map((e) => CabinetModel.fromJson(e)).toList();
      }

      // Spécialités
      final rSpecialites = results[1];
      if (rSpecialites.statusCode == 200) {
        final List data = rSpecialites.body is List
            ? rSpecialites.body
            : (rSpecialites.body['data'] ?? []);
        specialites.value =
            data.map((e) => SpecialiteModel.fromJson(e)).toList();
      }

      // Prochain RDV confirmé
      final rRdv = results[2];
      if (rRdv.statusCode == 200) {
        final List data = rRdv.body is List
            ? rRdv.body
            : (rRdv.body['data'] ?? []);
        final rdvList =
            data.map((e) => RendezVousModel.fromJson(e)).toList();
        prochainRdv.value = rdvList.isNotEmpty ? rdvList.first : null;
      }

      // Médecins
      final rMedecins = results[3];
      if (rMedecins.statusCode == 200) {
        final List data = rMedecins.body is List
            ? rMedecins.body
            : (rMedecins.body['data'] ?? []);
        medecins.value =
            data.map((e) => MedecinModel.fromJson(e)).toList();
      }

      return null;
    } catch (e) {
      return ErrorUtils.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }
}
