import 'package:get/get.dart';
import '../../../core/api/api_service.dart';
import '../controllers/cabinet_controller.dart';
import '../repository/cabinet_repository.dart';
import '../viewmodel/cabinet_viewmodel.dart';

class CabinetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<CabinetRepository>(
        () => CabinetRepository(Get.find<ApiService>()));
    Get.lazyPut<CabinetViewModel>(
        () => CabinetViewModel(Get.find<CabinetRepository>()));
    Get.lazyPut<CabinetController>(
        () => CabinetController(Get.find<CabinetViewModel>()));
  }
}
