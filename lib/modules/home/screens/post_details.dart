import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets_gen/assets.gen.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF1A365D)),
        title: const Text(
          'Post',
          style: TextStyle(color: Color(0xFF1A365D), fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Main Post Header
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=sarah'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('Sarah M.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(width: 4),
                            Icon(Icons.check_circle, size: 16, color: Colors.blueGrey),
                          ],
                        ),
                        const Text('Army Spouse • 2h ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Row(
                          children: const [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                            Text(' Fort Liberty, NC', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Just moved to Fort Liberty! Any recommendations for pediatricians in the area? Looking for someone who takes Tricare. Thanks in advance! 🏥',
                  style: TextStyle(fontSize: 15, height: 1.4, color: Color(0xFF2D3748)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('12', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 20),
                    Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('2', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Divider(height: 32),
                const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A365D))),
                const SizedBox(height: 16),

                // Comment 1
                _buildCommentTile(
                  name: 'Jennifer K.',
                  image: 'https://i.pravatar.cc/150?u=jen',
                  text: 'Dr. Smith at Fayetteville Pediatrics is wonderful! They\'re super accommodating with Tricare.',
                  time: '1h ago',
                  likes: '5',
                ),

                // Comment 2
                _buildCommentTile(
                  name: 'Lisa T.',
                  image: 'https://i.pravatar.cc/150?u=lisa',
                  text: 'We love Cape Fear Pediatrics! Dr. Johnson has been amazing with our kids.',
                  time: '45m ago',
                  likes: '3',
                ),
              ],
            ),
          ),
          // Bottom Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=me'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(Assets.icons.send,),
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile({required String name, required String image, required String text, required String time, required String likes}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage(image)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (name.contains('Jennifer')) const SizedBox(width: 4),
                      if (name.contains('Jennifer')) const Icon(Icons.check_circle, size: 14, color: Colors.blueGrey),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(text, style: const TextStyle(color: Color(0xFF4A5568))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 16),
                      Text('Like ($likes)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Text('Reply', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}