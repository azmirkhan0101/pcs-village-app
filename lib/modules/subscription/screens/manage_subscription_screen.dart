import 'package:flutter/material.dart';

class ManageSubscriptionScreen extends StatelessWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF344767)),
        title: const Text(
          'Manage Subscription',
          style: TextStyle(color: Color(0xFF344767), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- Premium Membership Card ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF425A7D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.workspace_premium, color: Colors.orangeAccent),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Premium Membership',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Icons.circle, size: 8, color: Colors.greenAccent),
                              SizedBox(width: 4),
                              Text('Active', style: TextStyle(color: Colors.white70, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 40, color: Colors.white24),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '\$2', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        TextSpan(text: '/month', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Subscription Details Card ---
            _buildWhiteCard([
              _buildDetailRow(Icons.calendar_month_outlined, 'Next billing date', 'April 12, 2026'),
              const Divider(height: 30),
              _buildDetailRow(Icons.credit_card, 'Payment method', '•••• •••• •••• 4242', trailing: 'Update'),
              const Divider(height: 30),
              _buildDetailRow(Icons.check_circle_outline, 'Member since', 'March 12, 2026'),
            ]),
            const SizedBox(height: 20),

            // --- Benefits Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F0), // Light beige background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Premium Benefits',
                      style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildBenefitItem('Unlimited direct messages'),
                  _buildBenefitItem('Create posts in community feed'),
                  _buildBenefitItem('Comment on all posts'),
                  _buildBenefitItem('Full access to base communities'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Billing History Card ---
            _buildWhiteCard([
              const Text('Billing History',
                  style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('March 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Paid on Mar 12, 2026', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$2.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Receipt', style: TextStyle(color: Color(0xFF1E3A5F), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildWhiteCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {String? trailing}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.green[700], size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F), fontSize: 15)),
            ],
          ),
        ),
        if (trailing != null)
          Text(trailing, style: const TextStyle(color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Color(0xFF425A7D), fontSize: 14)),
        ],
      ),
    );
  }
}