import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommentSkeletonLoader extends StatelessWidget {
  const CommentSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 18, backgroundColor: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
