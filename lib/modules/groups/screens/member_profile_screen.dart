import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

class MemberProfileScreen extends StatelessWidget {
  MemberProfileScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {

    // Primary Colors from the UI
    const Color primaryNavy = Color(0xFF1D3557);
    const Color accentBlue = Color(0xFF457B9D);
    const Color backgroundGray = Color(0xFFF1F4F8);

    return Scaffold(
      backgroundColor: primaryNavy,
      appBar: AppBar(
        backgroundColor: primaryNavy,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                            child: Obx((){
                              return CachedImageWidget(imageUrl: controller.profileModel.value?.profileImage ?? "",
                                iconSize: 48,
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx((){
                          return Text( controller.profileModel.value?.name ?? "", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryNavy));
                        }),
                        const SizedBox(height: 4),
                        Obx((){
                          String affiliation = Affiliation.values.firstWhereOrNull((element) => element.value == controller.profileModel.value?.affiliation)?.displayName ?? Affiliation.activeDuty.displayName;
                          return Text( affiliation, style: TextStyle(fontSize: 14, color: primaryNavy));
                        }),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // --- Military Information Card ---
                  sectionCard(
                    title: 'Military Information',
                    child: Column(
                      children: [
                        Obx((){
                          return _buildInfoRow(
                              Icons.location_on_outlined,
                              'Current Station',
                              controller.profileModel.value?.currentStation?.name ?? "Not found"
                          );
                        }),
                        Obx((){
                          return _buildInfoRow(
                              Icons.location_on_outlined,
                              'Future Station',
                              controller.profileModel.value?.futureStation?.name ?? "Not found"
                          );
                        }),
                        Obx(() {
                          final pcsDate = controller.profileModel.value?.estimatedPcsDate;

                          return _buildInfoRow(
                            Icons.date_range_outlined,
                            'PCS Timeline',
                            pcsDate != null
                                ? DateFormat("dd-MM-yyyy").format(pcsDate)
                                : "No date found",
                          );
                        }),
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
                        Obx((){
                          return Text(
                              controller.profileModel.value?.branch?.name ?? "Not found",
                              style: TextStyle(fontWeight: FontWeight.bold, color: primaryNavy));
                        }),
                        const SizedBox(height: 16),
                        const _SectionLabel(label: 'Kids Age Range'),
                        Obx(() {
                          final kidsAgeRanges = controller.profileModel.value?.kidsAgeRanges ?? [];

                          return Wrap(
                            spacing: 8,
                            children: kidsAgeRanges.isEmpty
                                ? [const Text("No age ranges specified")]
                                : kidsAgeRanges.map((range) {
                              String rangeName = KidsAgeRange.values
                                  .firstWhereOrNull((element) => element.value == range)
                                  ?.displayName ?? "Unidentified";
                              return _buildChip(rangeName);
                            }).toList(),
                          );
                        }),
                        const SizedBox(height: 16),
                        const _SectionLabel(label: 'Interests'),
                        Obx(() {
                          final interests = controller.profileModel.value?.interestTags ?? [];

                          return Wrap(
                            spacing: 8,
                            children: interests.isEmpty
                                ? [const Text("No age ranges specified")]
                                : interests.map((range) {
                              return _buildChip(range);
                            }).toList(),
                          );
                        }),
                        const SizedBox(height: 16),
                        const _SectionLabel(label: 'Member Since'),
                        const Text('January 2026', style: TextStyle(fontWeight: FontWeight.bold, color: primaryNavy)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //=========================SECTION CARD=========================
  Widget sectionCard({required Widget child, String? title, EdgeInsets? padding, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (title != null) ...[
            Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
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
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF457B9D))),
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
      child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}