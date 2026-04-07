import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../data/models/post/post.dart';
import '../controllers/home_controller.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B365D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx((){
              return Text(
                  profileController.profileModel.value?.currentStation.name ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
              );
            }),
            Text('Community Feed', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {},
              icon: SvgPicture.asset(Assets.icons.filter)
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColors.primaryColor,
        onRefresh: () async{
          controller.getPosts();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search posts, people, or topics...",
                  hintStyle: const TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.search, color: Colors.white60),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            // Feed Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // Light grey background for feed
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: ListView.builder(
                  itemCount: controller.posts.length,
                    controller: controller.scrollController,

                    itemBuilder: (context, index){
                      final Post post = controller.posts[index];

                      return PostCard(
                        onTap: (){
                          Get.toNamed(
                              AppRoutes.postDetails,
                            arguments: post
                          );
                        },
                        post: post,
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.createPost);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: const Color(0xFF6B8E23),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}