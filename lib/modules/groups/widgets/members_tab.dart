import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/widgets/pagination_loader.dart';
import 'package:pcs_village/data/models/groups/member_model.dart';
import 'package:pcs_village/modules/groups/widgets/member_card.dart';
import 'package:pcs_village/modules/groups/widgets/members_skeleton_list.dart';
import 'package:pcs_village/modules/groups/widgets/no_members_state.dart';

class MembersTab extends StatelessWidget {
  final RxList<MemberModel> members;
  final RxBool isLoading;
  final RxBool isMoreLoading;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final Function(String id) onSendWave;
  final Function(String id) onWaveBack;

  const MembersTab({
    super.key,
    required this.members,
    required this.isLoading,
    required this.onRefresh,
    required this.isMoreLoading,
    required this.scrollController,
    required this.onSendWave,
    required this.onWaveBack
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Obx(() {
        if (isLoading.value && members.isEmpty) {
          return MembersSkeletonList();
        }

        if (members.isEmpty) {
          return NoMembersState();
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: members.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Group Members",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A365D))),
                  const SizedBox(height: 12),
                  searchBar(),
                  const SizedBox(height: 16),
                ],
              );
            }

            if (index == members.length + 1) {
              return Obx(() => isMoreLoading.value
                  ? PaginationLoader()
                  : const SizedBox(height: 20));
            }

            final String memberId = members[index - 1].id;
            return Obx(() {
              final liveMember = members.firstWhere((m) => m.id == memberId);
              return MemberCard(
                member: liveMember,
                onSendWave: (String id) {
                  onSendWave(liveMember.userId);
                },
                onWaveBack: (String id) {
                  onWaveBack(liveMember.userId);
                }
              );
            });
          },
        );
      }),
    );
  }

  Widget searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search members...",
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

}