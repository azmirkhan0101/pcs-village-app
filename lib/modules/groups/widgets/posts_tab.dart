import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/data/models/post/post.dart';
import 'package:pcs_village/routes/app_pages.dart';
import '../../post/widgets/post_card.dart';

class PostsTab extends StatelessWidget {
  final RxList<Post> posts;
  final RxBool isLoading;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final Function(String postID) onFavouriteTap;
  final Function(String postID) onDelete;
  final String userId;

  const PostsTab({
    super.key,
    required this.posts,
    required this.isLoading,
    required this.scrollController,
    required this.onRefresh,
    required this.onFavouriteTap,
    required this.onDelete,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: AppColors.primaryColor,
      onRefresh: onRefresh,
      child: Obx(() {
        //Initial Loading State
        if (isLoading.value && posts.isEmpty) {
          return _buildSkeletonList();
        }

        //Empty State
        if (posts.isEmpty) {
          return _buildEmptyState();
        }

        //List View with Pagination support
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: posts.length + 2, // +1 for Header, +1 for Bottom Loader
          itemBuilder: (context, index) {
            // Section Title Header
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Group Discussion',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A365D),
                  ),
                ),
              );
            }

            // Pagination Loader at the bottom
            if (index == posts.length + 1) {
              return isLoading.value
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
                  : const SizedBox(height: 80);
            }

            // Post Card Item
            final post = posts[index - 1];
            return PostCard(
              post: post,
              onTap: () => Get.toNamed(
                  AppRoutes.postDetails,
                  arguments: {
                    'isGroup': true,
                    'postId' : post.id
                  }
              ),
              onFavouriteTap: (){
                onFavouriteTap(post.id);
              },
              isMyPost: post.authorId == userId,
              onEdit: (){
                Get.toNamed(
                    AppRoutes.editPost,
                    arguments: {
                      "isGroup" : true,
                      "post" : post
                    }
                );
              },
              onDelete: (){
                onDelete(post.id);
              },
              onReport: (){
                Get.toNamed(
                  AppRoutes.reportPost,
                  arguments: {
                    "isGroup" : true,
                    "postId" : post.id
                  }
                );
              },
            );
          },
        );
      }),
    );
  }

  //Skeleton Loader
  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => const SkeletonPostCard(),
    );
  }

  //Empty State
  Widget _buildEmptyState() {
    return ListView( // Wrap in ListView so RefreshIndicator still works
      children: [
        SizedBox(height: Get.height * 0.15),
        const Center(
          child: Column(
            children: [
              Icon(Icons.post_add, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No posts yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SkeletonPostCard extends StatelessWidget {
  const SkeletonPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey[300], radius: 20),
              const SizedBox(width: 12),
              Container(width: 100, height: 12, color: Colors.grey[300]),
            ],
          ),
          const SizedBox(height: 16),
          Container(width: double.infinity, height: 12, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Container(width: 200, height: 12, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Container(width: double.infinity, height: 150, color: Colors.grey[200]),
        ],
      ),
    );
  }
}