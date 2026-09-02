import 'package:get/get.dart';
import '../../../core/api/api_service.dart';
import '../controllers/home_controller.dart';
import '../repository/home_repository.dart';
import '../viewmodel/home_viewmodel.dart';
import '../../rendezvous/repository/rendezvous_repository.dart';
import '../../rendezvous/viewmodel/rendezvous_viewmodel.dart';
import '../../rendezvous/controllers/rendezvous_controller.dart';
import '../../auth/bindings/auth_binding.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    AuthBinding().dependencies();
    Get.lazyPut<HomeRepository>(
        () => HomeRepository(Get.find<ApiService>()));
    Get.lazyPut<HomeViewModel>(
        () => HomeViewModel(Get.find<HomeRepository>()));
    Get.lazyPut<HomeController>(
        () => HomeController(Get.find<HomeViewModel>()));
    // Nécessaire car MesRdvView(embedded: true) est inclus dans HomeView
    Get.lazyPut<RendezvousRepository>(
        () => RendezvousRepository(Get.find<ApiService>()));
    Get.lazyPut<RendezvousViewModel>(
        () => RendezvousViewModel(Get.find<RendezvousRepository>()));
    Get.lazyPut<RendezvousController>(
        () => RendezvousController(Get.find<RendezvousViewModel>()));
  }
}
