import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/data/models/message/conversation_model.dart';

class ConversationController extends GetxController{

  final conversationHelper = PaginationHelper<Conversation>();
  final contactListScrollController = ScrollController();

  @override
  void onInit() {

    initContactListHelper();

    getConversations();

    super.onInit();
  }

  void initContactListHelper({String searchQuery = ""}){
    conversationHelper.init(
        endPoint: (page) => ApiEndpoints.allConversations(page: page, searchQuery: searchQuery),
        fromJson: (json) => Conversation.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: contactListScrollController
    );
  }

  Future<void> getConversations() async {
    await conversationHelper.fetch(isRefresh: true, shouldPrint: true);
  }


}