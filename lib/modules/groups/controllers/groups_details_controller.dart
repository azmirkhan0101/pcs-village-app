import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/groups/group_model.dart';
import 'package:pcs_village/data/models/groups/member_model.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/post/post.dart';

class GroupsDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {

  final ApiService apiService = Get.find<ApiService>();
  late TabController tabController;
  late GroupModel groupModel;

  // POSTS
  final PaginationHelper<Post> postsHelper = PaginationHelper<Post>();
  final ScrollController postScrollController = ScrollController();
  final RxBool isPostsLoaded = false.obs;

  // MEMBERS
  final PaginationHelper<MemberModel> membersHelper = PaginationHelper<MemberModel>();
  final ScrollController membersScrollController = ScrollController();
  final RxBool isMembersLoaded = false.obs;

  final RxBool isJoined = false.obs;
  final RxBool isLeaving = false.obs;
  final RxBool isJoining = false.obs;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);
    groupModel = Get.arguments as GroupModel;
    isJoined.value = groupModel.isAlreadyJoined;

    _initPostsHelper();
    _initMembersHelper();

    postsHelper.attachScrollController(postScrollController);
    membersHelper.attachScrollController(membersScrollController);

    tabController.addListener(_onTabChanged);

    if (isJoined.value) {
      getPosts();
    }
  }

  void _initPostsHelper() {
    postsHelper.init(
      apiCall: (page) => apiService.networkRequest(
        method: 'GET',
        isAuthRequired: true,
        endPoint: ApiEndpoints.getGroupPosts(
          groupId: groupModel.id,
          page: page,
        ),
      ),
      fromJson: (json) => Post.fromJson(json),
      listExtractor: (data) => data['data'] as List<dynamic>?,
    );
  }

  void _initMembersHelper() {
    membersHelper.init(
      apiCall: (page) => apiService.networkRequest(
        method: 'GET',
        isAuthRequired: true,
        endPoint: ApiEndpoints.getGroupMembers(groupId: groupModel.id),
      ),
      fromJson: (json) => MemberModel.fromJson(json),
      listExtractor: (data) => data['data'] as List<dynamic>?,
    );
  }

  void _onTabChanged() {
    if (!isJoined.value) return;
    if (tabController.indexIsChanging) return;

    if (tabController.index == 0) {
      if (!isPostsLoaded.value) getPosts();
    } else {
      if (!isMembersLoaded.value) getMembers();
    }
  }

  // ====== GET POSTS ======
  Future<void> getPosts({bool refresh = true}) async {
    if (refresh) isPostsLoaded.value = false;
    await postsHelper.fetch(isRefresh: refresh);
    isPostsLoaded.value = true;
  }

  // ====== GET MEMBERS ======
  Future<void> getMembers({bool refresh = true}) async {
    if (refresh) isMembersLoaded.value = false;
    await membersHelper.fetch(isRefresh: refresh);
    isMembersLoaded.value = true;
  }

  // ====== JOIN GROUP ======
  Future<void> joinGroup() async {
    if (isJoining.value) return;
    isJoining.value = true;

    final ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: true,
      endPoint: ApiEndpoints.joinGroup(groupId: groupModel.id),
    );

    isJoining.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      isJoined.value = true;
      getPosts();
    }
  }

  // ====== LEAVE GROUP ======
  Future<void> leaveGroup() async {
    if (isLeaving.value) return;
    isLeaving.value = true;

    final ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: true,
      endPoint: ApiEndpoints.leaveGroup(groupId: groupModel.id),
    );

    isLeaving.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      isJoined.value = false;
      postsHelper.items.clear();
      membersHelper.items.clear();
      isPostsLoaded.value = false;
      isMembersLoaded.value = false;
      tabController.index = 0;
    }
  }

  // ====== SEND WAVE ======
  Future<void> sendWave({required String memberId}) async {
    // TODO: implement wave API call
    // final updatedMember = await _repo.sendWave(memberId);
    final index = membersHelper.items.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      // membersHelper.items[index] = updatedMember;
    }
  }

  @override
  void onClose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    postScrollController.dispose();
    membersScrollController.dispose();
    super.onClose();
  }
}