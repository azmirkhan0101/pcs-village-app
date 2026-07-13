import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/modules/profile/controllers/profile_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../subscription/screens/paywall_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    // Primary Colors from the UI
    const Color primaryNavy = Color(0xFF1D3557);
    const Color backgroundGray = Color(0xFFF1F4F8);

    return Scaffold(
      backgroundColor: primaryNavy,
      appBar: AppBar(
        backgroundColor: primaryNavy,
        elevation: 0,
        title: Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isTab ? 12.sp : null)),
        actions: [
          IconButton(
              onPressed: () {
            Get.toNamed(AppRoutes.settingsScreen);
          },
              icon: Icon(Icons.settings, color: Colors.white, size: isTab ? 35 : null,)
          ),
          const SizedBox(width: 20,)
        ],
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
                  _buildCard(
                    isTab: isTab,
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
                          return Text( affiliation, style: TextStyle(fontSize: isTab ? 10.sp : 14, color: primaryNavy));
                        }),
                        const SizedBox(height: 10),
                        // const Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     _StatItem(label: 'Posts', value: '12'),
                        //     _StatItem(label: 'Groups', value: '3'),
                        //     _StatItem(label: 'Connections', value: '48'),
                        //   ],
                        // ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryNavy,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              Get.toNamed(AppRoutes.editProfile);
                            },
                            icon: Icon(Icons.edit_note, color: Colors.white, size: isTab ? 30 : null,),
                            label: Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: isTab ? 10.sp : null)),
                          ),
                        )
                      ],
                    ),
                  ),

                  // --- Military Information Card ---
                  _buildCard(
                    isTab: isTab,
                    title: 'Military Information',
                    child: Column(
                      children: [
                        Obx((){
                          return _buildInfoRow(
                            isTab: isTab,
                              Icons.location_on_outlined,
                              'Current Station',
                              controller.profileModel.value?.currentStation?.name ?? "Not found"
                          );
                        }),
                        Obx((){
                          return _buildInfoRow(
                            isTab: isTab,
                              Icons.location_on_outlined,
                              'Future Station',
                              controller.profileModel.value?.futureStation?.name ?? "Not found"
                          );
                        }),
                        Obx(() {
                          final pcsDate = controller.profileModel.value?.estimatedPcsDate;

                          return _buildInfoRow(
                            isTab: isTab,
                            Icons.date_range_outlined,
                            'PCS Timeline',
                            pcsDate != null
                                ? DateFormat("dd-MM-yyyy").format(pcsDate.toLocal())
                                : "No date found",
                          );
                        }),
                        ],
                    ),
                  ),

                  // --- About Card ---
                  _buildCard(
                    isTab: isTab,
                    title: 'About',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(label: 'Branch'),
                        Obx((){
                          return Text(
                              controller.profileModel.value?.branch?.name ?? "Not found",
                              style: TextStyle( fontSize: isTab ? 10.sp : null, fontWeight: FontWeight.bold, color: primaryNavy));
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
                              return _buildChip(rangeName, isTab: isTab);
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
                              return _buildChip(range, isTab: isTab);
                            }).toList(),
                          );
                        }),
                        const SizedBox(height: 16),
                        const _SectionLabel(label: 'Member Since'),
                       Obx((){
                         final joinDate = controller.profileModel.value?.createdAt;
                         return  Text(
                           joinDate == null
                             ? "No date found"
                             : DateFormat("dd-MM-yyyy").format(joinDate.toLocal()),
                             style: TextStyle( fontSize: isTab ? 10.sp : null, fontWeight: FontWeight.bold, color: primaryNavy)
                         );
                       }),
                      ],
                    ),
                  ),

                  // --- Footer Menu ---
                  _buildCard(
                    isTab: isTab,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildListTile(
                          isTab: isTab,
                          onTap: (){
                            //Get.toNamed(AppRoutes.upgradePremium);
                            Get.to(const PaywallScreen());
                          },
                            Icons.workspace_premium_outlined, 'Upgrade to Premium', Colors.orange
                        ),
                        const Divider(height: 1),
                        _buildListTile(
                          isTab: isTab,
                          onTap: (){
                            Get.toNamed(AppRoutes.communityGuidelines);
                          },
                            Icons.description_outlined, 'Community Guidelines', primaryNavy
                        ),
                        const Divider(height: 1),
                        // _buildListTile(
                        //   onTap: (){
                        //     Get.toNamed(AppRoutes.inviteFriends);
                        //   },
                        //     Icons.person_add_alt, 'Invite Friends', primaryNavy
                        // ),
                        const Divider(height: 1),
                        _buildListTile(
                          isTab: isTab,
                          onTap: (){
                            showLogOutDialog();
                          },
                            Icons.logout, 'Sign Out', Colors.red, isLast: true
                        ),
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

  //SHOW LOGOUT DIALOG
  Future<void> showLogOutDialog() async{
    Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.greyB2,
          content: Column(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.destructiveRed,
                    shape: BoxShape.circle,
                    //borderRadius: BorderRadius.circular(100)
                  ),
                  child: Icon(Icons.exit_to_app, color: AppColors.white, fontWeight: FontWeight.bold, size: 28,),
                ),
              ),
              CustomText(
                text: "Sign out",
                fontColor: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                text: "Do you want to sign out?",
                fontColor: AppColors.grey4E,
                fontSize: 14,
              )
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            Row(
              spacing: 4,
              children: [
                Expanded(
                  child: CustomButton(
                    buttonHeight: 40,
                    label: "Cancel",
                    fontSize: 14,
                    backgroundColor: AppColors.primaryColor,
                    onPressed: (){
                      Get.back();
                    },
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    buttonHeight: 40,
                    label: "Sign out",
                    fontSize: 14,
                    onPressed: (){
                      controller.logOut();
                    },
                  ),
                ),
              ],
            )
          ],
        )
    );
  }

  // Helper to build a styled card
  Widget _buildCard({required Widget child, String? title, EdgeInsets? padding, required bool isTab}) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: TextStyle(fontSize: isTab ? 12.sp : 18, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {required bool isTab}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size:isTab ? 30 : 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: isTab ? 10.sp : 12, color: Colors.grey)),
              Text(value, style: TextStyle( fontSize: isTab ? 12.sp : null, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {required bool isTab}) {
    return Chip(
      label: Text(label, style: TextStyle(fontSize: isTab ? 10.sp : 12, color: Color(0xFF457B9D))),
      backgroundColor: const Color(0xFFF1F4F8),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildListTile(IconData icon, String title, Color color, {bool isLast = false, required VoidCallback onTap, required bool isTab}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle( fontSize: isTab ? 12.sp : null, color: isLast ? Colors.red : const Color(0xFF1D3557), fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, size: isTab ? 30 : 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}

// Small helper widgets to keep things tidy
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    bool isTab = context.isTab;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(label, style:  TextStyle(fontSize: isTab ? 10.sp : 12, color: Colors.grey)),
    );
  }
}