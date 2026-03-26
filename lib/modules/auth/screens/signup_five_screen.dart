import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';

class SignupFiveScreen extends StatelessWidget {
  const SignupFiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0, top: 20),
            child: Text("Step 5 of 5", style: TextStyle(color: Colors.grey)),
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
                value: 1, // 5 of 5
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'PCS Timeline',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When are you planning to PCS to your new duty station?',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            // Options List
            Expanded(
              child: ListView(
                children: [
                  PcsTimeLineCard(
                    label: "Just received orders",
                    icon: Icons.calendar_today_outlined,
                    onTap: () {},
                  ),
                  PcsTimeLineCard(
                    label: "Moving within 3 months",
                    icon: Icons.calendar_today_outlined,
                    onTap: () {},
                  ),
                  PcsTimeLineCard(
                    label: "Moving within 6 months",
                    icon: Icons.calendar_today_outlined,
                    onTap: () {},
                  ),
                  PcsTimeLineCard(
                    label: "Moving within 12 months",
                    icon: Icons.calendar_today_outlined,
                    onTap: () {},
                  ),
                  PcsTimeLineCard(
                    label: "Already arrived",
                    icon: Icons.calendar_today_outlined,
                    onTap: () {},
                  ),
                  PcsTimeLineCard(
                    label: "Currently stationed here",
                    icon: Icons.calendar_today_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // Bottom Action Button
            CustomButton(
                label: AppStrings.completeSetup,
              onPressed: (){
                  Get.toNamed(AppRoutes.mainNav);
              },
            ),
            const SizedBox( height: 40,)
          ],
        ),
      ),
    );
  }
}

class PcsTimeLineCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const PcsTimeLineCard({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          foregroundColor: const Color(0xFF2E4566), // Dark blue text/icon
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}