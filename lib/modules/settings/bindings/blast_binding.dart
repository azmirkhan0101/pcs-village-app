import 'package:get/get.dart';
import 'package:pcs_village/modules/settings/controllers/blast_post_controller.dart';

class BlastBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BlastPostController>(() => BlastPostController(), fenix: true);
  }
}