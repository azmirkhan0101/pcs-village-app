import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/groups/group_model.dart';

import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';
import '../../../data/models/post/post.dart';

class GroupsDetailsController extends GetxController with GetSingleTickerProviderStateMixin{

  final ApiService apiService = Get.find<ApiService>();
  late TabController tabController;

  late GroupModel groupModel;
  RxBool isJoined = false.obs;

  RxBool isLeaving = false.obs;
  RxBool isJoining = false.obs;

  RxList<Post> posts = <Post>[].obs;
  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool hasMorePosts = true;
  RxBool isPostsLoading = false.obs;
  RxBool isPostsMoreLoading = false.obs;

  // Loaded flags to control redundant loading in tab change if data is already empty
  RxBool isPostsLoaded = false.obs;
  RxBool isMembersLoaded = false.obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    groupModel = Get.arguments as GroupModel;
    isJoined.value = groupModel.isAlreadyJoined;

    if( posts.isEmpty && isJoined.value ){
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

    scrollController.addListener((){
      if( scrollController.position.pixels == scrollController.position.maxScrollExtent * 0.9 ){
        getPosts(refresh: false);
      }
    });
    super.onInit();
  }

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
    }
  }

  //GET POSTS
  Future<void> getPosts({bool refresh = true}) async{

    if( isPostsLoading.value || isPostsMoreLoading.value ){
      return;
    }

    if( refresh ){
      currentPage = 1;
      hasMorePosts = true;
      isPostsLoading.value = true;
    }else{
      if( isPostsMoreLoading.value == true || hasMorePosts == false ){
        return;
      }
      isPostsMoreLoading.value = true;
    }

    ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getGroupPosts(groupId: groupModel.id)
    );
    isPostsLoaded.value = true;
    isPostsLoading.value = false;
    isPostsMoreLoading.value = false;

    if( response.statusCode == 200 ){
      final fetchedPosts = response.data['data'] as List<dynamic>?;
      if( fetchedPosts is List && fetchedPosts.isNotEmpty ){
        if( refresh ){
          posts.assignAll(fetchedPosts.map((e){
            return Post.fromJson(e);
          }).toList());
        }else{
          posts.addAll(fetchedPosts.map((e){
            return Post.fromJson(e);
          }).toList());
        }
        if( fetchedPosts.length < 10 ){
          hasMorePosts = false;
        }else{
          currentPage++;
        }
      }
    }
  }

  Future<void> getMembers() async{

  }
}