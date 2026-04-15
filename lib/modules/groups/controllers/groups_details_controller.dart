import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/groups/group_model.dart';
import 'package:pcs_village/data/models/groups/member_model.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/post/post.dart';

class GroupsDetailsController extends GetxController with GetSingleTickerProviderStateMixin{

  final ApiService apiService = Get.find<ApiService>();
  late TabController tabController;

  late GroupModel groupModel;

  //POSTS
  PaginationHelper<Post> postsHelper = PaginationHelper<Post>();
  final ScrollController postScrollController = ScrollController();
  final ScrollController membersScrollController = ScrollController();
  RxBool isPostsLoaded = false.obs;

  //MEMBERS
  PaginationHelper<MemberModel> membersHelper = PaginationHelper();
  RxBool isMembersLoaded = false.obs;


  RxBool isJoined = false.obs;

  RxBool isLeaving = false.obs;
  RxBool isJoining = false.obs;
//======JOIN GROUP======
  Future<void> joinGroup() async {
    if (isJoining.value) {
      return;
    }
    isJoining.value = true;
    ApiResponse response = await apiService.networkRequest(
        method: 'POST',
        isAuthRequired: true,
        endPoint: ApiEndpoints.joinGroup(groupId: groupModel.id)
    );
    isJoining.value = false;

    if( response.statusCode == 200 || response.statusCode == 201 ){
      isJoined.value = true;
      getPosts();
    }
  }

//======LEAVE GROUP======
  Future<void> leaveGroup() async {
    if (isLeaving.value) {
      return;
    }
    isLeaving.value = true;
    ApiResponse response = await apiService.networkRequest(
        method: 'POST',
        isAuthRequired: true,
        endPoint: ApiEndpoints.leaveGroup(groupId: groupModel.id)
    );
    isLeaving.value = false;

    if( response.statusCode == 200 || response.statusCode == 201 ){
      isJoined.value = false;
      postsHelper.items.clear();
      membersHelper.items.clear();
      isPostsLoaded.value = false;
      isMembersLoaded.value = false;
      tabController.index = 0;
    }
  }


//SEND WAVE
  Future<void> sendWave({required String memberId}) async{
    //TODO: SEND WAVE
    //final updatedMember = await _repo.sendWave(memberId);
    final index = membersHelper.items.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      //membersHelper.items[index] = updatedMember;
    }
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    groupModel = Get.arguments as GroupModel;
    isJoined.value = groupModel.isAlreadyJoined;

    if( postsHelper.items.isEmpty && isJoined.value ){
      getPosts();
    }

    tabController.addListener((){
      if( !isJoined.value ) return;
      if (tabController.indexIsChanging) return;

      if( tabController.index == 0 ){
        if( !isPostsLoaded.value ){
          getPosts();
        }
      }else{
        if( !isMembersLoaded.value ){
          getMembers();
        }
      }
    });

    postScrollController.addListener((){
      if( postScrollController.position.pixels == postScrollController.position.maxScrollExtent * 0.9 ){
        getPosts(refresh: false);
      }
    });

    membersScrollController.addListener((){
      if( membersScrollController.position.pixels == membersScrollController.position.maxScrollExtent * 0.9 ){
        getMembers(refresh: false);
      }
    });
    super.onInit();
  }

  //GET POSTS
  Future<void> getPosts({bool refresh = true}) async{

    if( refresh ){
      isPostsLoaded.value = false;
    }

    await postsHelper.fetch(

        isRefresh: refresh,
        apiCall: (page) => apiService.networkRequest(
            method: "GET",
            isAuthRequired: true,
            endPoint: ApiEndpoints.getGroupPosts(groupId: groupModel.id, page: page)
        ),
        fromJson: (json) => Post.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?
    );

    isPostsLoaded.value = true;
  }

  Future<void> getMembers({bool refresh = true}) async{

    if( refresh ){
      isMembersLoaded.value = false;
    }

    await membersHelper.fetch(
      isRefresh: refresh,
      apiCall: (page) => apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getGroupMembers(groupId: groupModel.id)
          ),
      fromJson: (json) => MemberModel.fromJson(json),
      listExtractor: (data) => data['data'] as List<dynamic>?
    );

    isMembersLoaded.value = true;

  }

}