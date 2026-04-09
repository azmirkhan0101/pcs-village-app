import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/groups/group_model.dart';

class GroupsController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();

  RxList<GroupModel> groups = <GroupModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {

    getGroups();
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
      final responseList = response.data['data'] as List<dynamic>?;
      if( responseList != null && responseList.isNotEmpty ){
        final fetchedGroups = responseList.map((e){
          return GroupModel.fromJson(e);
        }).toList();

        groups.value = fetchedGroups;
      }
    }
}
}