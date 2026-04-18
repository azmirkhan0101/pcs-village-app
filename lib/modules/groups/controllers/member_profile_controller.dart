import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';

class MemberProfileController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();

  RxBool isLoading = false.obs;
  late String memberId;

  @override
  void onInit() {

    memberId = Get.arguments;

    super.onInit();
  }


  //===============GET MEMBER PROFILE=================
Future<void> getMemberProfile() async{

    if( isLoading.value ) return;
    isLoading.value = true;
    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getMemberProfile( memberId: memberId )
    );

    //TODO: MAKE A MODEL FROM RESPONSE AND PARSE HERE.
}
}