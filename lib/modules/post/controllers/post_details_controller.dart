import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/core/utils/show_snackbar.dart';
import 'package:pcs_village/data/models/post/comment_model.dart';
import 'package:pcs_village/data/models/post/post.dart';
import 'package:pcs_village/modules/groups/controllers/groups_details_controller.dart';
import 'package:pcs_village/modules/home/controllers/home_controller.dart';

import '../../../core/utils/app_colors.dart';

class PostDetailsController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  final ScrollController scrollController = ScrollController();
  final commentsHelper = PaginationHelper<Comment>();

  RxBool isLikeLoading = false.obs;
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  Rxn<Comment> replyingToComment = Rxn<Comment>();
  void toggleReplies(String id) => expandedCommentIds.contains(id)
      ? expandedCommentIds.remove(id)
      : expandedCommentIds.add(id);
  var expandedCommentIds = <String>{}.obs;

  void setReplyingTo(Comment comment) {
    replyingToComment.value = comment;
    commentFocusNode.requestFocus();
  }

  void cancelReply() {
    replyingToComment.value = null;
    commentFocusNode.unfocus();
  }

  //GROUP POST OR COMMUNITY POST
  late bool isGroup;
  late String postId;
  Rxn<Post> post = Rxn<Post>();

  HomeController? homeController;
  GroupsDetailsController? groupsDetailsController;

  @override
  void onInit() {

    isGroup = Get.arguments['isGroup'] as bool? ?? false;
    postId = Get.arguments['postId'] as String;

    if (isGroup) {
      groupsDetailsController = Get.find<GroupsDetailsController>();
    } else {
      homeController = Get.find<HomeController>();
    }

    post.value = getPost;

    initCommentsHelper();

    if( commentsHelper.items.isEmpty ){
      getPostComments();
    }

    super.onInit();
  }

  Post get getPost {
    if (isGroup) {
      return groupsDetailsController!.postsHelper.items
          .firstWhere((p) => p.id == postId);
    } else {
      return homeController!.displayPosts
          .firstWhere((p) => p.id == postId);
    }
  }

  void initCommentsHelper(){
    commentsHelper.init(
        endPoint: (page) => isGroup
            ? ApiEndpoints.getGroupPostComments(postId: post.value!.id, page: page)
            : ApiEndpoints.getCommunityPostComments(id: post.value!.id, page: page),
        fromJson: (json) => Comment.fromJson(json),
        listExtractor: (data) => data['data'] as List<dynamic>?,
        scrollController: scrollController
    );
  }

  //GET POSTS
  Future<void> getPostComments() async {
    await commentsHelper.fetch(isRefresh: true);
  }

  //==================LIKE/UNLIKE POST==========================
Future<void> likeUnlikePost() async{

    if( isLikeLoading.value || post.value == null ){
      return;
    }

    isLikeLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: isGroup ? ApiEndpoints.groupPostLikeUnlike(postId: post.value!.id ): ApiEndpoints.likeUnlikeCommunityPost(id: post.value!.id)
    );

    isLikeLoading.value = false;

    if( response.statusCode == 200 ){
      post.value!.isLikedByMe = !post.value!.isLikedByMe;
      post.value!.likesCount = post.value!.isLikedByMe ? post.value!.likesCount + 1 : post.value!.likesCount - 1;
      post.refresh();
      if( isGroup ){
        groupsDetailsController!.postsHelper.items.refresh();
      } else {
        homeController!.displayPosts.refresh();
      }
    }
}

//=====================COMMENT==================================
Future<void> addComment({required String comment}) async{
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: isGroup ? ApiEndpoints.addGroupPostComment : ApiEndpoints.addCommunityComment,
        body: {
          "content": comment,
          "post": post.value?.id
        }
    );

    if( response.statusCode == 200 || response.statusCode == 201 ){
      getPostComments();
      commentController.clear();
      post.value?.commentsCount += 1;
      post.refresh();
      if( isGroup ){
        groupsDetailsController!.postsHelper.items.refresh();
      } else {
        homeController!.displayPosts.refresh();
      }
    }else{
      showApiSnackBar(
          statusCode: response.statusCode,
        data: response.data
      );
    }
}

//=====================REPLY==================================
  Future<void> addReply({required String parentCommentId, required String content}) async{
    await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: isGroup ? ApiEndpoints.addGroupPostComment : ApiEndpoints.addCommunityComment,
        body: {
          "content": content,
          "post": post.value?.id,
          "parent" : parentCommentId
        }
    );
    getPostComments();
    commentController.clear();
    cancelReply();
  }

  //====================DELETE COMMENT OR REPLY====================
  Future<void> deleteComment({required String commentId, bool isReply = false}) async{
    ApiResponse response = await apiService.networkRequest(
        method: "DELETE",
        isAuthRequired: true,
        endPoint: isGroup ? ApiEndpoints.deleteGroupPostComment(commentId: commentId) : ApiEndpoints.deleteCommunityComment(commentId: commentId)
    );

    if( response.statusCode == 200 ){

      if( isReply ){
        return;
      }

      post.value?.commentsCount -= 1;
      post.refresh();
      getPostComments();
      if( isGroup ){
        groupsDetailsController!.postsHelper.items.refresh();
      } else {
        homeController!.displayPosts.refresh();
      }
    }
  }

  //====================DELETE POST=============================
  Future<void> deletePost({required String postId}) async{

    showDeletingAlert();
    ApiResponse response = await apiService.networkRequest(
        method: "DELETE",
        isAuthRequired: true,
        endPoint: isGroup ? ApiEndpoints.deleteGroupPost(postId: postId) : ApiEndpoints.deleteCommunityPost(postId: postId)
    );

    if( Get.isDialogOpen ?? false ){
      Get.back();
    }

    if( response.statusCode == 200 ){
      if( isGroup ){
        groupsDetailsController?.postsHelper.items.removeWhere((p) => p.id == postId);
        groupsDetailsController?.postsHelper.items.refresh();
      } else {
        homeController?.displayPosts.removeWhere((p) => p.id == postId);
        homeController?.displayPosts.refresh();
      }
      Get.back();
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
}
