import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/routes/app_pages.dart';

class CompletePurchaseScreen extends StatelessWidget {
  const CompletePurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: Color(0xFF1E3A5F)),
        title: const Text('Complete Purchase',
            style: TextStyle(color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue Premium Card
            _buildPremiumCard(),
            const SizedBox(height: 30),

            // Payment Header
            const Row(
              children: [
                Icon(Icons.credit_card, color: Color(0xFF1E3A5F), size: 20),
                SizedBox(width: 8),
                Text("Payment Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
              ],
            ),
            const SizedBox(height: 20),

            // Form Fields
            _buildTextField("Cardholder Name", "John Doe"),
            const SizedBox(height: 15),
            _buildTextField("Card Number", "1234  5678  9012  3456"),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(child: _buildTextField("Expiry Date", "MM/YY")),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField("CVV", "123")),
              ],
            ),
            const SizedBox(height: 25),

            // Encryption Notice
            _buildSecurityNotice(),
            const SizedBox(height: 25),

            // Benefits Box
            _buildBenefitsBox(),
            const SizedBox(height: 30),

            // Subscribe Button
            _buildSubscribeButton(),

            // Footer Text
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "By subscribing, you agree to our Terms of Service and Privacy Policy. You'll be charged \$2/month until you cancel.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3B557A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.workspace_premium, color: Colors.orangeAccent),
              ),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Premium Membership",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Monthly subscription",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              )
            ],
          ),
          const Divider(color: Colors.white24, height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total due today", style: TextStyle(color: Colors.white, fontSize: 16)),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: "\$2", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    TextSpan(text: "/mo", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, size: 20, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text("Your payment information is encrypted and secure",
                style: TextStyle(fontSize: 13, color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What you'll get:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _benefitRow("Unlimited direct messages"),
          _benefitRow("Create posts and comments"),
          _benefitRow("Full community access"),
          _benefitRow("Cancel anytime"),
        ],
      ),
    );
  }

  Widget _benefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFD2AC7C), Color(0xFF5B7034)],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          Get.toNamed(AppRoutes.manageSubscription);
        },
        child: const Text("Subscribe Now",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}