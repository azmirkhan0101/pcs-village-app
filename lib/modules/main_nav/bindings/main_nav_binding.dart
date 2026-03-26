import 'package:get/get.dart';

import '../controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>((){
      return MainNavController();
    }, fenix: true);
    // Get.lazyPut<HomeController>((){
    //   return HomeController();
    // }, fenix: true);
    // Get.lazyPut<NotificationController>((){
    //   return NotificationController();
    // }, fenix: true);
    // Get.lazyPut<SettingsController>((){
    //   return SettingsController();
    // }, fenix: true);
    // Get.lazyPut<ProfileController>((){
    //   return ProfileController();
    // }, fenix: true);
  }

}