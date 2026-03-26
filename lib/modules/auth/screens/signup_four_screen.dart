import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';

class SignupFourScreen extends StatelessWidget {
  const SignupFourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1D3557);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        title: const Text(
          'Step 4 of 5',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        centerTitle: false,
        actions: const [SizedBox(width: 50)]
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
                value: 0.8, // 4 of 5
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 40),

            // Header Text
            const Text(
              'Select Duty Stations',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose your current and future duty stations',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Form Fields
            _buildStationField('Current Duty Station', 'Select current station'),
            const SizedBox(height: 24),
            _buildStationField('Future Duty Station', 'Select future station'),

            const Spacer(),

            // Continue Button
            CustomButton(
                label: AppStrings.cContinue,
              onPressed: (){
                  Get.toNamed(AppRoutes.signupStepFiveScreen);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStationField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D3557),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          readOnly: true, // Likely opens a search/picker on tap
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.blueGrey),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            suffixIcon: const Icon(Icons.location_on_outlined, color: Colors.blueGrey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}