import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_response.dart';

import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/notification/notification_item.dart';

class NotificationController extends GetxController{

  final ApiService apiService = Get.find<ApiService>();
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  final ScrollController controller = ScrollController();
  int currentPage = 1;
  bool hasMoreData = true;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  @override
  void onInit() {

    if( notifications.isEmpty ){
      getNotifications();
    }

    controller.addListener((){
      if( controller.position.pixels >= controller.position.maxScrollExtent * 0.9 ){
        getNotifications(refresh: false);
      }
    });

    super.onInit();
  }

  //=========================GET NOTIFICATIONS=====================
Future<void> getNotifications({bool refresh = true}) async{

    if( isLoading.value || !hasMoreData ){
      return;
    }

    if( refresh ){
      currentPage = 1;
      hasMoreData = true;
      isLoading.value = true;
    }else{
      if( isMoreLoading.value || !hasMoreData ){
        return;
      }
      isMoreLoading.value = true;
    }

    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getNotifications(page: currentPage)
    );

    if( refresh ){
      isLoading.value = false;
    }else{
      isMoreLoading.value = false;
    }

    if( response.statusCode == 200 ){
      final result = response.data['data'] as List<dynamic>;
      if( result.isNotEmpty ){
        final fetchedNotifications = result.map((e) => NotificationModel.fromJson(e)).toList();
        if
        ( refresh ){
          notifications.value = fetchedNotifications;
        }else{
          notifications.value.addAll(fetchedNotifications);
        }

        if( fetchedNotifications.length < 10 ){
          hasMoreData = false;
        }else{
          currentPage++;
        }
      }
    }
}
}