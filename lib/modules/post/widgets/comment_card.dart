import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets_gen/assets.gen.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(child: _buildBubble()),
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

  Widget _buildAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 35,
        width: 35,
        color: Colors.grey.shade200,
        child: CachedImageWidget(
          imageUrl: comment.authorProfileImg ?? "",
          iconSize: 27,
        ),
      ),
    );
  }

  Widget _buildBubble() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAuthorRow(),
          const SizedBox(height: 4),
          Text(
            comment.content,
            style: const TextStyle(color: Color(0xFF4A5568)),
          ),
          const SizedBox(height: 8),
          _buildFooterRow(),
        ],
      ),
    );
  }

  Widget _buildAuthorRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          comment.authorName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        SvgPicture.asset(Assets.icons.verified),
        if (isMe) ...[
          const Spacer(),
          SizedBox(
            height: 20,
            width: 20,
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert, size: 16, color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) {
                if (value == 'delete') onDeleteTap?.call();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red, fontSize: 13),
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

  Widget _buildFooterRow() {
    return Row(
      children: [
        Text(
          timeAgo(comment.createdAt),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if (!isReply) ...[
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onReplyTap,
            child: const Text(
              'Reply',
              style: TextStyle(
                fontSize: 12,
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
              style: const TextStyle(
                fontSize: 12,
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