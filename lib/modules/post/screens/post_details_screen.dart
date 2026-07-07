import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/utils/time_ago_calculator.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/modules/post/controllers/post_details_controller.dart';
import 'package:pcs_village/modules/post/widgets/comment_input_bar.dart';
import 'package:pcs_village/modules/post/widgets/comment_skeleton_loader.dart';
import 'package:pcs_village/modules/post/widgets/post_menu_button.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/extensions.dart';
import '../../../routes/app_pages.dart';
import '../../profile/controllers/profile_controller.dart';
import '../widgets/comment_card.dart';

class PostDetailsScreen extends StatelessWidget {
  PostDetailsScreen({super.key});

  final PostDetailsController controller = Get.find<PostDetailsController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        title: Text(
          'Post',
          style: TextStyle(
            fontSize: isTab ? 12.sp : null,
            color: Color(0xFF1A365D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        final post = controller.post.value;
        if (post == null) {
          return const Center(child: CircularProgressIndicator());
        }

        String affiliation = Affiliation.values
            .firstWhereOrNull(
              (element) => element.value == post.affiliation,
        )
            ?.displayName ??
            Affiliation.activeDuty.displayName;

        return Column(
          children: [
            Expanded(
              child: ListView(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16.0),
                children: [
                  // --- Author Header ---
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: isTab ? 65 : 30.h,
                          width: isTab ? 65 : 30.w,
                          color: Colors.grey.shade200,
                          child: CachedImageWidget(
                            imageUrl: post.authorImage,
                            iconSize: 27,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.authorName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTab ? 12.sp : 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                               Icon(
                                Icons.verified,
                                size: isTab ? 30 : 16,
                                color: Colors.blueGrey,
                              ),
                            ],
                          ),
                          Text(
                            '$affiliation • ${timeAgo(post.createdAt)}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: isTab ? 10.sp : 12,
                            ),
                          ),
                          Row(
                            children: [
                               Icon(
                                Icons.location_on_outlined,
                                size: isTab ? 25 :  14,
                                color: Colors.grey,
                              ),
                              Text(
                                ' ${post.stationName}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: isTab ? 10.sp : 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      PostMenuButton(
                          isMyPost: profileController.profileModel.value?.id == post.authorId,
                          onDelete: () {
                            controller.showDeleteDialog(postId: post.id);
                          },
                          onEdit: () {
                            Get.toNamed(
                                AppRoutes.editPost,
                                arguments: {
                                  "isGroup" : controller.isGroup,
                                  "post" : post
                                }
                            );
                          },
                        onReport: (){
                            Get.toNamed(
                              AppRoutes.reportPost,
                              arguments: {
                                "isGroup": controller.isGroup,
                                "postId": post.id
                              }
                            );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Post Content ---
                  Text(
                    post.content,
                    style: TextStyle(
                      fontSize: isTab ? 12.sp : 15,
                      height: 1.4,
                      color: Color(0xFF2D3748),
                    ),
                  ),

                  // --- Post Attachments ---
                  if (post.attachments.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: post.attachments.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 300.w,
                              color: Colors.grey.shade100,
                              child: CachedImageWidget(
                                imageUrl: post.attachments[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // --- Post Stats (Likes/Comments) ---
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => controller.likeUnlikePost(),
                        icon: SvgPicture.asset(
                          height: isTab ? 30 : null,
                          width: isTab ? 30 : null,
                          post.isLikedByMe ? Assets.icons.favouriteFill : Assets.icons.favouriteOutlined,
                          colorFilter:  post.isLikedByMe ? ColorFilter.mode(Colors.red.shade400, BlendMode.srcIn) : null,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likesCount}',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: isTab ? 12.sp : null),
                      ),
                      const SizedBox(width: 20),
                      SvgPicture.asset(
                          height: isTab ? 30 : null,
                          width: isTab ? 30 : null,
                          Assets.icons.chat),
                      const SizedBox(width: 4),
                      Text(
                        '${post.commentsCount}',
                        style: TextStyle(color: Colors.grey,
                        fontSize: isTab ? 12.sp : null,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                   Text(
                    'Comments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTab ? 12.sp : 18,
                      color: Color(0xFF1A365D),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Comments Helper Section ---
                  commentsSection(isTab: isTab),
                ],
              ),
            ),

            // --- Bottom Input Field ---
            Obx(() => CommentInputBar(
              textController: controller.commentController,
              profileImageUrl: profileController.profileModel.value?.profileImage,
              replyingToName: controller.replyingToComment.value?.authorName,
              onCancelReply: () => controller.cancelReply(),
              onSend: () {
                if (controller.replyingToComment.value != null) {
                  controller.addReply(
                    parentCommentId: controller.replyingToComment.value!.id,
                    content: controller.commentController.text,
                  );
                } else {
                  controller.addComment(comment: controller.commentController.text);
                }
              },
            )
            ),
          ],
        );
      }),
    );
  }

  //===============COMMENT SECTION===================
  Widget commentsSection({required bool isTab}) {
    return Obx(() {
      if (controller.commentsHelper.isLoading.value) {
        return CommentSkeletonLoader();
      }

      if (controller.commentsHelper.items.isEmpty) {
        return noComments(isTab: isTab);
      }

      return Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.commentsHelper.items.length,
            itemBuilder: (context, index) {
              final comment = controller.commentsHelper.items[index];
              return Obx(() => CommentCard(
                comment: comment,
                isReply: false,
                isMe: comment.isMyComment,
                onDeleteTap: (){
                  controller.deleteComment(commentId: comment.id);
                },
                isExpanded: controller.expandedCommentIds.contains(comment.id),
                onReplyTap: () => controller.setReplyingTo(comment),
                onToggleReplies: () => controller.toggleReplies(comment.id),
                replyBuilder: (reply) => CommentCard(
                  comment: reply,
                  isReply: true,
                  isMe: reply.isMyComment,
                  onDeleteTap: (){
                    controller.deleteComment(commentId: reply.id, isReply: true);
                  },
                ),
              ));
            },
          ),
          if (controller.commentsHelper.isMoreLoading.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator())
            ),
        ],
      );
    });
  }

  //=================NO COMMENTS===================
  Widget noComments({required bool isTab}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text("No Comments Yet", style: TextStyle(color: Colors.grey.shade500, fontSize: isTab ? 12.sp : 16)),
          ],
        ),
      ),
    );
  }
}