import 'package:flutter/material.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // 1. Header Image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: const Color(0xFF1E3A5F),
                leading: _buildCircleBtn(Icons.arrow_back),
                actions: [_buildCircleBtn(Icons.settings)],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    'https://images.unsplash.com/photo-1506869640319-fe1a24fd76dc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 2. Group Info Section
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PCS to Fort Liberty - Spring 2026',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A365D)),
                      ),
                      const SizedBox(height: 12),
                      _buildActionButtons(),
                      const SizedBox(height: 20),

                      // Custom Tab Bar
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: const Color(0xFF1E3A5F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(text: "Posts"),
                            Tab(text: "Members"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              _PostsTab(),
              _MembersTab(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF4F6228),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.3),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A5F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            label: const Text('Notifications On', style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Leave', style: TextStyle(color: Colors.black87)),
          ),
        ),
      ],
    );
  }
}

// --- MEMBERS TAB ---
class _MembersTab extends StatelessWidget {
  const _MembersTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Group Members", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A365D))),
        const SizedBox(height: 12),

        // Search Bar
        TextField(
          decoration: InputDecoration(
            hintText: "Search members...",
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Member List
        _buildMemberCard("Sarah Mitchell", "https://images.unsplash.com/photo-1488161628813-04466f872be2?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
        _buildMemberCard("Sarah Mitchell", "https://i.pravatar.cc/150?u=sarah2"),
        _buildMemberCard("Sarah Mitchell", "https://i.pravatar.cc/150?u=sarah3"),
      ],
    );
  }

  Widget _buildMemberCard(String name, String imgUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(radius: 30, backgroundImage: NetworkImage(imgUrl)),
                    const CircleAvatar(radius: 10, backgroundColor: Colors.white, child: Icon(Icons.check_circle, color: Colors.blue, size: 16)),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1A365D))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                            child: const Text("Military Spouse", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const Text("Army Spouse", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      const Text("📅 Moving in 3 months", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const Text("📍 Fort Carson, CO → Fort Liberty, NC", style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildWaveBtn("Send Wave", const Color(0xFFA68B5B), Icons.front_hand),
                const SizedBox(width: 8),
                _buildSmallBtn("View Profile", const Color(0xFF1E3A5F), Icons.person_outline),
                const SizedBox(width: 8),
                _buildSmallBtn("Message", const Color(0xFF5D6D3E), Icons.chat_bubble_outline),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmallBtn(String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveBtn(String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFFA68B5B), Color(0xFF5D6D3E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
// --- POSTS TAB ---
class _PostsTab extends StatelessWidget {
  const _PostsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        // Section Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Group Discussion',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A365D),
            ),
          ),
        ),

        // Post List
        _buildPostCard(
          name: 'Emily R.',
          role: 'Navy Spouse',
          time: '3h ago',
          location: 'Fort Liberty, NC',
          content: 'Welcome to everyone joining! Just got our orders - moving in April. Can\'t wait to meet you all!',
          likes: '18',
          comments: '12',
          avatarUrl: 'https://i.pravatar.cc/150?u=emily',
        ),
        _buildPostCard(
          name: 'Michael S.',
          role: 'Army Veteran',
          time: '5h ago',
          location: 'Fayetteville, NC',
          content: 'If anyone needs recommendations for local movers or quiet neighborhoods near the Honeycutt gate, feel free to reach out!',
          likes: '24',
          comments: '7',
          avatarUrl: 'https://i.pravatar.cc/150?u=mike',
        ),

        // Add padding at the bottom so the FAB doesn't cover content
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildPostCard({
    required String name,
    required String role,
    required String time,
    required String location,
    required String content,
    required String likes,
    required String comments,
    required String avatarUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 4),
                          Icon(Icons.check_circle, size: 16, color: Colors.blue.shade300),
                        ],
                      ),
                      Text('$role • $time', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: Colors.grey),
                          Text(' $location', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Post Content
              Text(
                content,
                style: const TextStyle(fontSize: 15, height: 1.4, color: Color(0xFF1E3A5F)),
              ),
              const SizedBox(height: 16),

              const Divider(),

              // Footer Interaction Row
              Row(
                children: [
                  const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(likes, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 24),
                  const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(comments, style: const TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}