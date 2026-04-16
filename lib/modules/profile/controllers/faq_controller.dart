import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';

import '../../../core/services/api_service.dart';
import '../../../data/models/faq/faq_model.dart';

class FaqController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  PaginationHelper<FaqModel> faqHelper = PaginationHelper<FaqModel>();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {

    fetchFaqs();

    super.onInit();
  }

  Future<void> fetchFaqs({bool isRefresh = true}) async {
    await faqHelper.fetch(
        isRefresh: isRefresh,
        apiCall: (page) => apiService.networkRequest(
            method: "GET",
            isAuthRequired: true,
            endPoint: ApiEndpoints.getFaq(page: page)
        ),
        fromJson: (json) => FaqModel.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?
    );
  }
}