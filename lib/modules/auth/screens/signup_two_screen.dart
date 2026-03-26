import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';

import '../../../routes/app_pages.dart';

class SignupTwoScreen extends StatefulWidget {
  const SignupTwoScreen({super.key});

  @override
  State<SignupTwoScreen> createState() => _SignupTwoScreenState();
}

class _SignupTwoScreenState extends State<SignupTwoScreen> {
  // List of all available interests
  final List<String> _interests = [
    'Fitness', 'Cooking', 'Reading', 'Travel', 'Photography',
    'Sports', 'Arts & Crafts', 'Music', 'Gardening', 'Gaming',
    'Hiking', 'Yoga', 'Running', 'Volunteering', 'Pets'
  ];

  // Set to track selected items
  final Set<String> _selectedInterests = {};

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: Text("Step 2 of 5", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.4, // 2 of 5
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 32),
            CustomText(text: AppStrings.selectYourInterests).s24.w700,
            const SizedBox(height: 8),
            CustomText(text: AppStrings.chooseTopics, fontColor: AppColors.subtitleTextColor,).s14,
            const SizedBox(height: 32),
            // Interests Chips
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _interests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return ChoiceChip(
                      label: Text(interest),
                      selected: isSelected,
                      onSelected: (_) => _toggleInterest(interest),
                      selectedColor: const Color(0xFF203A5B),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF203A5B),
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : Colors.grey[300]!,
                        ),
                      ),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
              ),
            ),
            // Bottom Action Buttons
            Column(
              children: [
                CustomButton(
                    label: AppStrings.cContinue,
                  onPressed: (){
                    Get.toNamed(AppRoutes.signupStepThreeScreen);
                  },
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.signupStepThreeScreen);
                  },
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}