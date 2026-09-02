import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/medecin_model.dart';
import '../../../models/specialite_model.dart';
import '../../../models/rendezvous_model.dart';
import '../repository/home_repository.dart';

class HomeViewModel {
  final HomeRepository _repository;
  final GetStorage _storage = GetStorage();

  HomeViewModel(this._repository);

  final isLoading = false.obs;
  final cabinets = <CabinetModel>[].obs;
  final specialites = <SpecialiteModel>[].obs;
  final medecins = <MedecinModel>[].obs;
  final prochainRdv = Rxn<RendezVousModel>();

  bool isUpcoming(RendezVousModel rdv) {
    final statut = (rdv.statut ?? '').toUpperCase();
    if (statut == 'TERMINE' || statut == 'ANNULE') return false;

    final dateStr = rdv.date;
    if (dateStr == null || dateStr.isEmpty) return false;

    final timeStr = (rdv.heureDebut ?? '00:00');
    final formattedTime = timeStr.length >= 5 ? timeStr.substring(0, 5) : '00:00';

    DateTime? rdvDateTime;
    try {
      if (dateStr.contains('T')) {
        rdvDateTime = DateTime.parse(dateStr);
      } else if (dateStr.contains('-')) {
        rdvDateTime = DateTime.parse('${dateStr}T$formattedTime:00');
      } else if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          rdvDateTime = DateTime.parse('${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}T$formattedTime:00');
        }
      }
    } catch (_) {}

    if (rdvDateTime != null) {
      // Un RDV est considéré à venir s'il est dans le futur (ou en cours dans l'heure)
      return rdvDateTime.add(const Duration(hours: 1)).isAfter(DateTime.now());
    }

    return true;
  }

  void loadFromCache() {
    try {
      final cCab = _storage.read('cached_cabinets');
      if (cCab is List && cabinets.isEmpty) {
        cabinets.value = List<CabinetModel>.from(
          cCab.map((e) => CabinetModel.fromJson(Map<String, dynamic>.from(e))),
        );
      }
      final cSpec = _storage.read('cached_specialites');
      if (cSpec is List && specialites.isEmpty) {
        specialites.value = List<SpecialiteModel>.from(
          cSpec.map((e) => SpecialiteModel.fromJson(Map<String, dynamic>.from(e))),
        );
      }
      final cMed = _storage.read('cached_medecins');
      if (cMed is List && medecins.isEmpty) {
        medecins.value = List<MedecinModel>.from(
          cMed.map((e) => MedecinModel.fromJson(Map<String, dynamic>.from(e))),
        );
      }
      final cRdv = _storage.read('cached_prochain_rdv');
      if (cRdv is Map && prochainRdv.value == null) {
        final r = RendezVousModel.fromJson(Map<String, dynamic>.from(cRdv));
        if (isUpcoming(r)) {
          prochainRdv.value = r;
        } else {
          _storage.remove('cached_prochain_rdv');
          prochainRdv.value = null;
        }
      }
    } catch (_) {}
  }

  Future<String?> fetchAll() async {
    // Si nous avons du contenu en cache, ne pas afficher le loader plein écran
    if (cabinets.isEmpty && medecins.isEmpty && specialites.isEmpty) {
      isLoading.value = true;
    }
    try {
      final results = await Future.wait([
        _repository.getCabinets(),
        _repository.getSpecialites(),
        _repository.getRdvConfirmes(),
        _repository.getMedecins(),
      ]);

      // Cabinets
      final rCabinets = results[0];
      if (rCabinets.statusCode == 200) {
        final rawCab = rCabinets.body is List
            ? rCabinets.body
            : (rCabinets.body['data'] ?? []);
        final List dataCab = rawCab is List
            ? rawCab
            : (rawCab is Map && rawCab.containsKey('content')
                ? List.from(rawCab['content'])
                : []);
        cabinets.value = List<CabinetModel>.from(
          dataCab.map((e) => CabinetModel.fromJson(e)),
        );
        _storage.write('cached_cabinets', dataCab);
      }

      // Spécialités
      final rSpecialites = results[1];
      if (rSpecialites.statusCode == 200) {
        final data = rSpecialites.body is List
            ? rSpecialites.body
            : (rSpecialites.body['data'] ?? []);
        specialites.value = List<SpecialiteModel>.from(
          data.map((e) => SpecialiteModel.fromJson(e)),
        );
        _storage.write('cached_specialites', data);
      }

      // Prochain RDV confirmé (filtrer ceux à venir)
      final rRdv = results[2];
      if (rRdv.statusCode == 200) {
        final rawRdv = rRdv.body is List
            ? rRdv.body
            : (rRdv.body['data'] ?? []);
        final List dataRdv = rawRdv is List
            ? rawRdv
            : (rawRdv is Map && rawRdv.containsKey('content')
                ? List.from(rawRdv['content'])
                : []);
        final rdvList = List<RendezVousModel>.from(
          dataRdv
              .map((e) => RendezVousModel.fromJson(e))
              .where((r) => isUpcoming(r)),
        );

        prochainRdv.value = rdvList.isNotEmpty ? rdvList.first : null;
        if (prochainRdv.value != null) {
          _storage.write('cached_prochain_rdv', prochainRdv.value!.toJson());
        } else {
          _storage.remove('cached_prochain_rdv');
        }
      }

      // Médecins
      final rMedecins = results[3];
      if (rMedecins.statusCode == 200) {
        final rawMed = rMedecins.body is List
            ? rMedecins.body
            : (rMedecins.body['data'] ?? []);
        final List dataMed = rawMed is List
            ? rawMed
            : (rawMed is Map && rawMed.containsKey('content')
                ? List.from(rawMed['content'])
                : []);
        medecins.value = List<MedecinModel>.from(
          dataMed.map((e) => MedecinModel.fromJson(e)),
        );
        _storage.write('cached_medecins', dataMed);
      }

      return null;
    } catch (e) {
      return 'Erreur lors du chargement des données: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
