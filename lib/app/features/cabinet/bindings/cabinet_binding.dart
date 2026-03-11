import 'package:get/get.dart';
import '../controllers/cabinet_controller.dart';

class CabinetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CabinetController>(() => CabinetController());
  }
}
