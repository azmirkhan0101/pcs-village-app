import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/auth/branch_model.dart';
import 'package:pcs_village/data/models/auth/signup_model.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/api_endpoints.dart';

class SignupController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();
  RxBool isSignupLoading = false.obs;
  SignupModel signupModel = SignupModel();
  //BRANCHES - for branch selection
  RxList<BranchModel> branches = <BranchModel>[].obs;

  GlobalKey<FormState>? _formKey;
  bool _hasSubmitted = false;

  //SIGNUP DATA
  String? selectedBranch;
  String? selectedAffiliation;
  List<String> interests = [];
  List<String> kidsAgeRange = [];



  @override
  void onInit() {

    nameController.addListener(_onTextChanged);
    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
    confirmPasswordController.addListener(_onTextChanged);
    dateController.addListener(_onTextChanged);

    getBranches();

    super.onInit();
  }

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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  TextEditingController dateController = TextEditingController();//FOR VALIDATION ONLY
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final TextEditingController currentStationController = TextEditingController();
  final TextEditingController futureStationController = TextEditingController();

  String? currentStationId;
  String? futureStationId;

  late DateTime? movingTime;

  final Rx<File?> profileImage = Rx<File?>(null);

  Future<void> signup() async {

    Map<String, dynamic> payLoad = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "current_duty_station": currentStationId,
      "future_duty_station": futureStationId,
      "moving_time": movingTime?.toIso8601String(),
      "interests": interests,
      "kids_age_range": kidsAgeRange,
      "branch": selectedBranch,
      "affiliation": selectedAffiliation,
      "profile_image": profileImage.value?.path
    };

    isSignupLoading.value = true;
    ApiResponse response = await apiService.multipartRequest(
        method: "POST",
        endPoint: ApiEndpoints.signup,
        isAuthRequired: false,
        fields: payLoad,
      image: profileImage.value,
      imageKey: "image"
    );
    isSignupLoading.value = false;

    if( response.statusCode == 200 ){
      Get.offAllNamed(AppRoutes.otpVerificationScreen);
    }

    print(jsonEncode(payLoad));
  }

  //GET BRANCHES
Future<void> getBranches() async{
    ApiResponse response = await apiService.networkRequest(
      method: "GET",
        isAuthRequired: false,
        endPoint: ApiEndpoints.getAllBranches,
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

//GET BRANCHES
  Future<void> searchDutyStations({required String search}) async{
    ApiResponse response = await apiService.networkRequest(
      method: "GET",
      isAuthRequired: false,
      endPoint: ApiEndpoints.getDutyStations(search: search),
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
}