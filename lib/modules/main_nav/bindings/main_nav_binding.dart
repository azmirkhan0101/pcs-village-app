import 'package:get/get.dart';

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
    // Get.lazyPut<NotificationController>((){
    //   return NotificationController();
    // }, fenix: true);
    // Get.lazyPut<SettingsController>((){
    //   return SettingsController();
    // }, fenix: true);
    Get.lazyPut<ProfileController>((){
      return ProfileController();
    }, fenix: true);
  }

}