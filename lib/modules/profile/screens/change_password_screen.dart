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
import '../../../core/widgets/pin_field_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
              CustomText(text: "Change Password").s24.bold,
              const SizedBox(height: 50,),
              CustomTextField(
                label: AppStrings.password,
                hintText: "password",
                isPassword: true,
              ),
              const SizedBox(height: 20,),
              CustomTextField(
                label: AppStrings.confirmPassword,
                hintText: "confirm password",
                isPassword: true,
              ),
              const Spacer(),
              //==============Continue Button================
              CustomButton(
                label: AppStrings.cContinue,
                onPressed: (){
                  //Get.toNamed(AppRoutes.loginScreen);
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