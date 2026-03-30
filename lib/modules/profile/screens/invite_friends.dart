import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color navyBlue = Color(0xFF1D3557);
    const Color greyText = Color(0xFF666666);
    const Color lightGreyBg = Color(0xFFF5F7F8);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: navyBlue,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Invite Friends', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Help grow the PCS Villages community', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Header Card
            _buildCard(
              color: lightGreyBg,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange.shade200,
                    child: const Icon(Icons.share, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 16),
                  const Text('Share PCS Village', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navyBlue)),
                  const SizedBox(height: 8),
                  const Text('Invite military families to join our supportive community',
                      textAlign: TextAlign.center, style: TextStyle(color: greyText)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Email Invite
            _buildActionCard(
              icon: Icons.email_outlined,
              title: 'Invite via Email',
              hint: 'friend@email.com',
              buttonLabel: 'Send Email Invitation',
            ),
            const SizedBox(height: 16),

            // Phone Invite
            _buildActionCard(
              icon: Icons.phone_outlined,
              title: 'Invite via Phone',
              hint: '(555) 123-4567',
              buttonLabel: 'Send SMS Invitation',
            ),
            const SizedBox(height: 16),

            // Referral Link Card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Referral Link', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navyBlue)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(color: lightGreyBg, borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Expanded(child: Text('https://pcsvillage.app/invite/ABC123', style: TextStyle(color: navyBlue))),
                        Icon(Icons.copy_all, color: greyText),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildOutlineButton('Copy Link', Icons.copy)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildElevatedButton('Share', Icons.share, navyBlue)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'When your friends join using your referral link, they\'ll become part of our growing military family community.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: greyText),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods to keep code DRY
  Widget _buildCard({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: color == null ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: child,
    );
  }

  Widget _buildActionCard({required IconData icon, required String title, required String hint, required String buttonLabel}) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: const Color(0xFF1D3557)), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), fillColor: const Color(0xFFF5F7F8), filled: true)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF94A3B8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text(buttonLabel, style: const TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }

  Widget _buildOutlineButton(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), side: const BorderSide(color: Colors.grey)),
    );
  }

  Widget _buildElevatedButton(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }
}