import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/assets_gen/assets.gen.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/modules/auth/controllers/otp_verify_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/pin_field_widget.dart';

class OtpVerifyScreen extends StatelessWidget {
  OtpVerifyScreen({super.key});

  final OtpVerifyController controller = Get.find<OtpVerifyController>();

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
              CustomText(text: "OTP Verify").s24.bold,
              const SizedBox(height: 50,),
              Center(child: SvgPicture.asset(Assets.icons.otpGraphics)),
              // OTP Input
              PinFieldWidget(
                  controller: controller.otpController, length: 6
              ),

              const SizedBox(height: 10),
              Obx(() {
                return Visibility(
                  visible: controller.isTimerCounting.value,
                  child: Center(
                    child: Text(
                      "00:${controller.seconds.value}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }),
              // Resend Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't get the code?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      if (!controller.isTimerCounting.value) {
                        controller.resendOtp();
                      }
                    },
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                        color: Color(0xFF3B566E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              //==============Continue Button================
              Obx((){
                return CustomButton(
                  label: AppStrings.cContinue,
                  isLoading: controller.isOtpVerifying.value,
                  onPressed: (){
                    if( controller.isSignup ){
                      controller.verifySignupOtp();
                    }else{
                      controller.verifyForgotPasswordOtp();
                    }
                  },
                );
              }),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}