import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/assets_gen/assets.gen.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/utils/app_validator.dart';
import 'package:pcs_village/core/utils/extensions.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/modules/auth/controllers/reset_password_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/pin_field_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController controller = Get.find<ResetPasswordController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    controller.setFormKey( _formKey );

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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CustomText(text: "Reset Password").s24.bold,
                const SizedBox(height: 50,),
                CustomTextField(
                  label: AppStrings.password,
                  hintText: "password",
                  controller: controller.passwordController,
                  isPassword: true,
                  validator: (value){
                    if( value == null || !isPasswordValid(password: controller.passwordController.text.trim()) ){
                      return "enter valid password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                CustomTextField(
                  label: AppStrings.confirmPassword,
                  hintText: "confirm password",
                  controller: controller.confirmPasswordController,
                  isPassword: true,
                  validator: (value){
                    if( controller.passwordController.text.trim() != controller.confirmPasswordController.text.trim() ){
                      return "passwords do not match";
                    }
                    return null;
                  },
                ),
                const Spacer(),
                //==============Continue Button================
                Center(
                  child: Obx((){
                    return CustomButton(
                      label: AppStrings.cContinue,
                      isLoading: controller.isPasswordChanging.value,
                      onPressed: (){
                        controller.markSubmitted();
                        if( _formKey.currentState!.validate() ){
                          controller.resetPassword();
                        }
                      },
                    );
                  }),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}