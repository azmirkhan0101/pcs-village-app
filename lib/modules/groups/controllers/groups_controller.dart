import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../core/utils/api_response.dart';
import '../../../data/models/groups/group_model.dart';

class GroupsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiService apiService = Get.find<ApiService>();
  late TabController tabController;

  RxBool isLoading = false.obs;

  RxList<GroupModel> activeGroups = <GroupModel>[].obs;
  RxList<GroupModel> suggestedGroups = <GroupModel>[].obs;
  RxList<GroupModel> archivedGroups = <GroupModel>[].obs;

  final activeScrollController = ScrollController();
  final suggestedScrollController = ScrollController();
  final archivedScrollController = ScrollController();

  // Loaded flags
  RxBool isActiveLoaded = false.obs;
  RxBool isSuggestedLoaded = false.obs;
  RxBool isArchivedLoaded = false.obs;

  // Pagination: Active
  int activePage = 1;
  RxBool activeHasMoreData = true.obs;
  RxBool isActiveLoadingMore = false.obs;

  // Pagination: Suggested
  int suggestedPage = 1;
  RxBool suggestedHasMoreData = true.obs;
  RxBool isSuggestedLoadingMore = false.obs;

  // Pagination: Archived
  int archivedPage = 1;
  RxBool archivedHasMoreData = true.obs;
  RxBool isArchivedLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);

    // Initial Load
    fetchActiveGroups();

    activeScrollController.addListener(() {
      if (activeScrollController.position.pixels >=
          activeScrollController.position.maxScrollExtent * 0.9) {
        fetchActiveGroups(loadMore: true);
      }
    });

    suggestedScrollController.addListener(() {
      if (suggestedScrollController.position.pixels >=
          suggestedScrollController.position.maxScrollExtent * 0.9) {
        fetchSuggestedGroups(loadMore: true);
      }
    });

    archivedScrollController.addListener(() {
      if (archivedScrollController.position.pixels >=
          archivedScrollController.position.maxScrollExtent * 0.9) {
        fetchArchivedGroups(loadMore: true);
      }
    });


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

  // ================ ACTIVE GROUPS ==================
  Future<void> fetchActiveGroups({bool loadMore = false}) async {
    if (loadMore) {
      if (!activeHasMoreData.value || isActiveLoadingMore.value) return;
      isActiveLoadingMore.value = true;
      activePage++;
    } else {
      activePage = 1;
      activeHasMoreData.value = true;
      isLoading.value = true;
    }

    ApiResponse response = await apiService.networkRequest(
      method: "GET",
      endPoint: ApiEndpoints.getGroups(isActive: true, page: activePage),
      isAuthRequired: true,
    );

    if (loadMore) {
      isActiveLoadingMore.value = false;
    } else {
      isLoading.value = false;
      isActiveLoaded.value = true;
    }

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? [];
      final newList = data.map((e) => GroupModel.fromJson(e)).toList();

      if (newList.isEmpty) {
        activeHasMoreData.value = false;
      }

      if (loadMore) {
        activeGroups.addAll(newList);
      } else {
        activeGroups.assignAll(newList);
      }
    }
  }

  // =================== SUGGESTED GROUPS ===================
  Future<void> fetchSuggestedGroups({bool loadMore = false}) async {
    if (loadMore) {
      if (!suggestedHasMoreData.value || isSuggestedLoadingMore.value) return;
      isSuggestedLoadingMore.value = true;
      suggestedPage++;
    } else {
      suggestedPage = 1;
      suggestedHasMoreData.value = true;
      isLoading.value = true;
    }

    ApiResponse response = await apiService.networkRequest(
      method: "GET",
      endPoint: ApiEndpoints.getGroups(isSuggested: true, page: suggestedPage),
      isAuthRequired: true,
    );

    if (loadMore) {
      isSuggestedLoadingMore.value = false;
    } else {
      isLoading.value = false;
      isSuggestedLoaded.value = true;
    }

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? [];
      final newList = data.map((e) => GroupModel.fromJson(e)).toList();

      if (newList.isEmpty) {
        suggestedHasMoreData.value = false;
      }

      if (loadMore) {
        suggestedGroups.addAll(newList);
      } else {
        suggestedGroups.assignAll(newList);
      }
    }
  }

  // ===================== ARCHIVED GROUPS ====================
  Future<void> fetchArchivedGroups({bool loadMore = false}) async {
    if (loadMore) {
      if (!archivedHasMoreData.value || isArchivedLoadingMore.value) return;
      isArchivedLoadingMore.value = true;
      archivedPage++;
    } else {
      archivedPage = 1;
      archivedHasMoreData.value = true;
      isLoading.value = true;
    }

    ApiResponse response = await apiService.networkRequest(
      method: "GET",
      endPoint: ApiEndpoints.getGroups(isArchived: true, page: archivedPage),
      isAuthRequired: true,
    );

    if (loadMore) {
      isArchivedLoadingMore.value = false;
    } else {
      isLoading.value = false;
      isArchivedLoaded.value = true;
    }

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? [];
      final newList = data.map((e) => GroupModel.fromJson(e)).toList();

      if (newList.isEmpty) {
        archivedHasMoreData.value = false;
      }

      if (loadMore) {
        archivedGroups.addAll(newList);
      } else {
        archivedGroups.assignAll(newList);
      }
    }
  }

  void onSearch(String value) {
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}