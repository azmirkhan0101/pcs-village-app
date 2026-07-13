import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';

import '../../../core/services/api_service.dart';
import '../../../data/models/faq/faq_model.dart';

class BaseRequestController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  RxBool isLoading = false.obs;

  final ProfileController controller = Get.find<ProfileController>();

  final TextEditingController baseNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  Future<void> requestBase() async{

    if( isLoading.value ) return;

    isLoading.value = true;

    Map<String, dynamic> payLoad = {
      "name": controller.profileModel.value?.name ?? "Unknown",
      "email": controller.profileModel.value?.email ?? "Unknown",
      "country": countryController.text.trim(),
      "type": "BASE",
      "state": stateController.text.trim(),
      "city": cityController.text.trim()
    };

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.baseReq,
      body: payLoad
    );
    isLoading.value = false;

    showApiSnackBar(statusCode: response.statusCode, data: response.data);
  }
}