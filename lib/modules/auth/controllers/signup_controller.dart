import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/auth/branch_model.dart';
import 'package:pcs_village/data/models/auth/signup_model.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/app_constants.dart';

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
  String? selectedBranchId;
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

    String affiliationValue = Affiliation.values.firstWhereOrNull((element) => element.displayName == selectedAffiliation)?.value ?? Affiliation.activeDuty.value;


    Map<String, String> payLoad = buildSignUpBody(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        branch: selectedBranchId!,
        interestTags: interests,
        kidsAgeRanges: kidsAgeRange,
        currentStation: currentStationId!,
        futureStation: futureStationId,
        estimatedPcsDate: movingTime!.toIso8601String(),
        affiliation: affiliationValue
    );

    print(jsonEncode(payLoad));

    isSignupLoading.value = true;
    ApiResponse response = await apiService.multipartRequest(
        method: "POST",
        endPoint: ApiEndpoints.signup,
        isAuthRequired: false,
        fields: payLoad,
      image: profileImage.value,
      imageKey: "profileImage"
    );
    isSignupLoading.value = false;

    String? message = response.data?['message'];

    if( response.statusCode == 201 ){//ACCOUNT CREATED
      Get.offAllNamed(
          AppRoutes.otpVerificationScreen,
        arguments: {
            emailKey : emailController.text.trim(),
          isSignupKey : true
        }
      );
    }else if( response.statusCode == 409 ){//CONFLICT
      if( message != null && message.contains("Your account is not verified yet. Please verify your OTP.") ){
        Get.offAndToNamed(
            AppRoutes.otpVerificationScreen,
            arguments: {
              emailKey : emailController.text.trim(),
              isSignupKey : true
            }
        );
      }
      showSnackBar(title: "Not verified", message: message ?? "Verify your account", backgroundColor: AppColors.warningYellow
      );
    }else{
      showSnackBar(title: "Error", message: message ?? "Something went wrong", backgroundColor: AppColors.errorRed
      );
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

  Map<String, String> buildSignUpBody({
    required String name,
    required String email,
    required String password,
    required String branch,
    required List<String> interestTags,
    required List<String> kidsAgeRanges,
    required String currentStation,
    required String? futureStation,
    required String estimatedPcsDate,
    required String affiliation
  }) {
    final Map<String, String> body = {
      "name": name,
      "email": email,
      "password": password,
      "branch": branch,
      "currentStation": currentStation,
      if( futureStation != null ) "futureStation": futureStation,
      "estimatedPcsDate": estimatedPcsDate,
      "affiliation": affiliation
    };

    for (int i = 0; i < interestTags.length; i++) {
      body["interestTags[$i]"] = interestTags[i];
    }

    for (int i = 0; i < kidsAgeRanges.length; i++) {
      body["kidsAgeRanges[$i]"] = kidsAgeRanges[i];
    }

    return body;
  }
}