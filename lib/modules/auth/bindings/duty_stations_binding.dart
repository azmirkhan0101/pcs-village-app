import 'package:get/get.dart';
import 'package:pcs_village/modules/auth/controllers/duty_stations_controller.dart';

class DutyStationsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DutyStationsController>(() => DutyStationsController(), fenix: true);
  }
}