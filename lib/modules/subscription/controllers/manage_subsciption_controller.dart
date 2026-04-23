import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/subscription/active_plan_model.dart';
import 'package:pcs_village/data/models/subscription/history_model.dart';

class ManageSubscriptionController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();
  RxBool isActivePlanLoading = false.obs;
  RxBool isPlanHistoryLoading = false.obs;
  RxList<HistoryModel> historyList = <HistoryModel>[].obs;
  Rxn<ActivePlanModel> activePlanModel = Rxn<ActivePlanModel>(null);

  @override
  void onInit() {

    getActivePlan();
    getSubscriptionHistory();

    super.onInit();
  }


  //active plan
  Future<void> getActivePlan() async{
    if( isActivePlanLoading.value ){
      return;
    }

    isActivePlanLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.activeSubscription,
      shouldPrint: true
    );
    isActivePlanLoading.value = false;

    if( response.statusCode == 200 ){
      final fetchedPlan = response.data['data'] as Map<String, dynamic>?;
      if( fetchedPlan != null ){
        activePlanModel.value = ActivePlanModel.fromJson(fetchedPlan);
      }
    }
  }

  //plan history
Future<void> getSubscriptionHistory() async{
    if( isPlanHistoryLoading.value ){
      return;
    }

    isPlanHistoryLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.subscriptionHistory,
      shouldPrint: true
    );
    isPlanHistoryLoading.value = false;

    if( response.statusCode == 200 ){
      final fetchedHistory = response.data['data'] as List<dynamic>?;
      if(  fetchedHistory != null && fetchedHistory.isNotEmpty ){
        historyList.value = fetchedHistory.map((e) => HistoryModel.fromJson(e)).toList();
      }
    }
}
}