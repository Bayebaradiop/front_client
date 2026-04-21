import 'package:get/get.dart';
import '../../../core/utils/error_utils.dart';
import '../../../models/medecin_model.dart';
import '../../../models/creneau_model.dart';
import '../../../translate/translation_keys.dart';
import '../repository/medecin_repository.dart';

class MedecinViewModel extends GetxController {
  final MedecinRepository _repo;

  MedecinViewModel(this._repo);

  final medecins = <MedecinModel>[].obs;
  final selectedMedecin = Rxn<MedecinModel>();
  final disponibilites = <CreneauModel>[].obs;
  final disponibilitesSemaine = <String, List<CreneauModel>>{}.obs;
  final isLoading = false.obs;
  final isLoadingDetail = false.obs;
  final isLoadingDispos = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedecins();
  }

  Future<String?> fetchMedecins({int? specialiteId, int? cabinetId}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final Response response;
      if (specialiteId != null) {
        response = await _repo.getMedecinsBySpecialite(specialiteId);
      } else if (cabinetId != null) {
        response = await _repo.getMedecinsByCabinet(cabinetId);
      } else {
        response = await _repo.getMedecins();
      }

      if (response.statusCode == 200) {
        final raw = response.body is List
            ? response.body
            : (response.body['data'] ?? []);
        final List data = raw is List
            ? raw
            : (raw is Map && raw.containsKey('content')
                  ? List.from(raw['content'])
                  : []);
        medecins.value = data.map((e) => MedecinModel.fromJson(e)).toList();
        return null;
      } else {
        final msg = ErrorUtils.extractApiError(
          response,
          Tr.loadingDoctorsError.tr,
        );
        errorMessage.value = msg;
        return msg;
      }
    } catch (e) {
      final msg = ErrorUtils.handleException(e);
      errorMessage.value = msg;
      return msg;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> fetchMedecinById(int id) async {
    isLoadingDetail.value = true;
    errorMessage.value = '';
    try {
      final response = await _repo.getMedecinById(id);
      if (response.statusCode == 200) {
        final data = response.body is Map
            ? response.body
            : response.body['data'];
        selectedMedecin.value = MedecinModel.fromJson(data);
        return null;
      } else {
        final msg = ErrorUtils.extractApiError(
          response,
          Tr.loadingDoctorError.tr,
        );
        errorMessage.value = msg;
        return msg;
      }
    } catch (e) {
      final msg = ErrorUtils.handleException(e);
      errorMessage.value = msg;
      return msg;
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<String?> fetchDisponibilites(int medecinId, {String? date}) async {
    isLoadingDispos.value = true;
    try {
      final response = await _repo.getDisponibilites(medecinId, date: date);
      if (response.statusCode == 200) {
        final List data = response.body is List
            ? response.body
            : (response.body['data'] ?? []);
        disponibilites.value = data
            .map((e) => CreneauModel.fromJson(e))
            .toList();
        return null;
      } else {
        final msg = ErrorUtils.extractApiError(
          response,
          Tr.loadingSlotsError.tr,
        );
        return msg;
      }
    } catch (e) {
      return ErrorUtils.handleException(e);
    } finally {
      isLoadingDispos.value = false;
    }
  }

  Future<String?> fetchDisponibilitesWeek(
    int medecinId, {
    required DateTime startDate,
  }) async {
    isLoadingDispos.value = true;
    errorMessage.value = '';
    disponibilitesSemaine.clear();

    try {
      final dates = List.generate(
        7,
        (index) =>
            DateTime(startDate.year, startDate.month, startDate.day + index),
      );

      final responses = await Future.wait(
        dates.map(
          (date) => _repo.getDisponibilites(medecinId, date: _formatDate(date)),
        ),
      );

      final weekData = <String, List<CreneauModel>>{};

      for (var index = 0; index < dates.length; index++) {
        final response = responses[index];
        if (response.statusCode != 200) {
          final msg = ErrorUtils.extractApiError(
            response,
            Tr.loadingSlotsError.tr,
          );
          errorMessage.value = msg;
          disponibilitesSemaine.clear();
          return msg;
        }

        final raw = response.body is List
            ? response.body
            : (response.body['data'] ?? []);
        final List data = raw is List ? raw : [];

        weekData[_formatDate(dates[index])] = data
            .map((e) => CreneauModel.fromJson(e))
            .toList();
      }

      disponibilitesSemaine.value = weekData;
      return null;
    } catch (e) {
      final msg = ErrorUtils.handleException(e);
      errorMessage.value = msg;
      disponibilitesSemaine.clear();
      return msg;
    } finally {
      isLoadingDispos.value = false;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
