import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';

import '../../../core/services/api_service.dart';
import '../../../data/models/faq/faq_model.dart';

class FaqController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  final faqHelper = PaginationHelper<FaqModel>();
  final ScrollController faqScrollController = ScrollController();

  @override
  void onInit() {

    initFaqHelper();

    if( faqHelper.items.isEmpty ) {
      fetchFaqs();
    }

    super.onInit();
  }

  void initFaqHelper(){
    faqHelper.init(
        endPoint: (page) => ApiEndpoints.getFaq(page: page),
        fromJson: (json) => FaqModel.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
        scrollController: faqScrollController
    );
  }

  Future<void> fetchFaqs() async {
    await faqHelper.fetch(isRefresh: true);
  }
}