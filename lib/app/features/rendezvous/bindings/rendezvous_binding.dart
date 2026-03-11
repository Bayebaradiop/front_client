import 'package:get/get.dart';
import '../controllers/rendezvous_controller.dart';

class RendezvousBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RendezvousController>(() => RendezvousController());
  }
}
