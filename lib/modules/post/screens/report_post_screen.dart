import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/modules/post/controllers/report_post_controller.dart';

import '../../../core/utils/extensions.dart';

class ReportPostScreen extends StatelessWidget {
  ReportPostScreen({super.key});

  final ReportPostController controller = Get.find<ReportPostController>();

  final List<String> reasons = [
    "Spam or misleading content",
    "Harassment or bullying",
    "Hate speech or discrimination",
    "Violence or harmful behavior",
    "Inappropriate or explicit content",
    "False information",
    "Scam or fraud",
    "Intellectual property violation",
    "Privacy violation",
    "Other",
  ];

  final Color selectedBorderColor = const Color(0xFF0A1F44);

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text("Report Post", style: TextStyle(fontWeight: FontWeight.w600, fontSize: isTab ? 12.sp : null),),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reasons.length,
              itemBuilder: (context, index) {
                final reason = reasons[index];

                return Obx(() {
                  final isSelected = controller.selectedReason.value == reason;

                  return GestureDetector(
                    onTap: () {
                      controller.selectedReason.value = reason;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? selectedBorderColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        reason,
                        style: TextStyle(
                          fontSize: isTab ? 12.sp : 15,
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? selectedBorderColor
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              final isEnabled = controller.selectedReason.value.isNotEmpty;

              return CustomButton(label: "Submit Report",
              isEnabled: isEnabled,
                borderColor: Colors.transparent,
                isLoading: controller.isLoading.value,
                onPressed: (){
                controller.reportPost();
                },
              );
            }),
          ),
          SizedBox(height: 40,)
        ],
      ),
    );
  }
}