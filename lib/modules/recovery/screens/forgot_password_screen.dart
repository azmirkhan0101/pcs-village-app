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

import '../../../core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if( value == null || value.isEmpty ){
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const Spacer(),
              //==============Get Started Button================
              CustomButton(
                label: AppStrings.cContinue,
                onPressed: (){
                  Get.toNamed(AppRoutes.otpVerificationScreen);
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}