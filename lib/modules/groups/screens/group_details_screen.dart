import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/data/models/groups/member_model.dart';
import 'package:pcs_village/data/models/message/participant_model.dart';
import 'package:pcs_village/modules/groups/controllers/groups_details_controller.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';

import '../../../core/utils/extensions.dart';
import '../../../routes/app_pages.dart';
import '../widgets/members_tab.dart';
import '../widgets/posts_tab.dart';

class GroupDetailsScreen extends StatelessWidget {
  GroupDetailsScreen({super.key});

  final GroupsDetailsController controller = Get.find<GroupsDetailsController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

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
                        height: isTab ? 55 : 45,
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
                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: isTab ? 12.sp : null),
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
                  banners: controller.bannerHelper.items,
                  onAdTap: (adUrl){
                    controller.openLinkInBrowser(websiteLink: adUrl);
                  },
                  isLoading: controller.postsHelper.isLoading,
                  scrollController: controller.postScrollController,
                  onRefresh: () async{
                    controller.getPosts();
                  },
                  onFavouriteTap: (String postID) {
                    controller.likeUnlikePost( postId: postID );
                  },
                  userId: profileController.profileModel.value?.id ?? "",
                  onDelete: (String postID) {
                    controller.showDeleteDialog(postId: postID);
                  },
                ),
                MembersTab(
                  members: controller.displayMembers,
                  isLoading: controller.membersHelper.isLoading,
                  isMoreLoading: controller.membersHelper.isMoreLoading,
                  scrollController: controller.membersScrollController,
                  searchController: controller.searchController,
                  onRefresh: () async{
                    controller.getMembers();
                  }, onSendWave: (String id) {
                    controller.sendWave(userId: id);
                },
                  onWaveBack: (String id) {
                    controller.waveBack(userId: id);
                  },
                  onMessage: (MemberModel member){
                    Get.toNamed(
                        AppRoutes.messageScreen,
                      arguments: ParticipantModel.fromMemberModel(member)
                    );
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
                   Text(
                    'Join group to see content',
                    style: TextStyle(
                      fontSize: isTab ? 12.sp : 18,
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
        // Only show FAB if joined and in posts tab
        return controller.isJoined.value
            && controller.currentTabIndex.value == 0
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
              onPressed: () => showLeaveGroupDialog(),
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

//LEAVE GROUP DIALOG
  void showLeaveGroupDialog() async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.white,
          title: Column(
            children: [
              Text(
                "Leave group",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to leave this group?",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CupertinoColors.inactiveGray, width: 2.r)
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Delete button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async{
                        Get.back();
                        controller.leaveGroup();
                      },
                      child: const Text(
                        "Leave",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}