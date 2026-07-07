import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/extensions.dart';
import 'package:pcs_village/data/models/message/conversation_model.dart';
import 'package:pcs_village/data/models/message/participant_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pcs_village/modules/message/controllers/conversation_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

class ContactListScreen extends StatelessWidget {
  ContactListScreen({super.key});

  final ConversationController controller = Get.find<ConversationController>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section (Static)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            color: const Color(0xFF1E3A5F),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white, fontSize: isTab ? 10.sp : null),
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search your connection...',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: isTab ? 10.sp : null),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Reactive List Section
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              color: AppColors.primaryColor,
              onRefresh: () async {
                controller.getConversations();
              },
              child: Obx(() {
                if (controller.conversationHelper.isLoading.value) {
                  return _buildLoadingSkeleton();
                }

                if (controller.conversationHelper.items.isEmpty) {
                  return _buildEmptyState(isTab: isTab);
                }

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.conversationHelper.items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, indent: 20, endIndent: 20),
                  itemBuilder: (context, index) {
                    final Conversation conversation = controller.conversationHelper.items[index];
                    return ListTile(
                      onTap: (){
                        Get.toNamed(
                            AppRoutes.messageScreen,
                            arguments: ParticipantModel.fromConversationModel(conversation)
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(
                              conversation.opponentProfileImg,
                            ),
                          ),
                          // if (item.isOnline ?? false)
                          //   Positioned(
                          //     right: 0,
                          //     bottom: 0,
                          //     child: Container(
                          //       height: 14,
                          //       width: 14,
                          //       decoration: BoxDecoration(
                          //         color: Colors.green,
                          //         shape: BoxShape.circle,
                          //         border: Border.all(
                          //           color: Colors.white,
                          //           width: 2,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Text(
                            conversation.opponentName ?? "Unknown",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                          // if (item.isVerified ?? false) ...[
                          //
                          // ],
                        ],
                      ),
                      subtitle: Text(
                        conversation.lastMessage?.message ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatTime(conversation.lastMessage?.createdAt?.toLocal() ?? null),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // if ((item.unreadCount ?? 0) > 0)
                          //   CircleAvatar(
                          //     radius: 10,
                          //     backgroundColor: const Color(0xFF1E3A5F),
                          //     child: Text(
                          //       '${item.unreadCount}',
                          //       style: const TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 10,
                          //       ),
                          //     ),
                          //   )
                          // else
                            const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dt) {

    if( dt == null ) return "";

    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  // --- UI Sub-Widgets ---

  Widget _buildEmptyState({required bool isTab}) {
    return ListView(
      // ListView allows Pull-to-refresh to work even when empty
      children: [
        SizedBox(height: Get.height * 0.2),
        Center(
          child: Column(
            children: [
              const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                "No conversations found",
                style: TextStyle(color: Colors.grey, fontSize: isTab ? 12.sp :16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) => ListTile(
          leading: const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
          ),
          title: Container(height: 15, width: 100, color: Colors.white),
          subtitle: Container(height: 10, width: 200, color: Colors.white),
        ),
      ),
    );
  }
}
