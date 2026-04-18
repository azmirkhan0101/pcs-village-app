import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/pagination_helper.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/groups/group_model.dart';

class GroupsController extends GetxController
    with GetSingleTickerProviderStateMixin {

  late TabController tabController;

  RxBool isLoading = false.obs;

  //Pagination Helpers
  final activePagination = PaginationHelper<GroupModel>();
  final suggestedPagination = PaginationHelper<GroupModel>();
  final archivedPagination = PaginationHelper<GroupModel>();

  //Scroll Controllers
  final activeScrollController = ScrollController();
  final suggestedScrollController = ScrollController();
  final archivedScrollController = ScrollController();

  //Loaded flags
  RxBool isActiveLoaded = false.obs;
  RxBool isSuggestedLoaded = false.obs;
  RxBool isArchivedLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);

    initActivePagination();
    initSuggestedPagination();
    initArchivedPagination();

    if (activePagination.items.isEmpty) {
      fetchActiveGroups();
    }

    tabController.addListener( onTabChanged );

  }


  //=============TAB CHANGE LISTENER===========
  void onTabChanged() {
      if (tabController.indexIsChanging) return;

      switch (tabController.index) {
        case 0:
          if (!isActiveLoaded.value) fetchActiveGroups();
          break;
        case 1:
          if (!isSuggestedLoaded.value) fetchSuggestedGroups();
          break;
        case 2:
          if (!isArchivedLoaded.value) fetchArchivedGroups();
          break;
      }
    }

  void initActivePagination(){
    activePagination.init(
        endPoint: (page) => ApiEndpoints.getGroups(isActive: true, page: page),
        fromJson: (json) => GroupModel.fromJson(json),
        listExtractor: (data) => data['data'],
      scrollController: activeScrollController
    );
  }

  void initSuggestedPagination(){
    suggestedPagination.init(
        endPoint: (page) => ApiEndpoints.getGroups(isSuggested: true, page: page),
        fromJson: (json) => GroupModel.fromJson(json),
        listExtractor: (data) => data['data'],
      scrollController: suggestedScrollController
    );
  }

  void initArchivedPagination(){
    archivedPagination.init(
        endPoint: (page) => ApiEndpoints.getGroups(isArchived: true, page: page),
        fromJson: (json) => GroupModel.fromJson(json),
        listExtractor: (data) => data['data'],
      scrollController: archivedScrollController
    );
  }

  // ================= ACTIVE =================
  Future<void> fetchActiveGroups() async {
    isActiveLoaded.value = false;
    await activePagination.fetch( isRefresh: true );
    isActiveLoaded.value = true;
  }

  // ================= SUGGESTED =================
  Future<void> fetchSuggestedGroups() async {
    isSuggestedLoaded.value = false;
    await suggestedPagination.fetch( isRefresh: true );
    isSuggestedLoaded.value = true;
  }

  // ================= ARCHIVED =================
  Future<void> fetchArchivedGroups() async {
    isArchivedLoaded.value = false;
    await archivedPagination.fetch( isRefresh: true );
    isArchivedLoaded.value = true;
  }

  void onSearch(String value) {}

  @override
  void onClose() {
    tabController.dispose();
    activeScrollController.dispose();
    suggestedScrollController.dispose();
    archivedScrollController.dispose();
    super.onClose();
  }
}