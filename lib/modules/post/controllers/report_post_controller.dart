import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';

class ReportPostController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();
  final RxBool isLoading = false.obs;
  final RxString selectedReason = "".obs;

  late String postId;
  late bool isGroup;

  @override
  void onInit() {
    postId = Get.arguments['postId'] as String;
    isGroup = Get.arguments['isGroup'] as bool? ?? false;
    super.onInit();
  }

  Future<void> reportPost() async{

    if( selectedReason.value.isEmpty ){
      showSnackBar(
          title: "Reason required",
          message: "Please select a reason to report",
        backgroundColor: AppColors.warningYellow
      );
      return;
    }

    isLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.reportPost(),
        body: {
          "post": postId,
          "reason": selectedReason.value,
          "isGroup": isGroup
        }
    );
    isLoading.value = false;
    if( response.statusCode == 200 || response.statusCode == 201 ){
      Get.back();
      showSnackBar(title: "Done", message: "Post reported", backgroundColor: AppColors.greenPrimary);
    }else{
      showApiSnackBar(statusCode: response.statusCode, data: response.data);
    }
  }
}