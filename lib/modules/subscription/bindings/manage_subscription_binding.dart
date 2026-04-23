import 'package:get/get.dart';
import 'package:pcs_village/modules/subscription/controllers/manage_subsciption_controller.dart';

class ManageSubscriptionBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ManageSubscriptionController>(() => ManageSubscriptionController(), fenix: true);
  }
}