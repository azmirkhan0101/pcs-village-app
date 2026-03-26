import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';
import 'package:pcs_village/modules/auth/widgets/social_button.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: AppStrings.createAccount).s24.w700,
            const SizedBox(height: 8),
            CustomText(text: AppStrings.joinThePcsVillage, fontColor: AppColors.subtitleTextColor,).s14,
            const SizedBox(height: 32),

            // Input Fields
            CustomTextField(
              label: AppStrings.fullName,
              hintText: AppStrings.yourName,
            ),
            const SizedBox(height: 10,),
            CustomTextField(
              label: AppStrings.email,
              hintText: "email",
            ),
            const SizedBox(height: 10,),
            CustomTextField(
              label: AppStrings.password,
              hintText: "password",
              isPassword: true,
            ),
            const SizedBox(height: 10,),
            CustomTextField(
              label: AppStrings.confirmPassword,
              hintText: "confirm password",
              isPassword: true,
            ),

            const SizedBox(height: 24),

            // Continue Button
            CustomButton(
                label: AppStrings.cContinue,
              onPressed: (){
                  Get.toNamed(AppRoutes.signupStepOneScreen);
              },
            ),

            const SizedBox(height: 32),

            // Divider
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('or continue with', style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            //=================Social Buttons===================
            SocialButton(
              label: AppStrings.google,
              iconPath: Assets.icons.google,
              onPressed: (){

              },
            ),
            const SizedBox(height: 16),
            SocialButton(
              label: AppStrings.apple,
              iconPath: Assets.icons.apple,
              onPressed: (){

              },
            ),

            const SizedBox(height: 32),

            // Sign In Link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.loginScreen);
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Color(0xFF1D3557), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

}