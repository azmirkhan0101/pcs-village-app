import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/utils/app_validator.dart';
import 'package:pcs_village/core/utils/extensions.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';
import 'package:pcs_village/modules/auth/controllers/login_controller.dart';
import 'package:pcs_village/modules/auth/widgets/social_button.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.find<LoginController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    controller.setFormKey(formKey);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              CustomText(text: AppStrings.welcomeBack).s24.bold,
              const SizedBox(height: 8),
              CustomText(
                text: AppStrings.signInToYourAccount,
                fontColor: AppColors.subtitleTextColor,
              ).s14,
              const SizedBox(height: 40),

              // Email Field
              CustomTextField(
                label: AppStrings.email,
                hintText: 'email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      !isEmailValid(
                        email: controller.emailController.text.trim(),
                      )) {
                    return 'Please enter your valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password Field
              CustomTextField(
                label: AppStrings.password,
                hintText: 'password',
                controller: controller.passwordController,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null ||
                      !isPasswordValid(
                        password: controller.passwordController.text.trim(),
                      )) {
                    return 'Please enter valid password';
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
                  child:  Text(
                    'Forgot password?',
                    style: TextStyle(color: AppColors.primaryColor, fontSize: isTab ? 12.sp :null),
                  ),
                ),
              ),
               SizedBox(height: isTab ? 30 : 10),
              //==================Sign In Button=======================
              Center(
                child: Obx(() {
                  return CustomButton(
                    isLoading: controller.isLoginLoading.value,
                    label: AppStrings.signIn,
                    onPressed: () {
                      controller.markSubmitted();
                      if (formKey.currentState!.validate()) {
                        controller.login();
                      }
                    },
                  );
                }),
              ),
               SizedBox(height: isTab ? 40 : 20),
              // Divider
              Row(
                children:  [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: Colors.grey, fontSize: isTab ? 10.sp : null),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 30),

              // Social Buttons
              Center(
                child: SocialButton(
                  label: 'Google',
                  iconPath: Assets.icons.google,
                  onPressed: () {},
                ),
              ),
               SizedBox(height: isTab ? 30 : 10),
              Center(
                child: SocialButton(
                  label: 'Apple',
                  iconPath: Assets.icons.apple,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              //===================Footer==========================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Don't have an account? ", style: TextStyle(fontSize: isTab ? 12.sp : null),),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.signupScreen);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: isTab ? 12.sp : null,
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
      ),
    );
  }
}
