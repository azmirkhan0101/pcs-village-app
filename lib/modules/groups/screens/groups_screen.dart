import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/data/models/groups/group_model.dart';
import 'package:pcs_village/modules/groups/controllers/groups_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../widgets/group_card.dart';

class GroupsScreen extends StatelessWidget {
  GroupsScreen({super.key});

  final GroupsController controller = Get.find<GroupsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 60, left: 20, right: 20, bottom: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF213A5E),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Groups',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Community Feed',
                  style:
                  TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: controller.onSearch,
                  decoration: InputDecoration(
                    hintText: 'Search groups.....',
                    hintStyle:
                    const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.white54),
                    filled: true,
                    fillColor:
                    Colors.white.withValues(alpha: 0.1),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TabBar(
                  controller: controller.tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: const [
                    Tab(text: "Active"),
                    Tab(text: "Suggested"),
                    Tab(text: "Archived"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                groupsList(
                  groups: controller.activePagination.items,
                  onRefresh: controller.fetchActiveGroups,
                  scrollController: controller.activeScrollController,
                  isLoadingMore: controller.activePagination.isMoreLoading
                ),
                groupsList(
                  groups: controller.suggestedPagination.items,
                  onRefresh: controller.fetchSuggestedGroups,
                  scrollController: controller.suggestedScrollController,
                  isLoadingMore: controller.suggestedPagination.isMoreLoading
                ),
                groupsList(
                  groups: controller.archivedPagination.items,
                  onRefresh: controller.fetchArchivedGroups,
                  scrollController: controller.archivedScrollController,
                  isLoadingMore: controller.archivedPagination.isMoreLoading
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget groupsList({
    required RxList groups,
    required Future<void> Function() onRefresh,
    required ScrollController scrollController,
    required RxBool isLoadingMore,
  }) {
    return Obx(() {
      if (controller.isLoading.value && groups.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (!controller.isLoading.value && groups.isEmpty) {
        return RefreshIndicator(
          backgroundColor: Colors.white,
          color: AppColors.primaryColor,
          onRefresh: onRefresh,
          child: ListView(
            children: [
              SizedBox(height: Get.height * 0.2),
              const Center(
                child: Text(
                  "No groups found",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColors.primaryColor,
        onRefresh: onRefresh,
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: groups.length + (isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < groups.length) {
              final GroupModel group = groups[index];
              return GroupCard(
                title: group.groupName,
                members: "${group.totalMember} members",
                onTap: () {
                  Get.toNamed(
                      AppRoutes.groupDetails,
                      arguments: group
                  );
                },
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      );
    });
  }
}