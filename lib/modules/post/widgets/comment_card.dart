import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/time_ago_calculator.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../data/models/post/comment_model.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final bool isReply;
  final bool isExpanded;

  /// Whether this comment belongs to the current user — shows a ⋮ delete menu
  final bool isMe;

  /// Called when the user taps "Reply"
  final VoidCallback? onReplyTap;

  /// Called when the user taps "Replies (n)" / "Hide Replies"
  final VoidCallback? onToggleReplies;

  /// Called when the user taps "Delete" in the ⋮ menu
  final VoidCallback? onDeleteTap;

  /// Builder for each reply — lets the parent wire up its own state/callbacks
  final Widget Function(Comment reply)? replyBuilder;

  const CommentCard({
    super.key,
    required this.comment,
    this.isReply = false,
    this.isExpanded = false,
    this.isMe = false,
    this.onReplyTap,
    this.onToggleReplies,
    this.onDeleteTap,
    this.replyBuilder,
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(isTab: isTab),
              const SizedBox(width: 12),
              Expanded(child: _buildBubble(isTab: isTab)),
            ],
          ),
        ),
        if (isExpanded && comment.replies.isNotEmpty && !isReply)
          Padding(
            padding: const EdgeInsets.only(left: 44.0),
            child: Column(
              children: comment.replies.map((reply) {
                return replyBuilder != null
                    ? replyBuilder!(reply)
                    : CommentCard(comment: reply, isReply: true);
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar({required bool isTab}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: isTab ? 40 : 35,
        width: isTab ? 40 : 35,
        color: Colors.grey.shade200,
        child: CachedImageWidget(
          imageUrl: comment.authorProfileImg ?? "",
          iconSize: 27,
        ),
      ),
    );
  }

  Widget _buildBubble({required bool isTab}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAuthorRow(isTab: isTab),
          const SizedBox(height: 4),
          Text(
            comment.content,
            style: TextStyle(color: Color(0xFF4A5568), fontSize: isTab ? 12.sp : null),
          ),
          const SizedBox(height: 8),
          _buildFooterRow(isTab: isTab),
        ],
      ),
    );
  }

  Widget _buildAuthorRow({required bool isTab}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          comment.authorName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTab ? 12.sp : null),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.verified,
          size: isTab ? 23 : 16,
          color: Colors.blueGrey,
        ),
        //SvgPicture.asset(Assets.icons.verified),
        if (isMe) ...[
          const Spacer(),
          SizedBox(
            height: isTab ? 30 : 20,
            width: isTab ? 30 : 20,
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, size: isTab ? 30 : 16, color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) {
                if (value == 'delete') onDeleteTap?.call();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: isTab ? 27 : 16, color: Colors.red),
                      const SizedBox(width: 8),
                       Text(
                        'Delete',
                        style: TextStyle(color: Colors.red, fontSize: isTab ? 10.sp : 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooterRow({required bool isTab}) {
    return Row(
      children: [
        Text(
          timeAgo(comment.createdAt),
          style: TextStyle(fontSize: isTab ? 10.sp : 12, color: Colors.grey),
        ),
        if (!isReply) ...[
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onReplyTap,
            child: Text(
              'Reply',
              style: TextStyle(
                fontSize: isTab ? 10.sp : 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ],
        if (comment.replies.isNotEmpty && !isReply) ...[
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onToggleReplies,
            child: Text(
              isExpanded
                  ? 'Hide Replies'
                  : 'Replies (${comment.replies.length})',
              style: TextStyle(
                fontSize: isTab ? 10.sp : 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
          ),
        ],
      ],
    );
  }
}