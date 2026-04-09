import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/assets_gen/assets.gen.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/utils/app_validator.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/modules/profile/controllers/settings_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/pin_field_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
   ChangePasswordScreen({super.key});

   final SettingsController controller = Get.find<SettingsController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    controller.setFormKey( formKey );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CustomText(text: "Change Password").s24.bold,
                const SizedBox(height: 50,),
                CustomTextField(
                  label: "Current Password",
                  controller: controller.currentPassword,
                  hintText: "password",
                  isPassword: true,
                  validator: (value){
                    if( value == null || !isPasswordValid(password: controller.currentPassword.text.trim()) ){
                      return "Please enter a valid password.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                CustomTextField(
                  label: "New Password",
                  controller: controller.newPassword,
                  hintText: "password",
                  isPassword: true,
                  validator: (value){
                    if( value == null || !isPasswordValid(password: controller.newPassword.text.trim()) ){
                      return "Please enter a valid password.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                CustomTextField(
                  label: AppStrings.confirmPassword,
                  controller: controller.confirmPassword,
                  hintText: "confirm password",
                  isPassword: true,
                  validator: (value){
                    if( controller.newPassword.text.trim() != controller.confirmPassword.text.trim() ){
                      return "Passwords do not match.";
                    }
                    return null;
                  },
                ),
                const Spacer(),
                //==============Continue Button================
                Obx((){
                  return CustomButton(
                    label: AppStrings.cContinue,
                    isLoading: controller.isChangePasswordLoading.value,
                    onPressed: (){
                      controller.markSubmitted();
                      if( formKey.currentState!.validate() ){
                        controller.changePassword();
                      }
                    },
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}