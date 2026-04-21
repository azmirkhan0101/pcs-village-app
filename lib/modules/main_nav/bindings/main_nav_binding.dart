import 'package:get/get.dart';
import 'package:pcs_village/modules/message/controllers/conversation_controller.dart';

import '../../groups/controllers/groups_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>((){
      return MainNavController();
    }, fenix: true);
    Get.lazyPut<HomeController>((){
      return HomeController();
    }, fenix: true);
    Get.lazyPut<GroupsController>((){
      return GroupsController();
    }, fenix: true);
    Get.lazyPut<ConversationController>((){
      return ConversationController();
    }, fenix: true);
    // Get.lazyPut<SettingsController>((){
    //   return SettingsController();
    // }, fenix: true);
    Get.lazyPut<ProfileController>((){
      return ProfileController();
    }, fenix: true);
  }

}