import 'package:get/get.dart';
import '../../../core/utils/error_utils.dart';
import '../../../models/cabinet_model.dart';
import '../../../models/specialite_model.dart';
import '../../../translate/translation_keys.dart';
import '../repository/cabinet_repository.dart';

class CabinetViewModel extends GetxController {
  final CabinetRepository _repo;

  CabinetViewModel(this._repo);

  final cabinets = <CabinetModel>[].obs;
  final specialitesDuCabinet = <SpecialiteModel>[].obs;
  final isLoading = false.obs;
  final isLoadingSpecialites = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCabinets();
  }

  Future<String?> fetchCabinets() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _repo.getCabinets();
      if (response.statusCode == 200) {
        final raw = response.body is List
            ? response.body
            : (response.body['data'] ?? []);
        final List data = raw is List
            ? raw
            : (raw is Map && raw.containsKey('content') ? List.from(raw['content']) : []);
        cabinets.value = List<CabinetModel>.from(
          data.map((e) => CabinetModel.fromJson(e)),
        );
        return null;
      } else {
        final msg = ErrorUtils.extractApiError(response, Tr.loadingCabinetsError.tr);
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


  Future<String?> fetchSpecialitesByCabinet(int cabinetId) async {
    isLoadingSpecialites.value = true;
    try {
      final response = await _repo.getSpecialitesByCabinet(cabinetId);
      if (response.statusCode == 200) {
        final List data = response.body is List
            ? response.body
            : (response.body['data'] ?? []);
        specialitesDuCabinet.value = List<SpecialiteModel>.from(
          data.map((e) => SpecialiteModel.fromJson(e)),
        );
        return null;
      } else {
        final msg = ErrorUtils.extractApiError(response, Tr.loadingSpecialtiesError.tr);
        return msg;
      }
    } catch (e) {
      return ErrorUtils.handleException(e);
    } finally {
      isLoadingSpecialites.value = false;
    }
  }
}
