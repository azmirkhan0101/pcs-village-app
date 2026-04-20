import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/modules/groups/controllers/member_profile_controller.dart';

class MemberProfileScreen extends StatelessWidget {
  MemberProfileScreen({super.key});

  final MemberProfileController controller =
      Get.find<MemberProfileController>();

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF1D3557);
    const Color backgroundGray = Color(0xFFF1F4F8);

    return Scaffold(
      backgroundColor: primaryNavy,
      appBar: AppBar(
        backgroundColor: primaryNavy,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      // Use Obx here to switch between Skeleton and Content
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildSkeleton(backgroundGray);
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: backgroundGray,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // --- Header Card ---
                    sectionCard(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 85,
                              width: 85,
                              color: Colors.grey.shade200,
                              child: CachedImageWidget(
                                imageUrl:
                                    controller
                                        .profileModel
                                        .value
                                        ?.profileImage ??
                                    "",
                                iconSize: 48,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.profileModel.value?.name ?? "",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Affiliation.values
                                    .firstWhereOrNull(
                                      (e) =>
                                          e.value ==
                                          controller
                                              .profileModel
                                              .value
                                              ?.affiliation,
                                    )
                                    ?.displayName ??
                                Affiliation.activeDuty.displayName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // --- Military Information Card ---
                    sectionCard(
                      title: 'Military Information',
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            'Current Station',
                            controller
                                    .profileModel
                                    .value
                                    ?.currentStation
                                    ?.name ??
                                "Not found",
                          ),
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            'Future Station',
                            controller
                                    .profileModel
                                    .value
                                    ?.futureStation
                                    ?.name ??
                                "Not found",
                          ),
                          _buildInfoRow(
                            Icons.date_range_outlined,
                            'PCS Timeline',
                            controller.profileModel.value?.estimatedPcsDate !=
                                    null
                                ? DateFormat("dd-MM-yyyy").format(
                                    controller
                                        .profileModel
                                        .value!
                                        .estimatedPcsDate!,
                                  )
                                : "No date found",
                          ),
                        ],
                      ),
                    ),

                    // --- About Card ---
                    sectionCard(
                      title: 'About',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionLabel(label: 'Branch'),
                          Text(
                            controller.profileModel.value?.branch?.name ??
                                "Not found",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const _SectionLabel(label: 'Kids Age Range'),
                          Wrap(
                            spacing: 8,
                            children:
                                (controller.profileModel.value?.kidsAgeRanges ??
                                        [])
                                    .isEmpty
                                ? [const Text("No age ranges specified")]
                                : controller.profileModel.value!.kidsAgeRanges!
                                      .map((range) {
                                        String rangeName =
                                            KidsAgeRange.values
                                                .firstWhereOrNull(
                                                  (e) => e.value == range,
                                                )
                                                ?.displayName ??
                                            "Unidentified";
                                        return _buildChip(rangeName);
                                      })
                                      .toList(),
                          ),
                          const SizedBox(height: 16),
                          const _SectionLabel(label: 'Interests'),
                          Wrap(
                            spacing: 8,
                            children:
                                (controller.profileModel.value?.interestTags ??
                                        [])
                                    .isEmpty
                                ? [const Text("No interests specified")]
                                : controller.profileModel.value!.interestTags!
                                      .map((tag) => _buildChip(tag))
                                      .toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // --- Skeleton Loader UI ---
  Widget _buildSkeleton(Color bgColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          sectionCard(
            crossAxisAlignment: CrossAxisAlignment.center,
            child: Column(
              children: [
                CircleAvatar(radius: 42, backgroundColor: Colors.grey.shade300),
                const SizedBox(height: 12),
                Container(height: 20, width: 150, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(height: 14, width: 100, color: Colors.grey.shade300),
              ],
            ),
          ),
          sectionCard(
            title: '...', // Placeholder title
            child: Column(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 30,
                        width: 180,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //=========================SECTION CARD=========================
  Widget sectionCard({
    required Widget child,
    String? title,
    EdgeInsets? padding,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (title != null) ...[
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
              ),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Color(0xFF457B9D)),
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
