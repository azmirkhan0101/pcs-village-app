import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/notification/notification_item.dart';
import '../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.find<NotificationController>();


  @override
  Widget build(BuildContext context) {
    // Mock data based on your image
    final List<NotificationModel> notifications = [
      NotificationModel(
        name: 'Alex M.',
        action: 'waved at you 👋',
        time: '2m ago',
        imageUrl: 'https://i.pravatar.cc/150?u=alex',
        isUnread: true,
        hasActionButtons: true,
      ),
      NotificationModel(
        name: 'Sarah M.',
        action: 'liked your post',
        content: '"Just moved to Fort Liberty!"',
        time: '5m ago',
        imageUrl: 'https://i.pravatar.cc/150?u=sarah',
        isUnread: true,
      ),
      NotificationModel(
        name: 'Jennifer K.',
        action: 'commented on your post',
        content: '"Dr. Smith at Fayetteville"',
        time: '1h ago',
        imageUrl: 'https://i.pravatar.cc/150?u=jen',
        isUnread: true,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9), // Light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F), // Deep blue header
        elevation: 0,
        toolbarHeight: 100,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Community Feed', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image with Badge
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(item.imageUrl),
                ),
                const SizedBox(width: 12),

                // Content Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 4),
                          const Icon(Icons.check_circle, size: 14, color: Colors.blueGrey),
                          const Spacer(),
                          if (item.isUnread)
                            const CircleAvatar(radius: 4, backgroundColor: Color(0xFF1E3A5F)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(item.action, style: const TextStyle(color: Colors.grey)),
                      if (item.content != null) ...[
                        const SizedBox(height: 4),
                        Text(item.content!, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E3A5F))),
                      ],
                      const SizedBox(height: 8),
                      Text(item.time, style: const TextStyle(color: Colors.grey, fontSize: 12)),

                      // Action Buttons for "Waved" notification
                      if (item.hasActionButtons) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black12)),
                                child: const Text('View Profile', style: TextStyle(color: Colors.black87)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A5F)),
                                child: const Text('Waved Back', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}