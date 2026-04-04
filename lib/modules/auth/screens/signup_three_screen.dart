import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../controllers/signup_controller.dart';

class SingupThreeScreen extends StatefulWidget {
  const SingupThreeScreen({super.key});

  @override
  State<SingupThreeScreen> createState() => _SingupThreeScreenState();
}

class _SingupThreeScreenState extends State<SingupThreeScreen> {

  final SignupController controller = Get.find<SignupController>();

  final List<String> _options = [
    KidsAgeRange.infant.displayName,
    KidsAgeRange.toddler.displayName,
    KidsAgeRange.preSchool.displayName,
    KidsAgeRange.schoolAge.displayName,
    KidsAgeRange.teenager.displayName
  ];

  // Set to track selected options
  final Set<String> _selectedOptions = {};

  void _toggleOption(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        String optionValue = KidsAgeRange.values.firstWhere((element) => element.displayName == option).value;
        controller.kidsAgeRange.remove(optionValue);
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
        String optionValue = KidsAgeRange.values.firstWhere((element) => element.displayName == option).value;
        controller.kidsAgeRange.add(optionValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E3A5F); // Dark blue from the image

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0, top: 20),
            child: Text("Step 3 of 5", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
      body: Column(
        children: [
          // Custom Progress Bar
          const SizedBox(height: 10),
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.6, // 3 of 5
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Header Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kids Age Range',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select the age ranges of your\nchildren (optional)',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Scrollable Options List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final option = _options[index];
                final isSelected = _selectedOptions.contains(option);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () => _toggleOption(option),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? primaryColor : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CustomButton(
                  label: AppStrings.cContinue,
                onPressed: (){
                  Get.toNamed(AppRoutes.signupStepFourScreen);
                },
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.signupStepFourScreen);
                  },
                  child: const Text('Skip for now', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}