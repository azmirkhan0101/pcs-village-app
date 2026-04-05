import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/show_snackbar.dart';
import '../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  GlobalKey<FormState>? formKey;
  void setFormKey(GlobalKey<FormState> key) {
    formKey = key;
  }


  String email = "";

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RxBool isPasswordChanging = false.obs;

  @override
  void onInit() {
    email = Get.arguments;
    super.onInit();
  }
  
  //RESET PASSWORD
  Future<void> resetPassword() async{

    if( isPasswordChanging.value ){
      return;
    }
    isPasswordChanging.value = true;
    Map<String, dynamic> payLoad = {
      "email": email,
      "newPassword": passwordController.text.trim()
    };
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: false,
        endPoint: ApiEndpoints.resetPassword,
      body: payLoad
    );
    isPasswordChanging.value = false;

    String? message = response.data?['message'];

    if( response.statusCode == 200 ){
      showSnackBar(title: "Done!", message: message ?? "Password has been reset.", backgroundColor: AppColors.greenPrimary);
      Get.offAndToNamed( AppRoutes.loginScreen );
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