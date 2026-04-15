import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Blue Header
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, bottom: 40),
            width: double.infinity,
            color: const Color(0xFF1A365D), // Dark navy blue color
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
                _buildSettingsTile(
                  icon: Icons.question_answer_rounded,
                  title: 'FAQ',
                  textColor: AppColors.primaryColor,
                  onTap: () {
                    Get.toNamed(AppRoutes.faqScreen);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  textColor: AppColors.primaryColor,
                  onTap: () {
                    Get.toNamed(AppRoutes.changePassword);
                  },
                ),
                const SizedBox(height: 10),
                _buildSettingsTile(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  textColor: Colors.red,
                  onTap: () {
                    showDeleteDialog();
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
    required VoidCallback onTap
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor, size: 28),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Future<void> showDeleteDialog() async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.greyB2,
          content: Column(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.destructiveRed,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.exit_to_app, color: AppColors.white, fontWeight: FontWeight.bold, size: 28,),
                ),
              ),
              const CustomText(
                text: "Delete account",
                fontColor: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              const CustomText(
                text: "Do you want to delete your account?",
                fontColor: AppColors.grey4E,
                fontSize: 14,
              )
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            Row(
              spacing: 4,
              children: [
                Expanded(
                  child: CustomButton(
                    buttonHeight: 40,
                    label: "Cancel",
                    fontSize: 14,
                    backgroundColor: Colors.blue.shade700,
                    onPressed: (){
                      Get.back();
                    },
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    buttonHeight: 40,
                    label: "Delete",
                    fontSize: 14,
                    backgroundColor: Colors.red.shade700,
                    onPressed: (){
                      //controller.deleteAccount();
                    },
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}