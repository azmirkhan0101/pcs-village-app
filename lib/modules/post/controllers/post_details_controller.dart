import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/helper/pagination_helper.dart';
import 'package:pcs_village/core/services/api_service.dart';
import 'package:pcs_village/core/utils/api_endpoints.dart';
import 'package:pcs_village/core/utils/api_response.dart';
import 'package:pcs_village/data/models/post/comment_model.dart';
import 'package:pcs_village/data/models/post/post.dart';

class PostDetailsController extends GetxController {

  final ApiService apiService = Get.find<ApiService>();
  final ScrollController scrollController = ScrollController();
  final commentsHelper = PaginationHelper<Comment>();

  RxBool isLikeLoading = false.obs;

  late Post post;
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

  @override
  void onInit() {

    isGroup = Get.arguments['isGroup'] as bool? ?? false;
    post = Get.arguments['post'] as Post;

    initCommentsHelper();

    if( commentsHelper.items.isEmpty ){
      getPostComments();
    }

    super.onInit();
  }

  void initCommentsHelper(){
    commentsHelper.init(
        endPoint: (page) => isGroup
            ? ApiEndpoints.getGroupPostComments(postId: post.id, page: page)
            : ApiEndpoints.getPostComments(id: post.id, page: page),
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

    if( isLikeLoading.value ){
      return;
    }

    isLikeLoading.value = true;

    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: isGroup ? ApiEndpoints.groupPostLikeUnlike(postId: post.id ): ApiEndpoints.likeUnlikePost(id: post.id)
    );

    isLikeLoading.value = false;
}

//=====================COMMENT==================================
Future<void> addComment({required String comment}) async{
    ApiResponse response = await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: isGroup ? ApiEndpoints.addGroupPostComment : ApiEndpoints.addComment,
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
    await apiService.networkRequest(
        method: "POST",
        isAuthRequired: true,
        endPoint: isGroup ? ApiEndpoints.addGroupPostComment : ApiEndpoints.addComment,
        body: {
          "content": content,
          "post": post.id,
          "parent" : parentCommentId
        }
    );
    getPostComments();
    commentController.clear();
    cancelReply();
  }
}
