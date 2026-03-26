import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/modules/groups/screens/groups_screen.dart';
import 'package:pcs_village/modules/message/screens/message_screen.dart';

import '../../../core/utils/app_colors.dart';
import '../../home/screens/home_screen.dart';
import '../../notification/screens/notification_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../controllers/main_nav_controller.dart';
import '../widgets/custom_bottom_nav.dart';

class MainNavScreen extends GetView<MainNavController> {
  const MainNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Obx((){
          return IndexedStack(
            index: controller.currentIndex.value,
            children: [
              HomeScreen(),
              GroupsScreen(),
              MessageScreen(),
              NotificationScreen(),
              ProfileScreen()
            ],
          );
        }),
        bottomNavigationBar: Obx((){
          return CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.currentIndex.value = index;
            },
          );
        }),
    );
  }
}