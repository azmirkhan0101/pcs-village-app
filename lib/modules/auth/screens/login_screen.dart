import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';
import 'package:pcs_village/modules/auth/widgets/social_button.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomText(text: AppStrings.welcomeBack).s24.bold,
            const SizedBox(height: 8),
            CustomText(text: AppStrings.signInToYourAccount, fontColor: AppColors.subtitleTextColor,).s14,
            const SizedBox(height: 40),

            // Email Field
            CustomTextField(
              label: AppStrings.email,
              hintText: 'email',
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if( value == null || value.isEmpty ){
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password Field
            CustomTextField(
              label: AppStrings.password,
              hintText: 'password',
              keyboardType: TextInputType.emailAddress,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: (value){
                if( value == null || value.isEmpty ){
                  return 'Please enter your email';
                }
                return null;
              },
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.forgotPasswordScreen);
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //==================Sign In Button=======================
            CustomButton(
                label: AppStrings.signIn,
                onPressed: () {
                  Get.toNamed(AppRoutes.mainNav);
                }
            ),
            const SizedBox(height: 20),
            // Divider
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('or continue with', style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 30),

            // Social Buttons
            SocialButton(
                label: 'Google',
                iconPath: Assets.icons.google,
                onPressed: (){

            }
            ),
            const SizedBox(height: 10),
            SocialButton(
                label: 'Apple',
                iconPath: Assets.icons.apple,
              onPressed: (){

              }
            ),
            const SizedBox(height: 20),
            //===================Footer==========================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.signupScreen);
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A5F),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}