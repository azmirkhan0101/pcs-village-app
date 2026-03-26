import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';
import 'package:pcs_village/core/widgets/custom_text_field.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';

class SignupOneScreen extends StatefulWidget {
  const SignupOneScreen({super.key});

  @override
  State<SignupOneScreen> createState() => _SignupOneScreenState();
}

class _SignupOneScreenState extends State<SignupOneScreen> {
  String? selectedBranch;

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 32),

            // Header Text
            CustomText(text: AppStrings.createYourProfile).s24.w700,
            const SizedBox(height: 8),
            CustomText(text: AppStrings.tellUsABitAboutYou, fontColor: AppColors.subtitleTextColor,).s14,
            const SizedBox(height: 40),

            // Profile Picture Picker
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[100],
                    child: SvgPicture.asset(Assets.icons.camera, colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn), height: 30,),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryColor,
                      child:SvgPicture.asset(Assets.icons.camera, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn), height: 20,),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form Fields
            const SizedBox(height: 20),
            _buildLabel("Military Branch"),
            _buildDropdownField("Select Branch"),

            const SizedBox(height: 20),
            _buildLabel("Military Affiliation"),
            CustomTextField(),

            const SizedBox(height: 40),

            // Continue Button
            CustomButton(
                label: AppStrings.cContinue,
              onPressed: (){
                  Get.toNamed(AppRoutes.signupStepTwoScreen);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          focusColor: Colors.lightBlueAccent,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
          value: selectedBranch,
          items: ["Army", "Navy", "Air Force", "Marines", "Coast Guard", "Space Force"]
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (val) => setState(() => selectedBranch = val),
        ),
      ),
    );
  }
}