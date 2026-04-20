import 'package:get/get.dart';
import 'package:pcs_village/modules/post/controllers/report_post_controller.dart';

class ReportPostBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ReportPostController>((){
      return ReportPostController();
    }, fenix: true);

  }
}