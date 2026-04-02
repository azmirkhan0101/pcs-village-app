import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class UpgradePremiumScreen extends StatelessWidget {
  const UpgradePremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE2E9), // Light grayish-blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF2E4159)),
        title: const Text(
          'Upgrade to Premium',
          style: TextStyle(color: Color(0xFF2E4159), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Crown Icon Header
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
            const Text(
              'Unlock Full Access',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A3557)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Join our premium community and\nget unlimited access to all features',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 30),

            // Price Card
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
                    text: const TextSpan(
                      children: [
                        TextSpan(text: '\$2', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                        TextSpan(text: '/month', style: TextStyle(fontSize: 20, color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cancel anytime • Billed monthly',
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

            // Feature List
            _buildFeatureTile(Icons.chat_bubble_outline, 'Unlimited Direct Messages', 'Connect with service members without limits'),
            _buildFeatureTile(Icons.article_outlined, 'Create Posts', 'Share your story and experiences with the community'),
            _buildFeatureTile(Icons.comment_outlined, 'Comment on Posts', 'Join conversations and offer advice'),
            _buildFeatureTile(Icons.people_outline, 'Full Community Access', 'Participate fully in all base communities'),

            const SizedBox(height: 30),

            // CTA Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.completePurchase);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFC5A36A), Color(0xFF5D6D31)]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text('Start Premium Now', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text('Maybe Later', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Secure payment • Cancel anytime\nJoin 5,000+ premium members',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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