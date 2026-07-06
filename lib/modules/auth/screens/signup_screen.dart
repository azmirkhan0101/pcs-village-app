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
import 'package:pcs_village/modules/auth/controllers/signup_controller.dart';
import 'package:pcs_village/modules/auth/widgets/social_button.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> singupFormKey = GlobalKey<FormState>();

  final SignupController controller = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {

    controller.setFormKey(singupFormKey);
    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: singupFormKey,
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
                controller: controller.nameController,
                validator: (value){
                  if( value == null || value.isEmpty ){
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                label: AppStrings.email,
                controller: controller.emailController,
                hintText: "email",
                validator: (value){
                  if( value != null && isEmailValid(email: value) ){
                    return null;
                  }
                  return "Please enter a valid email";
                },
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                label: AppStrings.password,
                controller: controller.passwordController,
                hintText: "password",
                isPassword: true,
                validator: (value){
                  if( value == null || !isPasswordValid(password: value) ){
                    return "Please enter a valid password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                label: AppStrings.confirmPassword,
                controller: controller.confirmPasswordController,
                hintText: "confirm password",
                isPassword: true,
                validator: (value){
                  if( controller.confirmPasswordController.text.trim() != controller.passwordController.text.trim() ){
                    return "passwords do not match";
                  }
                  return null;
                },
              ),
          
              const SizedBox(height: 24),
          
              // Continue Button
              Center(
                child: CustomButton(
                    label: AppStrings.cContinue,
                  onPressed: (){
                    controller.markSubmitted();
                    if( singupFormKey.currentState!.validate() ){
                      Get.toNamed(AppRoutes.signupStepOneScreen);
                    }
                  },
                ),
              ),
          
              const SizedBox(height: 32),
          
              // Divider
               Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or continue with', style: TextStyle(color: Colors.grey, fontSize: isTab ? 10.sp : null)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
          
              const SizedBox(height: 24),
          
              //=================Social Buttons===================
              Center(
                child: SocialButton(
                  label: AppStrings.google,
                  iconPath: Assets.icons.google,
                  onPressed: (){

                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SocialButton(
                  label: AppStrings.apple,
                  iconPath: Assets.icons.apple,
                  onPressed: (){

                  },
                ),
              ),
          
              const SizedBox(height: 32),
          
              // Sign In Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text('Already have an account? ', style: TextStyle(fontSize: isTab ? 12.sp : null),),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.loginScreen);
                      },
                      child:  Text(
                        'Sign In',
                        style: TextStyle(color: Color(0xFF1D3557), fontWeight: FontWeight.bold, fontSize: isTab ? 12.sp : null),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

}