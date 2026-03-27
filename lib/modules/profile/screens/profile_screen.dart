import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF1B365D);

    return Scaffold(
      backgroundColor: primaryNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildMainProfileCard(primaryNavy),
            _buildInfoCard(
              title: 'Military Information',
              content: [
                _infoRow(Icons.location_on_outlined, 'Current Station', 'Fort Liberty, NC'),
                _infoRow(Icons.location_on_outlined, 'Future Station', 'Joint Base Lewis-McChord, WA'),
                _infoRow(Icons.calendar_today_outlined, 'PCS Timeline', 'Moving within 6 months'),
              ],
            ),
            _buildAboutCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMainProfileCard(Color primaryNavy) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.orange,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Mudari 890', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryNavy)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.verified_user, size: 14, color: primaryNavy),
                    SizedBox(width: 4),
                    Text('Military Spouse', style: TextStyle(fontSize: 10, color: primaryNavy)),
                  ],
                ),
              ),
            ],
          ),
          const Text('Army Spouse', style: TextStyle(color: Colors.grey)),
          const Divider(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(label: 'Posts', count: '12'),
              _StatItem(label: 'Groups', count: '3'),
              _StatItem(label: 'Connections', count: '48'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_document, size: 18),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryNavy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> content}) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
          const SizedBox(height: 16),
          ...content,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return _buildInfoCard(
      title: 'About',
      content: [
        const Text('Branch', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const Text('Army', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
        const SizedBox(height: 16),
        const Text('Kids Age Range', style: TextStyle(color: Colors.grey, fontSize: 12)),
        Wrap(
          spacing: 8,
          children: const [
            Chip(label: Text('Preschool (3-5)')),
            Chip(label: Text('Elementary school')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Interests', style: TextStyle(color: Colors.grey, fontSize: 12)),
        Wrap(
          spacing: 8,
          children: ['Fitness', 'Cooking', 'Reading', 'Travel']
              .map((tag) => Chip(label: Text(tag)))
              .toList(),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String count;
  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B365D))),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}