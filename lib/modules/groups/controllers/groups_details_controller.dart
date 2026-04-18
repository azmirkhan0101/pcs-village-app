import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/groups/group_model.dart';
import 'package:pcs_village/data/models/groups/member_model.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/post/post.dart';

class GroupsDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {

  final ApiService apiService = Get.find<ApiService>();
  late TabController tabController;
  RxInt currentTabIndex = 0.obs;
  late GroupModel groupModel;

  // POSTS
  final postsHelper = PaginationHelper<Post>();
  final ScrollController postScrollController = ScrollController();
  final RxBool isPostsLoaded = false.obs;

  // MEMBERS
  final membersHelper = PaginationHelper<MemberModel>();
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

    initPostsHelper();
    initMembersHelper();

    tabController.addListener( onTabChanged );

    if ( isJoined.value && postsHelper.items.isEmpty ) {
      getPosts();
    }
  }

  void initPostsHelper() {
    postsHelper.init(
        endPoint: (page) => ApiEndpoints.getGroupPosts( groupId: groupModel.id, page: page ),
        fromJson: (json) => Post.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: postScrollController
    );
  }

  void initMembersHelper() {
    membersHelper.init(
        endPoint: (page) => ApiEndpoints.getGroupMembers(groupId: groupModel.id, page: page),
        fromJson: (json) => MemberModel.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: membersScrollController
    );
  }

  void onTabChanged() {
    if (!isJoined.value) return;
    if (tabController.indexIsChanging) return;

    if (tabController.index == 0) {
      currentTabIndex.value = 0;
      if (!isPostsLoaded.value) getPosts();
    } else {
      currentTabIndex.value = 1;
      if (!isMembersLoaded.value) getMembers();
    }
  }

  // ====== GET POSTS ======
  Future<void> getPosts() async {
    isPostsLoaded.value = false;
    await postsHelper.fetch(isRefresh: true);
    isPostsLoaded.value = true;
  }

  // ====== GET MEMBERS ======
  Future<void> getMembers() async {
    isMembersLoaded.value = false;
    await membersHelper.fetch(isRefresh: true);
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
  Future<void> sendWave({required String userId}) async {

    final member = membersHelper.items.firstWhereOrNull((m) => m.userId == userId);

    if( member == null || member.isWaveLoading.value ){
      return;
    }
    member.isWaveLoading.value = true;

    final Map<String, String> payLoad = {
      "receiver": userId
    };

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.sendWave,
      body: payLoad
    );

    member.isWaveLoading.value = false;

    if( response.statusCode == 200 || response.statusCode == 201 ){
      member.isWavePending = true;
    }else{
      showApiSnackBar(
          statusCode: response.statusCode
      );
    }
  }

  Future<void> waveBack({required String userId}) async{

    final member = membersHelper.items.firstWhereOrNull((m) => m.userId == userId);

    if( member == null || member.isWaveLoading.value ){
      return;
    }
    member.isWaveLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.waveBack(userId: userId)
    );

    member.isWaveLoading.value = false;

    if( response.statusCode == 200 || response.statusCode == 201 ){
      member.isWavePending = false;
      member.isIncomingWave = false;
      member.isMatched = true;
    }else{
      showApiSnackBar(
          statusCode: response.statusCode
      );
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    postScrollController.dispose();
    membersScrollController.dispose();
    super.onClose();
  }
}