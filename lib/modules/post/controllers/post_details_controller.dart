import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/post/comment_model.dart';
import 'package:pcs_village/data/models/post/post.dart';

class PostDetailsController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool hasMoreComments = true;
  RxBool isCommentsLoading = false.obs;
  RxBool isCommentsMoreLoading = false.obs;
  RxList<Comment> comments = <Comment>[].obs;

  RxBool isLikeLoading = false.obs;

  final TextEditingController commentController = TextEditingController();

  late Post post;

  final FocusNode commentFocusNode = FocusNode();

  Rxn<Comment> replyingToComment = Rxn<Comment>();
  void toggleReplies(String id) => expandedCommentIds.contains(id) ? expandedCommentIds.remove(id) : expandedCommentIds.add(id);

  var expandedCommentIds = <String>{}.obs;

  void setReplyingTo(Comment comment) {
    replyingToComment.value = comment;
    commentFocusNode.requestFocus();
  }

  void cancelReply() {
    replyingToComment.value = null;
    commentFocusNode.unfocus();
  }

  @override
  void onInit() {
    post = Get.arguments;

    getPostComments();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent * 0.9) {
        //getPosts(refresh: false);
      }
    });
    super.onInit();
  }

  //GET POSTS
  Future<void> getPostComments({bool refresh = true}) async {
    if (refresh) {
      currentPage = 1;
      hasMoreComments = true;
      isCommentsLoading.value = true;
    } else {
      if (isCommentsMoreLoading.value == true || hasMoreComments == false) {
        return;
      }
      isCommentsMoreLoading.value = true;
    }

    ApiResponse response = await apiService.networkRequest(
      method: "GET",
      isAuthRequired: true,
      endPoint: ApiEndpoints.getPostComments(id: post.id),
    );

    isCommentsLoading.value = false;
    isCommentsMoreLoading.value = false;

    if (response.statusCode == 200) {
      final fetchedComments = response.data['data'] as List<dynamic>?;
      if (fetchedComments is List && fetchedComments.isNotEmpty) {
        if (refresh) {
          comments.assignAll(
            fetchedComments.map((e) {
              return Comment.fromJson(e);
            }).toList(),
          );
        } else {
          comments.addAll(
            fetchedComments.map((e) {
              return Comment.fromJson(e);
            }).toList(),
          );
        }
        if (fetchedComments.length < 10) {
          hasMoreComments = false;
        } else {
          currentPage++;
        }
      }
    }
  }

  //==================LIKE/UNLIKE POST==========================
Future<void> likeUnlikePost() async{

    if( isLikeLoading.value ){
      return;
    }

    isLikeLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.likeUnlikePost(id: post.id)
    );

    isLikeLoading.value = false;
}

//=====================COMMENT==================================
Future<void> addComment({required String comment}) async{
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.addComment,
        body: {
          "content": comment,
          "post": post.id
        }
    );
    getPostComments();
    commentController.clear();
}

//=====================REPLY==================================
  Future<void> addReply({required String parentCommentId, required String content}) async{
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: ApiEndpoints.addComment,
        body: {
          "content": content,
          "post": post.id,
          "parent" : parentCommentId
        }
    );
    getPostComments();
    commentController.clear();
  }
}
