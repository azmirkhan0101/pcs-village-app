import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pcs_village/core/utils/app_colors.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/extensions.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Color constants to match your image
  static const Color _selectedColor = Color(0xFF1A3B5D);
  static const Color _unselectedColor = Color(0xFF6B7B8C);
  static const Color _borderColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _borderColor, width: 1.0),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _selectedColor,
        unselectedItemColor: _unselectedColor,
        elevation: 0,
        selectedFontSize: isTab ? 11.sp : 12,
        unselectedFontSize: isTab ? 11.sp : 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: [
          bottomNavItem(iconAsset: Assets.icons.home, label: 'Home', isTab: isTab),
          bottomNavItem(iconAsset: Assets.icons.group, label: 'Groups', isTab: isTab),
          bottomNavItem(iconAsset: Assets.icons.chat, label: 'Messages', isTab: isTab),
          bottomNavItem(iconAsset: Assets.icons.notification, label: 'Notifications', isTab: isTab),
          bottomNavItem(iconAsset: Assets.icons.profile, label: 'Profile', isTab: isTab),
        ],
      ),
    );
  }

  BottomNavigationBarItem bottomNavItem({
    required String label,
    required String iconAsset,
    required bool isTab
  }) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(
        height: isTab ? 30 : null,
        width: isTab ? 30 : null,
        iconAsset,
        colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
      ),
      icon: SvgPicture.asset(
        height: isTab ? 30 : null,
        width: isTab ? 30 : null,
        iconAsset,
        colorFilter: ColorFilter.mode(AppColors.subtitleTextColor, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}