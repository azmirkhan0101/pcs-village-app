import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcs_village/core/utils/extensions.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_text.dart';

class SocialButton extends StatelessWidget {

  final String label;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialButton({super.key, required this.label, required this.iconPath, required this.onPressed});

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return SizedBox(
        width: isTab ? context.fullWidth * 0.4 : double.infinity,
        height: 56,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: SvgPicture.asset(iconPath),
          label: CustomText(text: label, fontColor: AppColors.primaryColor,).w600,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.greyEB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      );
    }
}
