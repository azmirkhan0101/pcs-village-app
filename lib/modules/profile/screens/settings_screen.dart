import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/routes/app_pages.dart';

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

          const SizedBox(height: 40), // Spacing below header

          // Settings Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.lock,
                  iconColor: const Color(0xFF1A365D),
                  title: 'Change Password',
                  textColor: const Color(0xFF1A365D),
                  onTap: () {
                    Get.toNamed(AppRoutes.changePassword);
                  },
                ),
                const SizedBox(height: 10),
                _buildSettingsTile(
                  icon: Icons.delete_outline,
                  iconColor: Colors.red,
                  title: 'Delete Account',
                  textColor: Colors.red,
                  onTap: () {
                    // Show delete confirmation
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create the list tiles
  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 28),
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
}