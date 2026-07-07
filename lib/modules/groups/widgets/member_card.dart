import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/data/models/groups/member_model.dart';
import 'package:pcs_village/modules/main_nav/controllers/main_nav_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/custom_text.dart';

class MemberCard extends StatelessWidget {

  final MemberModel member;
  final Function(String id) onSendWave;
  final Function(String id) onWaveBack;
  final Function(MemberModel member) onMessage;

  const MemberCard({
    super.key,
    required this.member,
    required this.onSendWave,
    required this.onWaveBack,
    required this.onMessage
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

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
                    CachedImageWidget(
                        imageUrl: member.profileImage
                    ).circle.h45.w45,
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
                          Text(member.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTab ? 12.sp : 17,
                                  color: Color(0xFF1A365D))),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6)),
                            child: CustomText(
                              text: AffiliationExtension.fromString(member.affiliation ?? ""),
                            ).s14.color(Colors.white).bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                          "📍 ${member.movement ?? ''}",
                          style: TextStyle(
                              fontSize: isTab ? 10.sp : 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Obx((){
                    return CustomButton(
                      label: member.isMatched
                          ? "Message"
                          : member.isWavePending
                          ? "Wave sent"
                          : member.isIncomingWave
                          ? "Wave back"
                          : "Send wave",
                      buttonHeight: isTab ? 40 : 35,
                      isLoading: member.isWaveLoading.value,
                      isEnabled: member.isWavePending ? false : true,
                      fontSize: 14,
                      buttonRadius: 8,
                      prefixSvgIcon: member.isMatched ? Assets.icons.chat : Assets.icons.raiseHand,
                      iconHeight: 20,
                      gradient: AppColors.waveButtonGradient,
                      onPressed: () {
                        if( member.isMatched ){
                          onMessage(member);
                        }else if( member.isIncomingWave ){
                          onWaveBack(member.userId);
                        }else{
                          onSendWave(member.userId);
                        }
                      },
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                      label: AppStrings.viewProfile,
                    buttonHeight: isTab ? 40 : 35,
                    fontSize: 14,
                    prefixSvgIcon: Assets.icons.profile,
                    iconHeight: 20,
                    buttonRadius: 8,
                    onPressed: () {
                        Get.toNamed(
                            AppRoutes.memberProfile,
                          arguments: member.userId
                        );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
