import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/show_snackbar.dart';
import '../../../routes/app_pages.dart';

class SettingsController extends GetxController {

  @override
  void onInit() {

    currentPassword.addListener( _onTextChanged );
    newPassword.addListener( _onTextChanged );
    confirmPassword.addListener( _onTextChanged );

    super.onInit();
  }

  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();

  //PRIVACY POLICY
  RxString privacyPolicy = "".obs;
  RxBool isPrivacyPolicyLoading = false.obs;
  //TERMS CONDITIONS
  RxString termsConditions = "".obs;
  RxBool isTermsAndConditionsLoading = false.obs;

  //CHANGE PASSWORD
  RxBool isChangePasswordLoading = false.obs;
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

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

  //GET PRIVACY POLICY
  Future<void> getPrivacyPolicy() async {

    if( privacyPolicy.value.isNotEmpty ){
      return;
    }

    if( isPrivacyPolicyLoading.value ){
      return;
    }

    isPrivacyPolicyLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: false,
        endPoint: ApiEndpoints.privacyPolicy
    );
    isPrivacyPolicyLoading.value = false;

    if (response.statusCode == 200) {
      privacyPolicy.value = response.data['data']['privacyPolicy'];
    }
  }

  //GET TERMS AND CONDITIONS
  Future<void> getTermsAndConditions() async {

    if( termsConditions.value.isNotEmpty || isTermsAndConditionsLoading.value ){
      return;
    }

    isTermsAndConditionsLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
    method: "GET",
    isAuthRequired: false,
    endPoint: ApiEndpoints.termsAndConditions
    );
    isTermsAndConditionsLoading.value = false;

    if (response.statusCode == 200) {
      termsConditions.value = response.data['data']['termsCondition'];
    }
  }

  //CHANGE PASSWORD
  Future<void> changePassword() async{

    if( isChangePasswordLoading.value ){
      return;
    }

    isChangePasswordLoading.value = true;
    Map<String, String> payLoad = {
      "oldPassword" : currentPassword.text.trim(),
      "newPassword" : newPassword.text.trim()
    };
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.changePassword,
      body: payLoad
    );
    isChangePasswordLoading.value = false;

    String? message = response.data?['message'];

    if( response.statusCode == 200 ){
      currentPassword.clear();
      newPassword.clear();
      confirmPassword.clear();
      showSnackBar(title: "Password changed!", message: message ?? "Your password has been changed successfully.", backgroundColor: AppColors.greenPrimary);
      await storage.erase();
      Get.offAllNamed( AppRoutes.authSelection );
    }else if( response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 404 || response.statusCode == 409 ){
      showSnackBar(title: "Attention!", message: message ?? "Failed to change password.", backgroundColor: AppColors.warningYellow);
    }else if (response.statusCode == 408) {//TIME OUT
      timeOutSnackBar();
    }else if (response.statusCode == 503) {//NO INTERNET
      noInternetSnackBar();
    } else {
      errorSnackBar();
    }
  }

  //DELETE ACCOUNT
  Future<void> deleteAccount() async {

    showDeletingAlert();
    ApiResponse response = await apiService.networkRequest(
        method: "DELETE",
        isAuthRequired: true,
        endPoint: ApiEndpoints.deleteAccount
    );
    if( response.statusCode == 200 ){
      await storage.erase();
      if( Get.isDialogOpen ?? false ){
        Get.back();
      }
      Get.offAllNamed( AppRoutes.authSelection );
      showDeleteSuccessAlert();
    }else{
      if( Get.isDialogOpen ?? false ){
        Get.back();
      }
      errorSnackBar();
    }
  }


  //DELETE ACCOUNT DIALOG
  void showDeleteDialog() async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.white,
          title: Column(
            children: [
              //Image.asset(Assets.images.warning.keyName,),
              Text(
                "Warning",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete your account?",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CupertinoColors.inactiveGray, width: 2.r)
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w), // Spacing between buttons

                // Delete button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.greenPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async{
                        Get.back();
                        deleteAccount();
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  //DELETING ALERT
  Future<void> showDeletingAlert() async{
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: CircularProgressIndicator(color: AppColors.greenPrimary,),),
            SizedBox(
              height: 15.h,
            ),
            Text("Deleting...", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),)
          ],
        ),
      )
    );
  }

  //DELETe SUCCESS ALERT
  Future<void> showDeleteSuccessAlert() async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.white,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Success", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22.sp),),
              SizedBox(
                height: 15.h,
              ),
              Text("Your account has been deleted successfully.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),),
              SizedBox(height: 12.h,),
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.greenPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () async{
                    Get.back();
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  void onClose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
