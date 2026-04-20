import 'package:get/get.dart';
import 'package:pcs_village/modules/post/controllers/edit_post_controller.dart';

class EditPostBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<EditPostController>((){
      return EditPostController();
    }, fenix: true);

  }
}