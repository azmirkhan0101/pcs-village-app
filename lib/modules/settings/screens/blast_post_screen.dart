import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/data/models/blast_post/blast_post_model.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';
import 'package:pcs_village/modules/settings/controllers/blast_post_controller.dart';
import 'package:pcs_village/modules/settings/widgets/blast_post_card.dart';
import 'package:pcs_village/routes/app_pages.dart';

class BlastPostScreen extends StatelessWidget {
  BlastPostScreen({super.key});

  final BlastPostController controller = Get.find<BlastPostController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B365D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white,),
        title: Text("Blast posts", style: TextStyle(color: Colors.white),),
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColors.primaryColor,
        onRefresh: () async {
          await controller.getMyBlastPosts();
        },
        child: Column(
          children: [
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
                  if (controller.blastPostsHelper.isLoading.value && controller.blastPostsHelper.items.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primaryColor),
                    );
                  }

                  // 2. Empty State
                  if (controller.blastPostsHelper.items.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                        const Center(
                          child: Column(
                            children: [
                              Icon(Icons.post_add, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text("No blast posts found",
                                  style: TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  // 3. Data List with Pagination Loader
                  return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.blastPostsHelper.items.length + 1, // Add 1 for the loader
                      controller: controller.postScrollController,
                      itemBuilder: (context, index) {
                        // Check if we reached the end of the list
                        if (index == controller.blastPostsHelper.items.length) {
                          return Obx(() => controller.blastPostsHelper.isMoreLoading.value
                              ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                              : const SizedBox(height: 80));
                        }

                        final BlastPostModel post = controller.blastPostsHelper.items[index];

                        return BlastPostCard(
                            post: post,
                          isMyAd: true,
                          onLinkTap: (){
                              controller.openLinkInBrowser(websiteLink: post.url);
                          },
                          onDelete: (){
                              controller.deleteBlastPost(id: post.id);
                          },
                        );
                      });
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.createBlastPost);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: const Color(0xFF6B8E23),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}