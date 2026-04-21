
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonMessageLoader extends StatelessWidget {
  const SkeletonMessageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          skeletonItem(isMe: false, widthFactor: 0.65),
          skeletonItem(isMe: true, widthFactor: 0.45),
          skeletonItem(isMe: false, widthFactor: 0.72),
          skeletonItem(isMe: true, widthFactor: 0.55),
          skeletonItem(isMe: false, widthFactor: 0.60),
          skeletonItem(isMe: true, widthFactor: 0.40),
        ],
      ),
    );
  }

  Widget skeletonItem({required bool isMe, required double widthFactor}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Builder(builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: MediaQuery.of(context).size.width * widthFactor,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}