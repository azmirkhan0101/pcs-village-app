import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/modules/groups/controllers/groups_details_controller.dart';

import '../../../routes/app_pages.dart';
import '../widgets/members_tab.dart';
import '../widgets/posts_tab.dart';

class GroupDetailsScreen extends StatelessWidget {
  GroupDetailsScreen({super.key});

  final GroupsDetailsController controller = Get.find<GroupsDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: const Color(0xFF1E3A5F),
              leading: const BackButton(color: Colors.white),
              actions: [circleBtn(Icons.settings)],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomText(
                      text: controller.groupModel.groupName,
                      fontColor: Colors.white,
                      overflow: TextOverflow.visible,
                      textAlignment: TextAlign.left,
                    ).s22.bold
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Obx(() {
                      return actionButtons(
                          isJoined: controller.isJoined.value
                      );
                    }),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (!controller.isJoined.value) return const SizedBox.shrink();

                      return Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: controller.tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: const Color(0xFF1E3A5F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(text: "Posts"),
                            Tab(text: "Members"),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Obx(() {
          if (controller.isJoined.value) {
            return TabBarView(
              controller: controller.tabController,
              children: [
                PostsTab(
                  posts: controller.postsHelper.items,
                  isLoading: controller.postsHelper.isLoading,
                  scrollController: controller.postScrollController,
                  onRefresh: () async{
                    controller.getPosts(refresh: true);
                  },
                ),
                MembersTab(
                  members: controller.membersHelper.items,
                  isLoading: controller.membersHelper.isLoading,
                  isMoreLoading: controller.membersHelper.isMoreLoading,
                  scrollController: controller.membersScrollController,
                  onRefresh: () async{
                    controller.getMembers();
                  },
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Join group to see content',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
      floatingActionButton: Obx(() {
        // Only show FAB if joined
        return controller.isJoined.value
            ? FloatingActionButton(
          onPressed: () {
            Get.toNamed(
                AppRoutes.createPost,
              arguments: {
                  "isGroup" : true,
                "groupId" : controller.groupModel.id
              }
            );
          },
          backgroundColor: const Color(0xFF4F6228),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.add, color: Colors.white),
        )
            : const SizedBox.shrink();
      }),
    );
  }

  Widget circleBtn(IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget actionButtons({required bool isJoined}) {
    return Row(
      children: [
        // if (isJoined)
        //   Expanded(
        //     flex: 2,
        //       child: CustomButton(
        //         buttonHeight: 48,
        //           label: AppStrings.notificationsOn,
        //         backgroundColor: AppColors.primaryColor,
        //         prefixIcon: Icons.notifications_none,
        //         buttonRadius: 10,
        //         onPressed: () {},
        //       )
        //   ),
        // const SizedBox(width: 10),

        // LEAVE BUTTON
        if (isJoined)
          Expanded(
            child: CustomButton(
              buttonHeight: 48,
              label: AppStrings.leave,
              isLoading: controller.isLeaving.value,
              backgroundColor: const Color(0xFFF1F5F9),
              borderColor: Colors.transparent,
              buttonRadius: 10,
              textColor: AppColors.primaryColor,
              onPressed: () => controller.leaveGroup(),
            ),
          ),

        // JOIN BUTTON
        if (!isJoined)
          Expanded(
            child: CustomButton(
              buttonHeight: 48,
              label: "Join Group",
              isLoading: controller.isJoining.value,
              backgroundColor: const Color(0xFF1E3A5F),
              buttonRadius: 10,
              onPressed: () => controller.joinGroup(),
            ),
          )
      ],
    );
  }
}