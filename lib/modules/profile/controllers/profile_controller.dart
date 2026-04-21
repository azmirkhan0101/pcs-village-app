import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/show_snackbar.dart';
import '../../../data/models/profile/profile_model.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();

  //GET PROFILE
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  //PROFILE IMAGE
  RxString profileImageUrl = "".obs;

  @override
  void onInit() {

    final profile = storage.read( profileModelKey );
    if( profile != null ) {
      profileModel.value = ProfileModel.fromJson(profile);
      //profileImageUrl.value = profileModel.value?. ?? "";
      initializeEditProfileControllers();
    }else{
      getProfile();
    }

    //print("Parent: ${profileModel.value?.parent?.fullName}");

    super.onInit();
  }


  //EDIT PROFILE
  RxBool isEditProfileLoading = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final TextEditingController nameController = TextEditingController();

  //INITIALIZE EDIT PROFILE CONTROLLERS
  void initializeEditProfileControllers(){
    nameController.text = profileModel.value?.name ?? "";
  }

  //GET PROFILE
  Future<void> getProfile() async{

    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getProfile
    );

    if( response.statusCode == 200 ) { //FETCHED PROFILE DATA
      ProfileModel model = ProfileModel.fromJson(  response.data['data'] );
      //SAVE PROFILE DATA IN STORAGE
      storage.write( profileModelKey, model.toJson() );
      storage.write( userNameKey, model.name );
      storage.write( userIdKey, model.id );
      profileModel.value = model;
      profileImageUrl.value = profileModel.value?.profileImage ?? "";
      initializeEditProfileControllers();
    }
  }

  //UPDATE PROFILE
  Future<void> updateProfile() async{

    if( isEditProfileLoading.value ){
      return;
    }

    isEditProfileLoading.value = true;
    Map<String, String> payLoad = {
      "firstName": nameController.text.trim(),
    };
    ApiResponse response = await apiService.multipartRequest(
        method: "PATCH",
        endPoint: ApiEndpoints.updateProfile,
        isAuthRequired: true,
        fields: {},
        imageKey: "profileImage",
      image: profileImage.value
    );
    isEditProfileLoading.value = false;
    profileImage.value = null;

    if( response.statusCode == 200 ){
      getProfile();
      Get.back();
      showSnackBar(title: "Profile updated!", message: "Your profile has been updated successfully.", backgroundColor: AppColors.greenPrimary);
    }else if( response.statusCode == 401 ){
      showSnackBar(title: "Unauthorized!", message: "You are not authorized.", backgroundColor: AppColors.errorRed);
    }else if( response.statusCode == 408 ){
      timeOutSnackBar();
    }else if( response.statusCode == 503 ){
      noInternetSnackBar();
    }else{
      errorSnackBar();
    }
  }

  //LOGOUT
  Future<void> logOut() async{
    await storage.erase();
    Get.back();
    Get.offAllNamed(AppRoutes.authSelection);
  }


  @override
  void onClose() {

    nameController.dispose();

    super.onClose();
  }

}