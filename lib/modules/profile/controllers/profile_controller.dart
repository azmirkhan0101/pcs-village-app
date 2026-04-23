import 'dart:convert';
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
import '../../../data/models/auth/branch_model.dart';
import '../../../data/models/profile/profile_model.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();

  //GET PROFILE
  RxBool isProfileLoading = false.obs;
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  //PROFILE IMAGE
  RxString profileImageUrl = "".obs;
  DateTime? pcsTimeline;

  //EDIT PROFILE
  RxBool isEditProfileLoading = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final TextEditingController nameController = TextEditingController();
  var selectedBranch = "".obs;
  var selectedBranchId = "".obs;
  var selectedAffiliation = "".obs;
  RxList<BranchModel> branches = <BranchModel>[].obs;
  DateTime? movingTime;
  final TextEditingController currentStationController = TextEditingController();
  final TextEditingController futureStationController = TextEditingController();
  String? currentStationId;
  String? futureStationId;

  //=====================EDIT PROFILE====================
  final List<String> availableInterests = [
    'Fitness', 'Cooking', 'Reading', 'Travel', 'Photography',
    'Sports', 'Arts & Crafts', 'Music', 'Gardening', 'Gaming',
    'Hiking', 'Yoga', 'Running', 'Volunteering', 'Pets'
  ];
  var selectedInterests = <String>[].obs;
  var kidsAgeRange = <String>[].obs;

  void toggleInterestSelection(String label) {
    if (selectedInterests.contains(label)) {
      selectedInterests.remove(label);
    } else {
      selectedInterests.add(label);
    }
  }

  @override
  void onInit() {

    final profile = storage.read( profileModelKey );
    if( profile != null ) {
      profileModel.value = ProfileModel.fromJson(profile);
      initializeEditProfileControllers();
    }else{
      getProfile();
    }

    super.onInit();
  }

  //INITIALIZE EDIT PROFILE CONTROLLERS
  void initializeEditProfileControllers(){
    nameController.text = profileModel.value?.name ?? "";
    profileImageUrl.value = profileModel.value?.profileImage ?? "";
    selectedBranch.value = profileModel.value?.branch?.name ?? "";
    selectedBranchId.value = profileModel.value?.branch?.id ?? "";
    pcsTimeline = profileModel.value?.estimatedPcsDate.toLocal();
    currentStationId = profileModel.value?.currentStation?.id;
    futureStationId = profileModel.value?.futureStation?.id;
    String affiliation = Affiliation.values.firstWhereOrNull((element) => element.value == profileModel.value?.affiliation)?.displayName ?? Affiliation.activeDuty.displayName;
    selectedAffiliation.value = affiliation;
    selectedInterests.value = profileModel.value?.interestTags ?? [];
    kidsAgeRange.value = profileModel.value?.kidsAgeRanges ?? [];
  }

  //GET PROFILE
  Future<void> getProfile() async{

    if( isProfileLoading.value ){
      return;
    }

    isProfileLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getProfile,
      shouldPrint: true
    );

    isProfileLoading.value = false;

    if( response.statusCode == 200 ) { //FETCHED PROFILE DATA
      ProfileModel model = ProfileModel.fromJson(  response.data['data'] );
      //SAVE PROFILE DATA IN STORAGE
      storage.write( profileModelKey, model.toJson() );
      storage.write( userNameKey, model.name );
      storage.write( userIdKey, model.id );
      profileModel.value = model;
      initializeEditProfileControllers();
    }
  }

  //GET BRANCHES
  Future<void> getBranches() async{
    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: false,
        endPoint: ApiEndpoints.getAllBranches,
        shouldPrint: true
    );
    if( response.statusCode == 200 ){
      final fetchedBranches = response.data['data'] as List<dynamic>?;
      if( fetchedBranches is List && fetchedBranches.isNotEmpty ){
        branches.value = fetchedBranches.map((e){
          return BranchModel.fromJson(e);
        }).toList();
      }
    }
  }

  //UPDATE PROFILE
  Future<void> updateProfile() async{

    if( isEditProfileLoading.value ){
      return;
    }

    String affiliationValue = Affiliation.values.firstWhereOrNull((element) => element.displayName == selectedAffiliation.value)?.value ?? Affiliation.activeDuty.value;


    isEditProfileLoading.value = true;
    Map<String, String> payLoad = buildEditProfilePayload(
        name: nameController.text.trim(),
        branch: selectedBranchId.value,
        interestTags: selectedInterests.value,
        kidsAgeRanges: kidsAgeRange,
        currentStation: currentStationId,
        futureStation: futureStationId,
        estimatedPcsDate: movingTime?.toIso8601String(),
        affiliation: affiliationValue
    );

    print("Payloaddddddddddddddddddd: ${jsonEncode(payLoad)}");

    ApiResponse response = await apiService.multipartRequest(
        method: "PATCH",
        endPoint: ApiEndpoints.updateProfile,
        isAuthRequired: true,
        fields: payLoad,
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

  Map<String, String> buildEditProfilePayload({
    String? name,
    String? branch,
    List<String>? interestTags,
    List<String>? kidsAgeRanges,
    String? currentStation,
    String? futureStation,
    String? estimatedPcsDate,
    String? affiliation,
  }) {
    final Map<String, String> body = {};

    // Helper to add String only if it has content
    void addIfValid(String key, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        body[key] = value;
      }
    }

    addIfValid("name", name);
    addIfValid("branch", branch);
    addIfValid("currentStation", currentStation);
    addIfValid("futureStation", futureStation);
    addIfValid("estimatedPcsDate", estimatedPcsDate);
    addIfValid("affiliation", affiliation);

    // Add list items only if the list is not null AND not empty
    if (interestTags != null && interestTags.isNotEmpty) {
      for (int i = 0; i < interestTags.length; i++) {
        print(interestTags[i]);
        body["interestTags[$i]"] = interestTags[i];
      }
    }

    if (kidsAgeRanges != null && kidsAgeRanges.isNotEmpty) {
      for (int i = 0; i < kidsAgeRanges.length; i++) {
        print(kidsAgeRanges[i]);
        body["kidsAgeRanges[$i]"] = kidsAgeRanges[i];
      }
    }

    return body;
  }


  @override
  void onClose() {

    nameController.dispose();

    super.onClose();
  }

}