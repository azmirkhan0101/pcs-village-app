import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/show_snackbar.dart';
import '../../../routes/app_pages.dart';

class OtpVerifyController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();

  final storage = GetStorage();

  late String email;
  late bool isSignup;
  late bool isLogin;//FOR LOGIN ATTEMPT WITHOUT VERIFICATION

  @override
  void onInit() {
    email = Get.arguments[emailKey];
    isSignup = Get.arguments[isSignupKey];
    isLogin = (Get.arguments?[isLoginKey] as bool?) ?? false;

    if( isLogin ){
      resendOtp();
    }
    startTimer();
    super.onInit();
  }

  RxBool isOtpVerifying = false.obs;
  Timer? timer;
  RxInt seconds = 60.obs;
  RxBool isTimerCounting = true.obs;

  final TextEditingController otpController = TextEditingController();

  //TIMER
  void startTimer(){
    isTimerCounting.value = true;
    timer?.cancel();
    seconds.value = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timer2) {
      if( seconds.value > 0 ){
        seconds--;
      }else{
        timer?.cancel();
        isTimerCounting.value = false;
      }
    });
  }


  //VERIFY SIGNUP OTP
  Future<void> verifySignupOtp() async{

    if( isOtpVerifying.value ){
      return;
    }

    if( otpController.text.trim().isEmpty || otpController.text.trim().length < 6 ){
      showSnackBar(title: "OTP required!", message: "Please enter the otp and try again.", backgroundColor: AppColors.warningYellow);
      return;
    }

    isOtpVerifying.value = true;
    Map<String, String> payLoad = {
      "email": email,
      "otp": otpController.text.trim()
    };
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: false,
        endPoint: ApiEndpoints.verifySignupOtp,
      body: payLoad
    );
    isOtpVerifying.value = false;

    String? message = response.data?['message'];

    if( response.statusCode == 200 ){
      showSnackBar(title: "Otp verified!", message: message ?? "Otp verified successfully.", backgroundColor: AppColors.greenPrimary);
      Get.offAllNamed( AppRoutes.loginScreen );
    }else if( response.statusCode == 400 ){
      showSnackBar(title: "OTP required", message: message ?? "Please enter the otp and try again.", backgroundColor: AppColors.warningYellow);
    }else if( response.statusCode == 401 || response.statusCode == 404 ){
      showSnackBar(title: "Invalid otp!", message: message ?? "Try again with your valid otp.", backgroundColor: AppColors.errorRed);
    }else if( response.statusCode == 423 ){//NOT APPROVED BY ADMIN
      //Get.offAndToNamed( AppRoutes.accountApproval );
      showSnackBar(title: "Not approved!", message: message ?? "Your account is not approved by admin.", backgroundColor: AppColors.warningYellow);
    }else if( response.statusCode == 408 ){
      timeOutSnackBar();
    }else if( response.statusCode == 503 ){
      noInternetSnackBar();
    }else{
      errorSnackBar();
    }
  }


  //VERIFY FORGOT PASSWORD OTP
Future<void> verifyForgotPasswordOtp() async{
  
  if( isOtpVerifying.value ){
    return;
  }

  if( otpController.text.trim().isEmpty || otpController.text.trim().length < 6 ){
    showSnackBar(title: "OTP required!", message: "Please enter the otp and try again.", backgroundColor: AppColors.warningYellow);
    return;
  }

  isOtpVerifying.value = true;
  Map<String, String> payLoad = {
    "email": email,
    "otp": otpController.text.trim()
  };
  ApiResponse response = await apiService.networkRequest(
      method: "POST",
      isAuthRequired: false,
      endPoint: ApiEndpoints.otpVerifyForgotPassword,
    body: payLoad
  );
  isOtpVerifying.value = false;

  String? message = response.data?['message'];

  if( response.statusCode == 200 ){
    showSnackBar(title: "Otp verified!", message: message ?? "Otp verified successfully.", backgroundColor: AppColors.greenPrimary);
    String resetToken = response.data['data']['resetToken'];
    Get.offAndToNamed(
        AppRoutes.resetPasswordScreen,
        arguments: {
          resetTokenKey : resetToken
        }
    );
  }else if( response.statusCode == 400 ){
    showSnackBar(title: "Attention!", message: message ?? "Please enter the otp and try again.", backgroundColor: AppColors.warningYellow);
  }else if( response.statusCode == 401 || response.statusCode == 404 ){
    showSnackBar(title: "Invalid otp!", message: message ?? "Try again with your valid otp.", backgroundColor: AppColors.errorRed);
  }else if( response.statusCode == 408 ){
    timeOutSnackBar();
  }else if( response.statusCode == 503 ){
    noInternetSnackBar();
  }else{
    errorSnackBar();
  }
}

//SEND OTP
  Future<void> resendOtp() async{

    otpController.clear();

    Map<String, String> payLoad = {
      "email" : email
    };
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: false,
        endPoint: isSignup || isLogin ? ApiEndpoints.otpResend : ApiEndpoints.otpForgotPassword,
      body: payLoad
    );

    String? message = response.data?['message'];

    if( response.statusCode == 200 ){
      showSnackBar(title: "Otp sent", message: message ?? "An otp has been sent to your email.", backgroundColor: AppColors.greenPrimary);
      startTimer();
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
}