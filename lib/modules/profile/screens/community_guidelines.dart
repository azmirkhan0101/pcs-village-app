import 'package:flutter/material.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom theme colors based on the image
    const navyBlue = Color(0xFF1A3358);
    const lightBackground = Color(0xFFF8F9FA);
    const warningBackground = Color(0xFFFEF5ED);

    return Scaffold(
      backgroundColor: navyBlue,
      appBar: AppBar(
        backgroundColor: navyBlue,
        elevation: 0,
        leading: const IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: null, // Add navigation logic here
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Community Guidelines',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Help us maintain a safe, supportive community for all military families',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: lightBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Core Values Section ---
            _SectionCard(
              title: 'Our Core Values',
              child: Column(
                children: const [
                  _ValueTile(
                    icon: Icons.favorite_border,
                    title: 'Be Respectful and Supportive',
                    subtitle: 'Treat all community members with kindness and respect. We\'re here to support each other through the challenges of military life.',
                  ),
                  _ValueTile(
                    icon: Icons.groups_outlined,
                    title: 'Foster Community',
                    subtitle: 'Share advice, answer questions, and help newcomers feel welcome. Your experience can make someone\'s PCS journey easier.',
                  ),
                  _ValueTile(
                    icon: Icons.shield_outlined,
                    title: 'Protect OPSEC',
                    subtitle: 'Never share sensitive military information, deployment details, or specific security procedures. When in doubt, leave it out.',
                  ),
                  _ValueTile(
                    icon: Icons.lock_outline,
                    title: 'Respect Privacy',
                    subtitle: 'Don\'t share personal information about others without permission. Keep private conversations private.',
                  ),
                  _ValueTile(
                    icon: Icons.warning_amber_rounded,
                    title: 'Keep It Family-Friendly',
                    subtitle: 'Use appropriate language and content. This is a community for all ages and backgrounds.',
                  ),
                  _ValueTile(
                    icon: Icons.flag_outlined,
                    title: 'Report Issues',
                    subtitle: 'If you see content that violates our guidelines, please report it. Help us keep this community safe and welcoming.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Prohibited Content Section ---
            _SectionCard(
              title: 'Prohibited Content',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('The following types of content are not allowed on PCS Village:',
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 12),
                  ...[
                    'Personal attacks, harassment, or bullying',
                    'Hate speech or discriminatory content',
                    'Spam or excessive self-promotion',
                    'Sharing of sensitive military information',
                    'Explicit or inappropriate content',
                    'Impersonation or false information',
                  ].map((text) => _BulletPoint(text)).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Reporting Violations (Highlighted) ---
            _SectionCard(
              title: 'Reporting Violations',
              color: warningBackground,
              child: const Text(
                'If you encounter content or behavior that violates these guidelines, please report it immediately. Our team reviews all reports and takes appropriate action.\n\nRepeated violations may result in temporary suspension or permanent removal from the community.',
                style: TextStyle(color: navyBlue, fontSize: 13, height: 1.4),
              ),
            ),
            const SizedBox(height: 16),

            // --- Questions Section ---
            _SectionCard(
              title: 'Questions?',
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                  children: [
                    TextSpan(text: 'If you have questions about these guidelines or need clarification on what\'s allowed, please contact our support team at '),
                    TextSpan(
                      text: 'support@pcsvillage.com',
                      style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? color;

  const _SectionCard({required this.title, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3358))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ValueTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEDF1F7),
            child: Icon(icon, color: const Color(0xFF1A3358)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A3358))),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 13))),
        ],
      ),
    );
  }
}