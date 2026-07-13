import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_validator.dart';
import '../../../core/utils/show_snackbar.dart';

class LoginController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();
  RxBool isLoginLoading = false.obs;

  @override
  void onInit() {

    emailController.addListener( _onTextChanged );
    passwordController.addListener( _onTextChanged );

    super.onInit();
  }

  GlobalKey<FormState>? _formKey;
  bool _hasSubmitted = false;

  void setFormKey(GlobalKey<FormState> key) {
    _formKey = key;
  }

  void markSubmitted() {
    _hasSubmitted = true;
    _formKey?.currentState?.validate();
  }

  void _onTextChanged(){
    if( _formKey != null && _hasSubmitted ){
      _formKey!.currentState!.validate();
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //VALIDATE EMAIL PASSWORD AND THEN LOGIN -> if verified -> go to home -> else -> go to verified screen
  Future<void> login() async {
    if (isLoginLoading.value) {
      return;
    }

    if (!isEmailValid(email: emailController.text.trim()) ||
        !isPasswordValid(password: passwordController.text.trim())) {
      incorrectCredentialsSnackBar();
      return;
    }

    isLoginLoading.value = true;
    Map<String, dynamic> credentials = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };
    ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: false,
      endPoint: ApiEndpoints.login,
      body: credentials
    );

    String? message = response.data?['message'];

    if (response.statusCode == 200) {
      //LOGIN SUCCESSFUL
      Map<String, dynamic> responseData = response.data;
      saveOtpResponse(responseData);
      ProfileController profileController = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>() : Get.put(ProfileController());
      profileController.getProfile();
      Get.offAllNamed(AppRoutes.mainNav);
    } else if (response.statusCode == 400) {
      //ACCOUNT FOUND, BUT NOT VERIFIED
      isLoginLoading.value = false;

      if( message != null && message.contains("Credential not matched") ){
        showSnackBar(
            title: "Attention",
            message: message,
            backgroundColor: AppColors.warningYellow
        );
        return;
      }

      showSnackBar(
        title: "Attention!",
        message: message ?? "Verify your account using the OTP sent to your email.",
        backgroundColor: AppColors.warningYellow,
        textColor: AppColors.black,
      );
      storage.write(
        emailKey,
        emailController.text.trim(),
      ); //SAVE EMAIL FOR VERIFY NOW SCREEN
      Get.offNamed(
        AppRoutes.otpVerificationScreen,
        arguments: {
          emailKey: emailController.text.trim(),
          isSignupKey: false,
          isLoginKey: true
        }
      );
    } else if (response.statusCode == 401) {
      //WRONG PASSWORD
      isLoginLoading.value = false;
      showSnackBar(
        title: "Attention!",
        message: message ?? "The password you entered is incorrect.",
        backgroundColor: AppColors.errorRed,
      );
    } else if (response.statusCode == 404) {
      //NO ACCOUNT FOUND IN THAT EMAIL
      isLoginLoading.value = false;
      showSnackBar(
        title: "Attention!",
        message:
            message ??
            "No account found matching this email. Try creating an account.",
        backgroundColor: AppColors.warningYellow
      );
    } else {
      isLoginLoading.value = false;
      showSnackBar(
        title: "Login Failed!",
        message: "Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //UPDATE FCM TOKEN
  // updateFcmToken() async {
  //   String deviceType = "android";
  //   late String? token;
  //
  //   // Detect the device type
  //   if (Platform.isAndroid) {
  //     deviceType = 'android';
  //     token = await FirebaseMessaging.instance.getToken();
  //   } else {
  //     deviceType = 'ios';
  //     token = await FirebaseMessaging.instance.getAPNSToken();
  //   }
  //
  //   final payLoad = {"fcmToken": token, "deviceType": deviceType};
  //
  //   ApiResponse response = await apiService.networkRequest(
  //     method: 'PATCH',
  //     isAuthRequired: true,
  //     endPoint: ApiEndpoints.updateFcmToken,
  //     body: payLoad
  //   );
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     //GET PROFILE AND GO TO MAIN -> HOME
  //     getProfileData();
  //   } else {
  //     isLoginLoading.value = false;
  //     storage.erase();
  //     showSnackBar(
  //       title: "Something went wrong!",
  //       message: "Please try again.",
  //       backgroundColor: AppColors.errorRed,
  //     );
  //   }
  // }

  //GET PROFILE DATA USING TOKEN AFTER LOGIN SUCCESS
  // getProfileData() async {
  //
  //   ApiResponse response = await apiService.networkRequest(
  //       method: 'GET',
  //       isAuthRequired: true,
  //       endPoint: ApiEndpoints.getProfile
  //   );
  //
  //   isLoginLoading.value = false;
  //
  //   if (response.statusCode == 200) {
  //     storage.write(requireVerificationKey, false);
  //     //FETCHED PROFILE DATA
  //     BusinessProfileModel model = BusinessProfileModel.fromJson(
  //         response.data['data']
  //     );
  //     //SAVE PROFILE DATA IN STORAGE
  //     storage.write(businessProfileModelKey, model.toJson());
  //     storage.write(
  //         businessIdKey,
  //         model.businessId
  //     ); //SAVING ID SEPARATELY FOR RETRIEVING EASILY, ALSO AVAILABLE IN MODEL
  //     storage.write(
  //         businessAuthIdKey,
  //         model.businessAuthId
  //     ); //SAVING AUTH ID SEPARATELY FOR RETRIEVING EASILY, ALSO AVAILABLE IN MODEL
  //     //GO TO MAIN -> HOME -> GET HOME DATA, ANALYTICS THERE
  //     bool isSubscribed = model.isSubscribed ?? false;
  //     storage.write(subscriptionKey, isSubscribed);
  //     storage.write(subscriptionExpiryDateKey, model.subscriptionExpiryDate);
  //     if (isSubscribed) {
  //       showSnackBar(
  //         title: "Logged in!",
  //         message: "You have successfully logged in.",
  //         backgroundColor: AppColors.successGreen,
  //       );
  //       Get.offAllNamed(AppRoutes.mainNav);
  //     } else {
  //       showSnackBar(
  //         title: "Subscription Required!",
  //         message: "You need to subscribe to continue.",
  //         backgroundColor: AppColors.successGreen,
  //       );
  //       bool isAndroid = Platform.isAndroid;
  //       if( isAndroid ){
  //         Get.offAllNamed(AppRoutes.androidSubscription);
  //       }else{
  //         Get.offAllNamed(AppRoutes.iosSubscription);
  //       }
  //     }
  //   } else if (response.statusCode == 401) {
  //     storage.erase();
  //     //ACCESS TOKEN INVALID
  //     showSnackBar(
  //       title: "Session Expired!",
  //       message: "Please try again.",
  //       backgroundColor: AppColors.errorRed,
  //     );
  //   } else {
  //     storage.erase();
  //     showSnackBar(
  //       title: "Error!",
  //       message: "Something went wrong. Please try again",
  //       backgroundColor: AppColors.errorRed,
  //     );
  //   }
  // }

  //SAVE TOKENS IN STORAGE
  void saveOtpResponse(Map<String, dynamic> response) {
    final accessToken = response["data"]["accessToken"];
    final refreshToken = response["data"]["refreshToken"];

    storage.write(accessTokenKey, accessToken);
    storage.write(refreshTokenKey, refreshToken);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
