import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/data/models/blast_post/blast_post_model.dart';

class BlastPostCard extends StatelessWidget {
  final BlastPostModel post;
  final bool isMyAd;
  final VoidCallback? onLinkTap;
  final VoidCallback? onDelete;

  const BlastPostCard({
    super.key,
    required this.post,
    required this.isMyAd,
    this.onLinkTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section: URL and Menu
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 4.w, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.link, color: Colors.blue, size: 20),
                SizedBox(width: 8.w),
                Expanded(
                  child: GestureDetector(
                    onTap: onLinkTap,
                    child: Text(
                      post.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                if( isMyAd )
                _buildAdMenu(),
              ],
            ),
          ),

          // Content spacing
          SizedBox(height: 8.h),

          // Image Section
          _buildAttachments(post.banner),

          // Optional: Add a footer or extra padding at the bottom
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildAttachments(String imageUrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        height: 200.h, // Fixed height looks more consistent in lists
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedImageWidget(
            imageUrl: imageUrl,
            // Assuming your widget handles BoxFit. Cover is best for "cards"
          ),
        ),
      ),
    );
  }

  Widget _buildAdMenu() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_horiz, color: Colors.grey.shade600), // More modern icon
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onSelected: (value) {
        if (value == 'delete') onDelete?.call();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              SizedBox(width: 8.w),
              const Text('Delete Post', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}