import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';

import '../../../routes/app_pages.dart';
import '../controllers/plan_controller.dart';

class UpgradePremiumScreen extends StatelessWidget {
  UpgradePremiumScreen({super.key});

  final PlanController controller = Get.find<PlanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE2E9),
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const BackButton(),
        title: const Text(
          'Upgrade to Premium',
          style: TextStyle(color: Color(0xFF2E4159), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // 1. Wrap with Obx to listen to controller changes
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final plan = controller.planModel.value;

        if (plan == null) {
          return const Center(child: Text("No subscription plans available."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header Icon
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFC5A36A), Color(0xFF8B8C4B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.workspace_premium, size: 50, color: Colors.white),
                    ),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF2E4159),
                      child: Icon(Icons.check, size: 16, color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 2. Dynamic Title and Description
              Text(
                plan.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A3557)),
              ),
              const SizedBox(height: 10),
              Text(
                plan.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 30),
              // Pricing Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B567D),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          // 3. Dynamic Price and Currency
                          TextSpan(
                              text: '${plan.currency == "usd" ? "\$" : plan.currency}${plan.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                          TextSpan(
                              text: '/${plan.interval}',
                              style: const TextStyle(fontSize: 20, color: Colors.white70)
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cancel anytime • Billed recurringly',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Premium Features',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3557)),
              ),
              const SizedBox(height: 20),

              // 4. Dynamic Feature List from PlanModel
              ...plan.features.map((feature) => _buildFeatureTile(
                  Icons.check_circle_outline,
                  feature,
                  "Included in ${plan.name} plan"
              )),

              const SizedBox(height: 30),

              // CTA Button
              Obx((){
                return CustomButton(
                    label: 'Start Premium Now',
                  isLoading: controller.isSubscribing.value,
                  buttonRadius: 50,
                  borderColor: Colors.transparent,
                  onPressed: (){
                      controller.subscribe(
                          planId: controller.planModel.value?.id ?? ""
                      );
                  },
                  gradient: const LinearGradient(colors: [Color(0xFFC5A36A), Color(0xFF5D6D31)]),
                );
              }),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Maybe Later', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Secure payment • Cancel anytime',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF7B8E61)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A3557))),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.check, color: Colors.green, size: 20),
        ],
      ),
    );
  }
}