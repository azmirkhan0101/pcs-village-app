import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/modules/notification/widgets/notification_item_widget.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../data/models/notification/notification_model.dart';
import '../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        toolbarHeight: 100,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Community Feed', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
      // Obx listens to changes in notificationsHelper
      body: Obx(() {
        // 1. INITIAL LOADING STATE
        if (controller.notificationsHelper.isLoading.value && controller.notificationsHelper.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. EMPTY STATE
        if (controller.notificationsHelper.items.isEmpty) {
          return RefreshIndicator(
            backgroundColor: Colors.white,
            color: AppColors.primaryColor,
            onRefresh: () => controller.getNotifications(),
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('No notifications yet', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // 3. DATA LIST + PAGINATION LOADER
        return RefreshIndicator(
          backgroundColor: Colors.white,
          color: AppColors.primaryColor,
          onRefresh: () => controller.getNotifications(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller.notificationScrollController, // Essential for pagination
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: controller.notificationsHelper.items.length +
                (controller.notificationsHelper.isMoreLoading.value ? 1 : 0),
            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
            itemBuilder: (context, index) {
              // Check if we are at the last index to show the bottom loader
              if (index == controller.notificationsHelper.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              final NotificationModel model = controller.notificationsHelper.items[index];
              return NotificationItemWidget(
                  type: model.type,
                  model: model,
                onViewProfile: (){
                    // Get.toNamed(AppRoutes.memberProfile,
                    //   arguments: model.
                    // );
                },
              );
            },
          ),
        );
      }),
    );
  }
}