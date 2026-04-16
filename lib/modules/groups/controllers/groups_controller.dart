import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/pagination_helper.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/groups/group_model.dart';

class GroupsController extends GetxController
    with GetSingleTickerProviderStateMixin {

  final ApiService apiService = Get.find<ApiService>();
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

    activePagination.attachScrollController(activeScrollController);
    suggestedPagination.attachScrollController(suggestedScrollController);
    archivedPagination.attachScrollController(archivedScrollController);

    activePagination.init(
        apiCall: (page) => apiService.networkRequest(
          method: "GET",
          endPoint: ApiEndpoints.getGroups(isActive: true, page: page),
          isAuthRequired: true,
        ),
        fromJson: (json) => GroupModel.fromJson(json),
        listExtractor: (data) => data['data']
    );

    suggestedPagination.init(
        apiCall: (page) => apiService.networkRequest(
          method: "GET",
          endPoint: ApiEndpoints.getGroups(isSuggested: true, page: page),
          isAuthRequired: true,
        ),
        fromJson: (json) => GroupModel.fromJson(json),
        listExtractor: (data) => data['data']
    );

    archivedPagination.init(
        apiCall: (page) => apiService.networkRequest(
          method: "GET",
          endPoint: ApiEndpoints.getGroups(isArchived: true, page: page),
          isAuthRequired: true,
        ),
        fromJson: (json) => GroupModel.fromJson(json),
        listExtractor: (data) => data['data']
    );

    fetchActiveGroups();

    tabController.addListener(() {
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
    });
  }

  // ================= ACTIVE =================
  Future<void> fetchActiveGroups({bool loadMore = false}) async {

    await activePagination.fetch( isRefresh: !loadMore );
    isActiveLoaded.value = true;
  }

  // ================= SUGGESTED =================
  Future<void> fetchSuggestedGroups({bool loadMore = false}) async {

    suggestedPagination.fetch( isRefresh: !loadMore );
    isSuggestedLoaded.value = true;
  }

  // ================= ARCHIVED =================
  Future<void> fetchArchivedGroups({bool loadMore = false}) async {

    await archivedPagination.fetch(isRefresh: !loadMore,);
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