import 'dart:async';

import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/auth/duty_station_model.dart';

class DutyStationsController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();

  // Lists for search results
  RxList<DutyStationModel> currentStationResults = <DutyStationModel>[].obs;
  RxList<DutyStationModel> futureStationResults = <DutyStationModel>[].obs;

  // Loading states
  RxBool isCurrentLoading = false.obs;
  RxBool isFutureLoading = false.obs;

  Timer? _debounce;

  // Function to call API with debounce
  void searchStation({required String query, required bool isCurrent}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        isCurrent ? currentStationResults.clear() : futureStationResults.clear();
        return;
      }

      if (isCurrent) {
        isCurrentLoading.value = true;
        futureStationResults.isNotEmpty ? futureStationResults.clear() : null;
      } else {
        isFutureLoading.value = true;
        currentStationResults.isNotEmpty ? currentStationResults.clear() : null;
      }

      ApiResponse response = await apiService.networkRequest(
          method: "GET",
          isAuthRequired: false,
          endPoint: ApiEndpoints.getDutyStations(search: query),
        shouldPrint: true
      );

      isCurrentLoading.value = false;
      isFutureLoading.value = false;

      if( response.statusCode == 200 ){
        final searchResults = response.data['data'] as List<dynamic>?;
        if( searchResults is List && searchResults.isNotEmpty ){
          if( isCurrent ){
            currentStationResults.value = searchResults.map((e){
              return DutyStationModel.fromJson(e);
            }).toList();
          }else{
            futureStationResults.value = searchResults.map((e){
              return DutyStationModel.fromJson(e);
            }).toList();
          }
        }
      }
    });
  }
}