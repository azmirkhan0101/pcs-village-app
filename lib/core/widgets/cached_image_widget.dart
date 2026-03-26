import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CachedImageWidget extends StatelessWidget {

  final String imageUrl;
  final IconData icon;
  final double iconSize;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.icon = Icons.person,
    this.iconSize = 70
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon( icon, size: iconSize.r, color: Colors.white),
      ),
    );
  }
}
