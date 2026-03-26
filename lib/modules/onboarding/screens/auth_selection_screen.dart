import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/assets_gen/assets.gen.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/routes/app_pages.dart';

class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              //===================Logo and Title Section=================
              Column(
                children: [
                  // Logo Placeholder (Using an Icon for now)
                  SvgPicture.asset(
                    Assets.icons.appLogoZoomed,
                    height: 100.h,
                    width: 100.w,
                  ),
                  const SizedBox(height: 32),
                  CustomText(
                      text: AppStrings.welcomeToPcsVillage
                  ).s24.bold,
                  const SizedBox(height: 12),
                  CustomText(
                      text: AppStrings.yourVillageAtEveryDutyStation,
                    fontColor: AppColors.subtitleTextColor,
                  ).s14,
                ],
              ),

              const Spacer(flex: 1),

              //===================Buttons Section===============
              Column(
                children: [
                  //==============Get Started Button================
                  CustomButton(
                      label: AppStrings.getStarted,
                    onPressed: (){
                        Get.toNamed(AppRoutes.signupScreen);
                    },
                  ),
                  const SizedBox(height: 16),
                  //===============Sign In Button===================
                  CustomButton(
                      label: AppStrings.signIn,
                    backgroundColor: Colors.white,
                    borderWidth: 2,
                    textColor: AppColors.primaryColor,
                    onPressed: (){
                        Get.toNamed(AppRoutes.loginScreen);
                    },
                  )
                ],
              ),

              const Spacer(flex: 2),

              //=================Footer Section================
              CustomText(
                  text: AppStrings.yourVillageAtEveryDutyStation,
                fontColor: AppColors.subtitleTextColor,
              ).s14,
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}