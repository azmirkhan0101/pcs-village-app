import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/data/models/groups/member_model.dart';
import 'package:shimmer/shimmer.dart';

class MembersTab extends StatelessWidget {
  final RxList<MemberModel> members;
  final RxBool isLoading;
  final RxBool isMoreLoading;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  const MembersTab({
    super.key,
    required this.members,
    required this.isLoading,
    required this.onRefresh,
    required this.isMoreLoading,
    required this.scrollController
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Obx(() {
        if (isLoading.value && members.isEmpty) {
          return _buildSkeletonList();
        }

        if (members.isEmpty) {
          return _buildEmptyState();
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
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                ],
              );
            }

            if (index == members.length + 1) {
              return Obx(() => isMoreLoading.value
                  ? _buildBottomLoader()
                  : const SizedBox(height: 20));
            }

            final member = members[index - 1];
            return _buildMemberCard(member);
          },
        );
      }),
    );
  }

  Widget _buildBottomLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xFF1E3A5F),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: Get.height * 0.3),
        const Center(
          child: Text(
            "No members found in this group.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
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

  //SKELETON LOADING
  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(dynamic member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(member.profileImage ?? "")),
                    const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.check_circle,
                            color: Colors.blue, size: 16)),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(member.name ?? "Member",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Color(0xFF1A365D))),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text("Military Spouse",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const Text("Army Spouse",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("📅 ${member.moveTimeline ?? 'N/A'}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      Text("📍 ${member.locationFlow ?? ''}",
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildWaveBtn("Send Wave", const Color(0xFFA68B5B), Icons.front_hand),
                const SizedBox(width: 8),
                _buildSmallBtn("View Profile", const Color(0xFF1E3A5F), Icons.person_outline),
                const SizedBox(width: 8),
                _buildSmallBtn("Message", const Color(0xFF5D6D3E), Icons.chat_bubble_outline),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmallBtn(String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveBtn(String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFFA68B5B), Color(0xFF5D6D3E)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

}