import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/extensions.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../data/models/post/post.dart';
import '../controllers/home_controller.dart';
import '../../post/widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: const Color(0xFF1B365D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Text(
                  profileController.profileModel.value?.currentStation?.name ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: isTab ? 12.sp : null));
            }),
             Text('Community Feed', style: TextStyle(fontSize: isTab ? 10.sp : 14, color: Colors.white70)),
          ],
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColors.primaryColor,
        onRefresh: () async {
          await controller.getPosts();
        },
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontSize: isTab ? 10.sp : null),
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Search posts...",
                  hintStyle: TextStyle(color: Colors.white60, fontSize: isTab ? 10.sp : null),
                  prefixIcon: const Icon(Icons.search, color: Colors.white60),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
            ),

            // Feed Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Obx(() {
                  // 1. Initial Loading State
                  if (controller.postsHelper.isLoading.value && controller.displayPosts.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primaryColor),
                    );
                  }

                  // 2. Empty State
                  if (controller.displayPosts.isEmpty) {
                    return ListView( // Using ListView so RefreshIndicator still works
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                         Center(
                          child: Column(
                            children: [
                              Icon(Icons.post_add, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text("No posts found",
                                  style: TextStyle(color: Colors.grey, fontSize: isTab ? 12.sp : 16)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  // 3. Data List with Pagination Loader
                  return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.displayPosts.length + 1, // Add 1 for the loader
                      controller: controller.postScrollController,
                      itemBuilder: (context, index) {
                        // Check if we reached the end of the list
                        if (index == controller.displayPosts.length) {
                          return Obx(() => controller.postsHelper.isMoreLoading.value
                              ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                              : const SizedBox(height: 80)); // Bottom padding
                        }

                        final Post post = controller.displayPosts[index];

                        return PostCard(
                          onTap: () {
                            Get.toNamed(AppRoutes.postDetails,
                                arguments: {'isGroup': false, 'postId': post.id});
                          },
                          post: post,
                          onFavouriteTap: () {
                            controller.likeUnlikePost(postId: post.id);
                          },
                          isMyPost: profileController.profileModel.value?.id == post.authorId,
                          onEdit: () {
                            Get.toNamed(AppRoutes.editPost,
                                arguments: {"isGroup": false, "post": post});
                          },
                          onDelete: () {
                            controller.showDeleteDialog(postId: post.id);
                          },
                          onReport: () {
                            Get.toNamed(AppRoutes.reportPost,
                                arguments: {"isGroup": false, "postId": post.id});
                          },
                        );
                      });
                }),
              ),
            ),
          ],
        ),
      ),
        floatingActionButton: SizedBox(
          width: isTab ? 72.0 : 56.0,
          height: isTab ? 72.0 : 56.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(
                AppRoutes.createPost,
                arguments: {"isGroup": false, "groupId": null},
              );
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            backgroundColor: const Color(0xFF6B8E23),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: isTab ? 36 : 22,
            ),
          ),
        ),
    );
  }
}