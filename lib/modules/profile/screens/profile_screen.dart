import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Primary Colors from the UI
    const Color primaryNavy = Color(0xFF1D3557);
    const Color accentBlue = Color(0xFF457B9D);
    const Color backgroundGray = Color(0xFFF1F4F8);

    return Scaffold(
      backgroundColor: primaryNavy,
      appBar: AppBar(
        backgroundColor: primaryNavy,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: backgroundGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // --- Header Card ---
                  _buildCard(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.orangeAccent,
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image
                        ),
                        const SizedBox(height: 12),
                        const Text('Mudari 890', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryNavy)),
                        const SizedBox(height: 4),
                        const Text('Army Spouse', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(label: 'Posts', value: '12'),
                            _StatItem(label: 'Groups', value: '3'),
                            _StatItem(label: 'Connections', value: '48'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryNavy,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.edit_note, color: Colors.white),
                            label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ),

                  // --- Military Information Card ---
                  _buildCard(
                    title: 'Military Information',
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.location_on_outlined, 'Current Station', 'Fort Liberty, NC'),
                        _buildInfoRow(Icons.explore_outlined, 'Future Station', 'Joint Base Lewis-McChord, WA'),
                        _buildInfoRow(Icons.calendar_today_outlined, 'PCS Timeline', 'Moving within 6 months'),
                      ],
                    ),
                  ),

                  // --- About Card ---
                  _buildCard(
                    title: 'About',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(label: 'Branch'),
                        const Text('Army', style: TextStyle(fontWeight: FontWeight.bold, color: primaryNavy)),
                        const SizedBox(height: 16),
                        const _SectionLabel(label: 'Kids Age Range'),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildChip('Preschool (3-5)'),
                            _buildChip('Elementary school'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const _SectionLabel(label: 'Interests'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildChip('Fitness'),
                            _buildChip('Cooking'),
                            _buildChip('Reading'),
                            _buildChip('Travel'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const _SectionLabel(label: 'Member Since'),
                        const Text('January 2026', style: TextStyle(fontWeight: FontWeight.bold, color: primaryNavy)),
                      ],
                    ),
                  ),

                  // --- Footer Menu ---
                  _buildCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildListTile(Icons.workspace_premium_outlined, 'Upgrade to Premium', Colors.orange),
                        const Divider(height: 1),
                        _buildListTile(Icons.description_outlined, 'Community Guidelines', primaryNavy),
                        const Divider(height: 1),
                        _buildListTile(Icons.person_add_alt, 'Invite Friends', primaryNavy),
                        const Divider(height: 1),
                        _buildListTile(Icons.logout, 'Sign Out', Colors.red, isLast: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build a styled card
  Widget _buildCard({required Widget child, String? title, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF457B9D))),
      backgroundColor: const Color(0xFFF1F4F8),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildListTile(IconData icon, String title, Color color, {bool isLast = false}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: isLast ? Colors.red : const Color(0xFF1D3557), fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () {},
    );
  }
}

// Small helper widgets to keep things tidy
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}