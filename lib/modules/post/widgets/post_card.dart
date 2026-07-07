import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/modules/post/widgets/post_menu_button.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/time_ago_calculator.dart';
import '../../../data/models/post/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final bool isMyPost;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const PostCard({
    super.key,
    required this.post,
    required this.isMyPost,
    required this.onTap,
    required this.onFavouriteTap,
    this.onEdit,
    this.onDelete,
    this.onReport
  });
  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    String affiliation = Affiliation.values
        .firstWhere((element) => element.value == post.affiliation)
        .displayName;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row (Avatar, Name, Time + PopupMenu)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 40.h,
                      width: isTab ? 40.h : 40.w,
                      color: Colors.grey.shade200,
                      child: CachedImageWidget(
                        imageUrl: post.authorImage,
                        iconSize: 30.r,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
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
                            //SvgPicture.asset(Assets.icons.verified, height: isTab ? 20 : null, width: isTab ? 20 : null,),
                          ],
                        ),
                        Text(
                          "$affiliation • ${timeAgo(post.createdAt)}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isTab ? 10.sp : 12,
                          ),
                        ),
                        Row(
                          children: [
                             Icon(
                              Icons.location_pin,
                              size: isTab ? 20 : 12,
                              color: Colors.grey,
                            ),
                            Text(
                              post.stationName,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: isTab ? 10.sp : 12
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // --- Added PopupMenuButton here ---
                  PostMenuButton(
                      isMyPost: isMyPost,
                    onEdit: () => onEdit?.call(),
                    onDelete: () => onDelete?.call(),
                    onReport: () => onReport?.call(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Post Content
              Text(
                  post.content,
                  style: TextStyle(fontSize: isTab ? 12.sp : 14, height: 1.4)
              ),

              // --- Attachments Section ---
              if (post.attachments.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildAttachments(post.attachments),
              ],

              const Divider(height: 32),

              // Interaction Row
              Row(
                children: [
                  InkWell(
                    onTap: onFavouriteTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            height: isTab ? 30 : null,
                            width: isTab ? 30 : null,
                            post.isLikedByMe ? Assets.icons.favouriteFill : Assets.icons.favouriteOutlined,
                            colorFilter:  post.isLikedByMe ? ColorFilter.mode(Colors.red.shade400, BlendMode.srcIn) : null,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${post.likesCount}",
                            style: TextStyle(color: Colors.grey, fontSize:  isTab ? 12.sp : null),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  SvgPicture.asset(Assets.icons.chat, height: isTab ? 30 : null, width: isTab ? 30 : null,),
                  const SizedBox(width: 4),
                  Text(
                    "${post.commentsCount}",
                    style: TextStyle(color: Colors.grey, fontSize:  isTab ? 12.sp : null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachments(List<String> images) {
    int count = images.length;

    return Container(
      constraints: BoxConstraints(maxHeight: 300.h), // Cap the grid height
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _createGrid(images, count),
      ),
    );
  }

  Widget _createGrid(List<String> images, int count) {
    if (count == 1) {
      return _imageItem(images[0]);
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(child: _imageItem(images[0])),
          const SizedBox(width: 2),
          Expanded(child: _imageItem(images[1])),
        ],
      );
    } else if (count == 3) {
      return Row(
        children: [
          Expanded(child: _imageItem(images[0])),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _imageItem(images[1])),
                const SizedBox(height: 2),
                Expanded(child: _imageItem(images[2])),
              ],
            ),
          ),
        ],
      );
    } else {
      // 4 or more images
      return Row(
        children: [
          Expanded(child: _imageItem(images[0])),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _imageItem(images[1])),
                const SizedBox(height: 2),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _imageItem(images[2]),
                      if (count > 3)
                        Container(
                          color: Colors.black45,
                          child: Center(
                            child: Text(
                              "+${count - 2}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _imageItem(String url) {
    return SizedBox.expand(child: CachedImageWidget(imageUrl: url));
  }
}
