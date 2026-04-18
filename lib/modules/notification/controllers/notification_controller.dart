import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';

import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/notification/notification_item.dart';

class NotificationController extends GetxController {
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
    await notificationsHelper.fetch(isRefresh: true);
  }
}