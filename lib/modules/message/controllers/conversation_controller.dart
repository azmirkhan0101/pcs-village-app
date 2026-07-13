import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/data/models/message/conversation_model.dart';

class ConversationController extends GetxController{

  final conversationHelper = PaginationHelper<Conversation>();
  final conversationScrollController = ScrollController();
  final searchController = TextEditingController();
  RxList<Conversation> displayPosts = <Conversation>[].obs;
  List<Conversation> originalFeedBackup = <Conversation>[];

  Timer? _debounce;

  @override
  void onInit() {

    setupSearchListener();
    initConversationHelper();

    getConversations();

    super.onInit();
  }

  void setupSearchListener() {
    searchController.addListener(() {
      _onSearchChanged(searchController.text.trim());
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        initConversationHelper(searchQuery: query);
        getConversations(isSearch: true);
      }else{
        initConversationHelper(searchQuery: "");
        displayPosts.assignAll(originalFeedBackup);
      }
    });
  }

  void initConversationHelper({String searchQuery = ""}){
    conversationHelper.init(
        endPoint: (page) => ApiEndpoints.allConversations(page: page, searchQuery: searchQuery),
        fromJson: (json) => Conversation.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: conversationScrollController
    );
  }

  Future<void> getConversations({bool isSearch = false}) async {
    await conversationHelper.fetch(isRefresh: true);
    displayPosts.assignAll(conversationHelper.items);
    if( !isSearch ){
      originalFeedBackup.assignAll(conversationHelper.items);
    }
  }

  @override
  void onClose() {

    conversationScrollController.dispose();
    searchController.dispose();
    if ( _debounce?.isActive ?? false ) _debounce!.cancel();

    super.onClose();
  }


}