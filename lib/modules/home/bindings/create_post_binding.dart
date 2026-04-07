import 'package:get/get.dart';
import 'package:pcs_village/modules/home/controllers/create_post_controller.dart';

class CreatePostBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CreatePostController>((){
      return CreatePostController();
    }, fenix: true);

  }
}