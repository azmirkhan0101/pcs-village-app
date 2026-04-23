import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/subscription/plan_model.dart';

import '../screens/payment_webview_screen.dart';

class PlanController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();

  RxBool isLoading = false.obs;
  RxBool isSubscribing = false.obs;
  Rxn<PlanModel> planModel = Rxn<PlanModel>();

  @override
  void onInit() {

    getPlan();
    super.onInit();
  }

  //GET PLAN
Future<void> getPlan() async{

    if( isLoading.value ) return;

    isLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getSubscriptionPlan
    );
    isLoading.value = false;

    if( response.statusCode == 200 ){
      final fetchedPlans = response.data['data'] as List<dynamic>?;

      if( fetchedPlans != null && fetchedPlans.isNotEmpty ){
        planModel.value = PlanModel.fromJson(fetchedPlans[0]);
      }
    }
}

//SUBSCRIBE
Future<void> subscribe({required String planId}) async{
    if( isSubscribing.value ){
      return;
    }

    isSubscribing.value = true;

    Map<String, dynamic> payLoad = {
      "planId": planId
    };

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.subscribeToPlan,
      body: payLoad,
      shouldPrint: true
    );

    isSubscribing.value = false;

    if( response.statusCode == 200 || response.statusCode == 201 ){
      String paymentUrl = response.data['data'];
      Get.to(PaymentWebViewScreen(paymentUrl: paymentUrl));
    }else{
      showApiSnackBar(statusCode: response.statusCode, data: response.data);
    }
}
}