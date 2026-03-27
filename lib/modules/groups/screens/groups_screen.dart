import 'package:flutter/material.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF213A5E), // Navy blue header
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Groups',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Community Feed',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 25),
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search groups.....',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Groups List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: const [
                GroupCard(
                  title: 'PCS to Fort Liberty - Spring 2026',
                  subtitle: 'For families PCSing to Fort Liberty',
                  members: '124 members',
                  imageUrl: 'https://picsum.photos/id/22/200',
                ),
                GroupCard(
                  title: 'Army Spouses Support Group',
                  subtitle: 'Connecting and supporting Army...',
                  members: '425 members',
                  imageUrl: 'https://picsum.photos/id/64/200',
                ),
                GroupCard(
                  title: 'Fort Liberty Fitness & Wellness',
                  subtitle: 'Connecting and supporting Army...',
                  members: '425 members',
                  imageUrl: 'https://picsum.photos/id/64/200', // Reusing image as per UI
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String members;
  final String imageUrl;

  const GroupCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.members,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Group Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF213A5E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people_outline, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 5),
                    Text(
                      members,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}