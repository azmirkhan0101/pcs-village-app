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
import 'package:pcs_village/modules/auth/controllers/forgot_password_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller = Get.find<ForgotPasswordController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                CustomText(text: "Forgot Password").s24.bold,
                const SizedBox(height: 50,),
                // Email Field
                CustomTextField(
                  label: AppStrings.email,
                  hintText: 'email',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if( value == null || !isEmailValid(email: value) ){
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                //==============Get Started Button================
                Center(
                  child: Obx((){
                    return CustomButton(
                      label: AppStrings.cContinue,
                      isLoading: controller.isForgotPasswordLoading.value,
                      onPressed: (){
                        if( _formKey.currentState!.validate() ){
                          controller.sendOtp();
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