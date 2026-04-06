import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../data/models/post/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {

    String affiliation = Affiliation.values.firstWhere((element) => element.value == post.affiliation).displayName;

    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade400)),
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      color: Colors.grey.shade200,
                      child: CachedImageWidget(
                          imageUrl: post.authorImage,
                        iconSize: 30.r,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          //const Icon(Icons.check_circle, size: 14, color: Colors.blue),
                          SvgPicture.asset(Assets.icons.verified)
                        ],
                      ),
                      Text("$affiliation • ${timeAgo(post.createdAt)}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Row(
                        children: [
                          const Icon(Icons.location_pin, size: 12, color: Colors.grey),
                          Text(post.stationName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(post.content, style: const TextStyle(fontSize: 14, height: 1.4)),
              const Divider(height: 32),
              Row(
                children: [
                  SvgPicture.asset(Assets.icons.favouriteOutlined),
                  //const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("${post.likes}", style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 24),
                  //const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
                  SvgPicture.asset(Assets.icons.chat),
                  const SizedBox(width: 4),
                  Text("${post.comments}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String timeAgo(DateTime postTime) {
    final Duration difference = DateTime.now().toUtc().difference(postTime);

    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()} y';
    } else if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()} mo';
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()} w';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} d';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} h';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} min';
    } else {
      return 'just now';
    }
  }
}