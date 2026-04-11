import 'package:flutter/material.dart';

class MembersTab extends StatelessWidget {
  const MembersTab();

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