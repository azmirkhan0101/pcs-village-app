import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';

class GroupsController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();

  RxBool isLoading = false.obs;

  @override
  void onInit() {


    super.onInit();
  }

  //====================GET GROUPS===========================
Future<void> getGroups() async{

    isLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getGroups
    );
    isLoading.value = false;

    if( response.statusCode == 200 ){

    }
}
}