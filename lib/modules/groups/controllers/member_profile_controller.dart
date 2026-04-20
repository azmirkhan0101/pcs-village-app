import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/profile/profile_model.dart';

class MemberProfileController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();

  late String memberId;
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {

    memberId = Get.arguments;

    getMemberProfile();

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

    isLoading.value = false;

    if( response.statusCode == 200 ){
      profileModel.value = ProfileModel.fromJson(response.data['data']);
    }else{
      showApiSnackBar(
          statusCode: response.statusCode,
        data: response.data
      );
    }
}
}