import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  // Sample data to mimic the screenshot
  final List<Map<String, dynamic>> messages = const [
    {
      'name': 'Sarah M.',
      'message': 'Thanks for the info! Really helpful',
      'time': '5m ago',
      'unread': 2,
      'isOnline': true,
      'isVerified': true,
    },
    {
      'name': 'Jennifer K.',
      'message': 'Would love to meet up for coffee',
      'time': '1h ago',
      'unread': 0,
      'isOnline': true,
      'isVerified': true,
    },
    {
      'name': 'Lisa T.',
      'message': 'The school tour was great, highly recommend',
      'time': '3h ago',
      'unread': 0,
      'isOnline': false,
      'isVerified': false,
    },
    {
      'name': 'Emily R.',
      'message': 'See you at the meet-up on Tuesday',
      'time': '1d ago',
      'unread': 0,
      'isOnline': false,
      'isVerified': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            color: const Color(0xFF1E3A5F), // Deep blue color from image
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Community Feed',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search message.....',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List Section
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, index) {
                final item = messages[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey,
                        // Replace with NetworkImage(url) in a real app
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      if (item['isOnline'])
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      if (item['isVerified']) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle_outline, size: 16, color: Colors.grey),
                      ]
                    ],
                  ),
                  subtitle: Text(
                    item['message'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(item['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      if (item['unread'] > 0)
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xFF1E3A5F),
                          child: Text(
                            '${item['unread']}',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        )
                      else
                        const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}