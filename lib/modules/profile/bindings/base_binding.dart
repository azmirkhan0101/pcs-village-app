import 'package:get/get.dart';
import 'package:pcs_village/modules/profile/controllers/base_request_controller.dart';

class BaseBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BaseRequestController>(() => BaseRequestController(), fenix: true);
  }
}