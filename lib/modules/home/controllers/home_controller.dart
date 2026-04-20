import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/post/post.dart';

import '../../../core/utils/app_colors.dart';

class HomeController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  final ScrollController postScrollController = ScrollController();
  final postsHelper = PaginationHelper<Post>();
  RxList<Post> displayPosts = <Post>[].obs;
  List<Post> originalFeedBackup = <Post>[];

  TextEditingController searchController = TextEditingController();

  RxBool isLikeLoading = false.obs;
  Timer? _debounce;

  @override
  void onInit() {

    setupSearchListener();
    initPostsHelper(searchQuery: "");

    if (displayPosts.isEmpty) {
      getPosts();
    }
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
        initPostsHelper(searchQuery: query);
        getPosts(isSearch: true);
      }else{
        initPostsHelper(searchQuery: "");
        displayPosts.assignAll(originalFeedBackup);
      }
    });
  }
  void initPostsHelper({required String searchQuery}){
    postsHelper.init(
        endPoint: (page) => ApiEndpoints.getAllCommunityPosts(page: page, searchQuery: searchQuery),
        fromJson: (json) => Post.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
      scrollController: postScrollController
    );
  }

  //GET POSTS
  Future<void> getPosts({bool isSearch = false}) async {
    await postsHelper.fetch(isRefresh: true);
    displayPosts.assignAll(postsHelper.items);
    if( !isSearch ){
      originalFeedBackup.assignAll(postsHelper.items);
    }
  }

  //==========GET POST BY ID - AFTER UPDATE========
  Future<void> getPostById({required String postId}) async{
    final post = displayPosts.firstWhereOrNull((p) => p.id == postId);
    if( post != null ){
      final ApiResponse response = await apiService.networkRequest(
          method: "GET",
          isAuthRequired: true,
          endPoint: ApiEndpoints.getCommunityPostById(postId: postId)
      );
      //postsHelper.items.refresh();
    }
  }

  //==================LIKE/UNLIKE POST==========================
  Future<void> likeUnlikePost({required String postId}) async{

    if( isLikeLoading.value ){
      return;
    }

    isLikeLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.likeUnlikeCommunityPost( id: postId )
    );

    isLikeLoading.value = false;

    if( response.statusCode == 200 ){
      final post = displayPosts.firstWhereOrNull((p) => p.id == postId);
      if( post != null ){
        post.isLikedByMe = !post.isLikedByMe;
        post.likesCount = post.isLikedByMe ? post.likesCount + 1 : post.likesCount - 1;
        displayPosts.refresh();
      }
    }
  }

  //====================DELETE POST=============================
  Future<void> deletePost({required String postId}) async{

    showDeletingAlert();
    ApiResponse response = await apiService.networkRequest(
        method: "DELETE",
        isAuthRequired: true,
        endPoint: ApiEndpoints.deleteCommunityPost(postId: postId)
    );

    if( Get.isDialogOpen ?? false ){
      Get.back();
    }

    if( response.statusCode == 200 ){
      displayPosts.removeWhere((p) => p.id == postId);
      displayPosts.refresh();
    }
  }


//DELETE ACCOUNT DIALOG
  void showDeleteDialog({required String postId}) async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.white,
          title: Column(
            children: [
              Text(
                "Delete post",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete this post?",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CupertinoColors.inactiveGray, width: 2.r)
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Delete button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async{
                        Get.back();
                        deletePost( postId: postId );
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  //DELETING ALERT
  Future<void> showDeletingAlert() async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),),
              SizedBox(
                height: 15.h,
              ),
              Text("Deleting...", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),)
            ],
          ),
        )
    );
  }

  @override
  void onClose() {

    postScrollController.dispose();
    searchController.dispose();
    if ( _debounce?.isActive ?? false ) _debounce!.cancel();

    super.onClose();
  }

}
