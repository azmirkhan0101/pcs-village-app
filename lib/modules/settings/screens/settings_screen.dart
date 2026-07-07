import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/extensions.dart';
import 'package:pcs_village/modules/settings/controllers/settings_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Blue Header
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, bottom: 40),
            width: double.infinity,
            color: const Color(0xFF1A365D),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Settings Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Obx(() => SwitchListTile(
                  title: Text("Mark as arrived", style: TextStyle(fontSize: isTab ? 12.sp : null),),
                  value: controller.isArrived.value,
                  activeColor: const Color(0xFF000040),
                  onChanged: (bool value) {
                    controller.markAsArrived();
                    controller.isArrived.value = value;
                  },
                )),
                const SizedBox(height: 20,),
                _buildSettingsTile(
                  isTab: isTab,
                  icon: Icons.campaign,
                  title: 'Blast Post',
                  textColor: AppColors.primaryColor,
                  onTap: () {
                    Get.toNamed(AppRoutes.blastPost);
                  },
                ),
                _buildSettingsTile(
                  isTab: isTab,
                  icon: Icons.military_tech,
                  title: 'Base Request',
                  textColor: AppColors.primaryColor,
                  onTap: () {
                    Get.toNamed(AppRoutes.baseRequest);
                  },
                ),
                _buildSettingsTile(
                  isTab: isTab,
                  icon: Icons.workspace_premium,
                  title: 'Manage Subscription',
                  textColor: AppColors.primaryColor,
                  onTap: () {
                    Get.toNamed(AppRoutes.manageSubscription);
                  },
                ),
                _buildSettingsTile(
                  isTab: isTab,
                  icon: Icons.question_answer_rounded,
                  title: 'FAQ',
                  textColor: AppColors.primaryColor,
                  onTap: () {
                    Get.toNamed(AppRoutes.faqScreen);
                  },
                ),
                _buildSettingsTile(
                  isTab: isTab,
                  icon: Icons.lock,
                  title: 'Change Password',
                  textColor: AppColors.primaryColor,
                  onTap: () {
                    Get.toNamed(AppRoutes.changePassword);
                  },
                ),
                const SizedBox(height: 10),
                _buildSettingsTile(
                  isTab: isTab,
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  textColor: Colors.red,
                  onTap: () {
                    controller.showDeleteDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
    required bool isTab
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor, size: isTab ? 40 : 28),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: isTab ? 12.sp : 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey,
        size: isTab ? 40 : 20,
      ),
      onTap: onTap,
    );
  }
}