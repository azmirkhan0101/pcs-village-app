import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_constants.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/core/widgets/photo_edit_widget.dart';
import 'package:pcs_village/data/models/auth/branch_model.dart';
import 'package:pcs_village/modules/auth/controllers/signup_controller.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/extensions.dart';

class SignupOneScreen extends StatefulWidget {
  const SignupOneScreen({super.key});

  @override
  State<SignupOneScreen> createState() => _SignupOneScreenState();
}

class _SignupOneScreenState extends State<SignupOneScreen> {

  final SignupController controller = Get.find<SignupController>();
  String? affiliationError;
  String? branchError;

  List<String> affiliations = [
    Affiliation.activeDutySpouse.displayName,
    Affiliation.activeDuty.displayName,
    Affiliation.veteran.displayName,
    Affiliation.militaryFamily.displayName
  ];
  
  @override
  void initState() {
    
    if( controller.branches.isEmpty ){
      controller.getBranches();
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: Text(
              "Step 1 of 5",
              style: TextStyle(color: Colors.grey[600], fontSize: isTab ? 10.sp : 14),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.2, // 1 of 5
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 32),

            // Header Text
            CustomText(text: AppStrings.createYourProfile).s24.w700,
            const SizedBox(height: 8),
            CustomText(text: AppStrings.tellUsABitAboutYou,
              fontColor: AppColors.subtitleTextColor,).s14,
            const SizedBox(height: 40),

            PhotoEditWidget(
              imageUrl: "",
              onImagePicked: (file){
                controller.profileImage.value = file;
              },
            ),
            // Form Fields
            const SizedBox(height: 20),
            _buildLabel("Military Branch"),
            Obx((){
              return _buildDropdownField(
                  hint: "Select Branch",
                  value: controller.selectedBranch,
                  errorText: branchError,
                  items: controller.branches.value.map((e){
                    return e.name;
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      BranchModel model = controller.branches[controller.branches.indexOf(controller.branches.firstWhere((element) => element.name == value))];
                      controller.selectedBranch = value;
                      controller.selectedBranchId = model.id;
                    });
                  }
              );
            }),

            const SizedBox(height: 20),
            _buildLabel("Military Affiliation"),

            _buildDropdownField(
                hint: "Select Affiliation",
                value: controller.selectedAffiliation,
                items: affiliations,
                errorText: affiliationError,
                onChanged: (String? value) {
                  setState(() {
                    controller.selectedAffiliation = value;
                  });
                }
            ),

            const SizedBox(height: 40),

            // Continue Button
            Center(
              child: CustomButton(
                label: AppStrings.cContinue,
                onPressed: () {
                  branchError = null;
                  affiliationError = null;
                  if (controller.selectedAffiliation != null &&
                      controller.selectedBranch != null) {
                    Get.toNamed(AppRoutes.signupStepTwoScreen);
                  } else {
                    if (controller.selectedBranch == null) {
                      setState(() {
                        branchError = "Please select a branch";
                      });
                    }else{
                      setState(() {
                        affiliationError = "Please select an affiliation";
                      });
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    bool isTab = context.isTab;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: isTab ? 12.sp : null,
          color: AppColors.primaryColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? errorText,
  }) {

    bool isTab = context.isTab;

    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      value: value,
      items: items.map((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val, style: TextStyle(fontSize: isTab ? 10.sp : null),),
        );
      }).toList(),
      onChanged: onChanged,
      style: TextStyle(fontSize: isTab ? 10.sp : null, color: AppColors.black),
      // Styling the dropdown to match your previous design
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: isTab ? 10.sp : null),
        filled: true,
        fillColor: Colors.grey[50],
        errorText: errorText,
        // The error message shows here
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.lightBlueAccent),
        ),
      ),
    );
  }
}