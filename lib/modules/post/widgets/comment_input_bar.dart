import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/widgets/cached_image_widget.dart';

class CommentInputBar extends StatelessWidget {
  final TextEditingController textController;
  final String? profileImageUrl;
  final String? replyingToName;
  final VoidCallback onCancelReply;
  final VoidCallback onSend;
  final String hintText;

  const CommentInputBar({
    super.key,
    required this.textController,
    required this.onSend,
    required this.onCancelReply,
    this.profileImageUrl,
    this.replyingToName,
    this.hintText = 'Write a comment...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply Preview Header
            if (replyingToName != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.reply, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Replying to $replyingToName",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    GestureDetector(
                      onTap: onCancelReply,
                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            // Input Row
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: hintText,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _buildSendButton(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          imageUrl: profileImageUrl ?? "",
          iconSize: 25,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: onSend,
        child: SvgPicture.asset(Assets.icons.send),
      ),
    );
  }
}