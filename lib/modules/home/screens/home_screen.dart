import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B365D), // Deep Navy Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fort Liberty, NC', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Community Feed', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list, color: Colors.white)),
        ],
      ),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search posts, people, or topics...",
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          // Feed Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F7F9), // Light grey background for feed
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  PostCard(
                    post: Post(
                      name: "Sarah M.",
                      role: "Army Spouse",
                      time: "2h ago",
                      location: "Fort Liberty, NC",
                      content: "Just moved to Fort Liberty! Any recommendations for pediatricians in the area? Looking for someone who takes Tricare. Thanks in advance! 🏥",
                      avatarUrl: "https://i.pravatar.cc/150?u=sarah",
                      likes: 12,
                      comments: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PostCard(
                    post: Post(
                      name: "Jennifer K.",
                      role: "Air Force Spouse",
                      time: "5h ago",
                      location: "Fort Liberty, NC",
                      content: "PSA: There's a wonderful spouse coffee meet-up every Tuesday at 10am at the Spring Lake Community Center. Great way to meet people before your PCS! ☕",
                      avatarUrl: "https://i.pravatar.cc/150?u=jennifer",
                      likes: 24,
                      comments: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6B8E23), // Olive Green
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(post.avatarUrl)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(post.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Icon(Icons.check_circle, size: 14, color: Colors.blue),
                      ],
                    ),
                    Text("${post.role} • ${post.time}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.grey),
                        Text(post.location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content, style: const TextStyle(fontSize: 14, height: 1.4)),
            const Divider(height: 32),
            Row(
              children: [
                const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${post.likes}", style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 24),
                const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${post.comments}", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}