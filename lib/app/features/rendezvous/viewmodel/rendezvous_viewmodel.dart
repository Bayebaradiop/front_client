import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../models/rendezvous_model.dart';
import '../../../translate/translation_keys.dart';
import '../repository/rendezvous_repository.dart';

class RendezvousViewModel extends GetxController {
  final RendezvousRepository _repo;

  RendezvousViewModel(this._repo);

  final tousLesRdv = <RendezVousModel>[].obs;
  final rdvEnAttente = <RendezVousModel>[].obs;
  final rdvConfirmes = <RendezVousModel>[].obs;
  final rdvHistorique = <RendezVousModel>[].obs;
  final selectedRdv = Rxn<RendezVousModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTousLesRdv();
  }

  Future<String?> fetchTousLesRdv() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _repo.getRdv();
      if (response.statusCode == 200) {
        final List data = response.body is List
            ? response.body
            : (response.body['data'] ?? []);
        tousLesRdv.value =
            data.map((e) => RendezVousModel.fromJson(e)).toList();
        // Dériver les sous-listes depuis la liste complète
        rdvEnAttente.value =
            tousLesRdv.where((r) => r.statut == 'EN_ATTENTE').toList();
        rdvConfirmes.value =
            tousLesRdv.where((r) => r.statut == 'CONFIRME').toList();
        rdvHistorique.value = tousLesRdv
            .where((r) => r.statut == 'ANNULE' || r.statut == 'TERMINE')
            .toList();
        return null;
      } else {
        final msg = response.body?['message'] ?? Tr.loadingAppointmentsError.tr;
        errorMessage.value = msg;
        return msg;
      }
    } catch (e) {
      final msg = Tr.connectionError.tr;
      errorMessage.value = msg;
      return msg;
    } finally {
      isLoading.value = false;
    }
  }


  Future<String?> fetchRdvById(int id) async {
    try {
      final response = await _repo.getRdvById(id);
      if (response.statusCode == 200) {
        final body = response.body;
        final data = (body is Map && body.containsKey('data')) ? body['data'] : body;
        selectedRdv.value = RendezVousModel.fromJson(data);
        return null;
      } else {
        return response.body?['message'] ?? Tr.loadingAppointmentsError.tr;
      }
    } catch (e) {
      return Tr.connectionError.tr;
    }
  }


  Future<String?> createRdv(Map<String, dynamic> body) async {
    try {
      final response = await _repo.createRdv(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchTousLesRdv(); // Rafraîchir la liste
        return null;
      } else {
        return response.body?['message'] ?? Tr.createAppointmentError.tr;
      }
    } catch (e) {
      return Tr.connectionError.tr;
    }
  }


  Future<String?> annulerRdv(int id) async {
    try {
      final response = await _repo.annulerRdv(id);
      debugPrint('annulerRdv status: ${response.statusCode}, body: ${response.body}');
      if (response.statusCode == 200) {
        await fetchTousLesRdv();
        return null;
      } else {
        final body = response.body;
        final msg = (body is Map)
            ? (body['message'] ?? body['error'] ?? Tr.cancelAppointmentError.tr)
            : Tr.cancelAppointmentError.tr;
        return msg.toString();
      }
    } catch (e) {
      return Tr.connectionError.tr;
    }
  }

}
