import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/utils/time_ago_calculator.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/data/models/post/comment_model.dart';
import 'package:pcs_village/modules/post/controllers/post_details_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../profile/controllers/profile_controller.dart';

class PostDetailsScreen extends StatelessWidget {
  PostDetailsScreen({super.key});

  final PostDetailsController controller = Get.find<PostDetailsController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    String affiliation =
        Affiliation.values
            .firstWhereOrNull(
              (element) => element.value == controller.post.affiliation,
            )
            ?.displayName ??
        Affiliation.activeDuty.displayName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        title: const Text(
          'Post',
          style: TextStyle(
            color: Color(0xFF1A365D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(16.0),
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 30.h,
                        width: 30.w,
                        color: Colors.grey.shade200,
                        child: CachedImageWidget(
                          imageUrl: controller.post.authorImage,
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
                              controller.post.authorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.blueGrey,
                            ),
                          ],
                        ),
                        Text(
                          '$affiliation • ${timeAgo(controller.post.createdAt)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            Text(
                              ' ${controller.post.stationName}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Post Content ---
                Text(
                  controller.post.content,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Color(0xFF2D3748),
                  ),
                ),

                // --- Post Attachments ---
                if (controller.post.attachments.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.post.attachments.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 300.w,
                            color: Colors.grey.shade100,
                            child: CachedImageWidget(
                              imageUrl: controller.post.attachments[index],
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
                      onPressed: () {
                        controller.likeUnlikePost();
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.post.likesCount}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(Assets.icons.chat),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.post.commentsCount}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const Divider(height: 32),

                const Text(
                  'Comments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1A365D),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Reactive Comment Section ---
                Obx(() {
                  if (controller.commentsHelper.isLoading.value) {
                    return _buildSkeletonLoader();
                  }

                  if (controller.commentsHelper.items.isEmpty) {
                    return _buildEmptyState();
                  }

                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.commentsHelper.items.length,
                        itemBuilder: (context, index) {
                          final comment = controller.commentsHelper.items[index];
                          return _buildCommentTile(
                            comment: comment,
                            isReply: false
                          );
                        },
                      ),
                      // Bottom loader for pagination
                      if (controller.commentsHelper.isMoreLoading.value)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),

          // --- Bottom Input Field ---
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SafeArea(
                child: Column(
                  // Change Row to Column to stack the reply bar
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Reply Indicator ---
                    if (controller.replyingToComment.value != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.reply,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Replying to ${controller.replyingToComment.value!.authorName}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.cancelReply(),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                    Row(
                      // Your existing input row
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 35,
                            width: 35,
                            color: Colors.grey.shade200,
                            child: Obx(() {
                              return CachedImageWidget(
                                imageUrl:
                                    profileController
                                        .profileModel
                                        .value
                                        ?.profileImage ??
                                    "",
                                iconSize: 25,
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: controller.commentController,
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.replyingToComment.value != null) {
                                      controller.addReply(
                                        parentCommentId: controller.replyingToComment.value!.id,
                                        content: controller.commentController.text,
                                      );
                                    } else {
                                      controller.addComment(comment: controller.commentController.text);
                                    }
                                  },
                                  child: SvgPicture.asset(Assets.icons.send),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Bottom Input Field ---
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border(top: BorderSide(color: Colors.grey.shade200)),
          //   ),
          //   child: SafeArea(
          //     child: Row(
          //       children: [
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(100),
          //           child: Container(
          //             height: 35,
          //             width: 35,
          //             color: Colors.grey.shade200,
          //             child: Obx((){
          //               return CachedImageWidget(
          //                   imageUrl: profileController.profileModel.value?.profileImage ?? "",
          //                 iconSize: 25,
          //               );
          //             }),
          //           ),
          //         ),
          //         const SizedBox(width: 12),
          //         Expanded(
          //           child: TextField(
          //             controller: controller.commentController,
          //             decoration: InputDecoration(
          //               hintText: 'Write a comment...',
          //               filled: true,
          //               fillColor: Colors.grey.shade100,
          //               contentPadding: const EdgeInsets.symmetric(
          //                 horizontal: 16,
          //                 vertical: 8,
          //               ),
          //               border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(20),
          //                 borderSide: BorderSide.none,
          //               ),
          //               suffixIcon: Padding(
          //                 padding: const EdgeInsets.all(12.0),
          //                 child: GestureDetector(
          //                   onTap: (){
          //                     controller.addComment(comment: controller.commentController.text);
          //                   },
          //                     child: SvgPicture.asset(Assets.icons.send)),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 50,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              "No Comments Yet",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 18, backgroundColor: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentTile({required Comment comment, required bool isReply}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 35,
                  width: 35,
                  color: Colors.grey.shade200,
                  child: CachedImageWidget(imageUrl: comment.authorProfileImg ?? "", iconSize: 27),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.authorName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(Assets.icons.verified),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text( comment.content, style: const TextStyle(color: Color(0xFF4A5568))),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(timeAgo(comment.createdAt), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(width: 16),
                          //HIDE REPLY BUTTON IF REPLY WIDGET
                          if( !isReply )
                          GestureDetector(
                            onTap: () => controller.setReplyingTo(comment),
                            child: const Text('Reply', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
                          ),

                          //HIDE REPLIES/HIDE REPLIES BUTTON IF REPLY WIDGET
                          if (comment.replies.isNotEmpty && !isReply ) ...[
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => controller.toggleReplies(comment.id),
                              child: Obx(() => Text(
                                controller.expandedCommentIds.contains(comment.id)
                                    ? 'Hide Replies'
                                    : 'Replies (${comment.replies.length})',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A365D)
                                ),
                              )),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Nested Replies List ---
        Obx(() {
          if (controller.expandedCommentIds.contains(comment.id)) {
            return Padding(
              padding: const EdgeInsets.only(left: 44.0),
              child: Column(
                children: comment.replies!.map((reply) => _buildCommentTile(comment:  reply, isReply: true)).toList(),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // Widget _buildCommentTile({
  //   required Comment comment
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(100),
  //           child: Container(
  //             height: 35,
  //             width: 35,
  //             color: Colors.grey.shade200,
  //             child: CachedImageWidget(imageUrl: comment.authorProfileImg ?? "", iconSize: 27),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Container(
  //             padding: const EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: const Color(0xFFF7F8F4),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Text(
  //                       comment.authorName,
  //                       style: const TextStyle(fontWeight: FontWeight.bold),
  //                     ),
  //                     const SizedBox(width: 4),
  //                     SvgPicture.asset(Assets.icons.verified),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text( comment.content, style: const TextStyle(color: Color(0xFF4A5568))),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       timeAgo(comment.createdAt),
  //                       style: const TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.grey,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     TextButton(
  //                         onPressed: (){
  //                           controller.setReplyingTo(comment);
  //                         }, child: Text(
  //                       'Reply',
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w500,
  //                         color: Colors.grey,
  //                       ),
  //                     )),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
