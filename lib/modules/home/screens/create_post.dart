import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: CreatePostScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D4369)),
          onPressed: () {},
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Color(0xFF2D4369),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E9AAF), // Muted blue/grey
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text('Post', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with Sarah's image
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sarah.jr',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D4369),
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        Text(
                          ' Fort Liberty, NC',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Text Input Field
            TextField(
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "What's on your mind? Ask a question...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
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

            // Add Photos Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: const [
                  Icon(Icons.image_outlined, color: Colors.grey),
                  SizedBox(width: 12),
                  Text(
                    'Add photos',
                    style: TextStyle(
                      color: Color(0xFF6C7A92),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Community Guidelines Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F0E6), // Light beige background
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Community Guidelines',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D4369),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildGuidelineItem('Be respectful and supportive'),
                  _buildGuidelineItem('No personal attacks or harassment'),
                  _buildGuidelineItem('Keep content family-friendly'),
                  _buildGuidelineItem("Protect OPSEC - don't share sensitive info"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for guidelines list
  Widget _buildGuidelineItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.grey, fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF6C7A92), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}