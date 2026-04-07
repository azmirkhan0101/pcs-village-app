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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  DateTime? dateOfBirth;
  RxString gender = 'select'.obs;

  //INITIALIZE EDIT PROFILE CONTROLLERS
  void initializeEditProfileControllers(){
    // firstNameController.text = profileModel.value?.firstName ?? "";
    // lastNameController.text = profileModel.value?.lastName ?? "";
    // dateOfBirth = profileModel.value?.dob;
    // gender.value = profileModel.value?.gender ?? "select";
    // aboutMeController.text = profileModel.value?.about ?? "";
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
      profileModel.value = model;
      //profileImageUrl.value = profileModel.value?.image ?? "";
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
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim()
    };
    ApiResponse response = await apiService.multipartRequest(
        method: "PATCH",
        endPoint: ApiEndpoints.updateProfile,
        isAuthRequired: true,
        fields: payLoad,
        imageKey: "image",
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

    firstNameController.dispose();
    lastNameController.dispose();
    aboutMeController.dispose();

    super.onClose();
  }

}