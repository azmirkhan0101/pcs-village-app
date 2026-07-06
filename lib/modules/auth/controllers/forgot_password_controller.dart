import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/show_snackbar.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  TextEditingController emailController = TextEditingController();
  RxBool isForgotPasswordLoading = false.obs;

  //SEND OTP
  Future<void> sendOtp() async{
    if (isForgotPasswordLoading.value) {
      return;
    }

    isForgotPasswordLoading.value = true;
    Map<String, String> payLoad = {
      "email" : emailController.text.trim()
    };
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: false,
        endPoint: ApiEndpoints.otpForgotPassword,
      body: payLoad,
      shouldPrint: true
    );
    isForgotPasswordLoading.value = false;

    String? message = response.data?['message'];

    if( response.statusCode == 200 ){
      showSnackBar(title: "Otp sent", message: message ?? "An otp has been sent to your email.", backgroundColor: AppColors.greenPrimary);
      Map<String, dynamic> arguments = {
        emailKey : emailController.text.trim(),
        isSignupKey : false
      };
      Get.offAndToNamed( AppRoutes.otpVerificationScreen, arguments: arguments );
    }else if( response.statusCode == 400 ){
      showSnackBar(title: "Invalid email!", message: message ?? "Try again with your valid email.", backgroundColor: AppColors.warningYellow);
    }else if( response.statusCode == 404 ){
      showSnackBar(title: "No account found!", message: message ?? "No account found with this email.", backgroundColor: AppColors.warningYellow);
    }else if( response.statusCode == 408 ){
      timeOutSnackBar();
    }else if( response.statusCode == 503 ){
      noInternetSnackBar();
    }else{
      errorSnackBar();
    }
  }

  @override
  void onClose() {

    emailController.dispose();

    super.onClose();
  }
}
