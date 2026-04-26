import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/services/api_service.dart';

import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../core/utils/show_snackbar.dart';
import '../../../data/models/notification/notification_model.dart';

class NotificationController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  final ScrollController notificationScrollController = ScrollController();
  final notificationsHelper = PaginationHelper<NotificationModel>();

  @override
  void onInit() {
    initNotificationsHelper();

    if (notificationsHelper.items.isEmpty) {
      getNotifications();
    }

    super.onInit();
  }

  void initNotificationsHelper() {
    notificationsHelper.init(
      endPoint: (page) => ApiEndpoints.getNotifications(page: page),
      fromJson: (json) => NotificationModel.fromJson(json),
      listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: notificationScrollController,
    );
  }

  //=========================GET NOTIFICATIONS=====================
  Future<void> getNotifications() async {
    await notificationsHelper.fetch(isRefresh: true,shouldPrint: true);
  }

  Future<void> waveBack({required String userId}) async{

    //final member = displayMembers.firstWhereOrNull((m) => m.userId == userId);

    // if( member == null || member.isWaveLoading.value ){
    //   return;
    // }
    //member.isWaveLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.waveBack(userId: userId),
        shouldPrint: true
    );

    showApiSnackBar(
        statusCode: response.statusCode,
        data: response.data
    );

    //member.isWaveLoading.value = false;

    // if( response.statusCode == 200 || response.statusCode == 201 ){
    //   member.isWavePending = false;
    //   member.isIncomingWave = false;
    //   member.isMatched = true;
    // }else{
    //   showApiSnackBar(
    //       statusCode: response.statusCode,
    //       data: response.data
    //   );
    // }
  }
}