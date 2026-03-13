import 'package:get/get.dart';
import '../../../core/api/api_service.dart';
import '../controllers/rendezvous_controller.dart';
import '../repository/rendezvous_repository.dart';
import '../viewmodel/rendezvous_viewmodel.dart';

class RendezvousBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<RendezvousRepository>(
        () => RendezvousRepository(Get.find<ApiService>()));
    Get.lazyPut<RendezvousViewModel>(
        () => RendezvousViewModel(Get.find<RendezvousRepository>()));
    Get.lazyPut<RendezvousController>(
        () => RendezvousController(Get.find<RendezvousViewModel>()));
  }
}
