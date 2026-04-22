import 'package:flutter/material.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/utils/app_strings.dart';
import 'package:pcs_village/core/utils/time_ago_calculator.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/core/widgets/custom_button.dart';

import '../../../data/models/notification/notification_model.dart';

// --- Mock Models for Data ---
class NotificationData {
  final String userName;
  final String userImageUrl;
  final String? content;
  final bool isUnread;

  NotificationData({
    required this.userName,
    required this.userImageUrl,
    this.content,
    this.isUnread = false,
  });
}

class NotificationItemWidget extends StatelessWidget {
  final NotificationType type;
  final NotificationModel model;

  // Callbacks for buttons
  final VoidCallback? onViewProfile;
  final VoidCallback? onWaveBack;
  final VoidCallback? onTap;

  const NotificationItemWidget({
    super.key,
    required this.type,
    required this.model,
    this.onViewProfile,
    this.onWaveBack,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: model.isRead ? Colors.transparent : Colors.blue.withValues(alpha: 0.05),
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildMessageBody(),
                  if (type == NotificationType.waveReceived) _buildActionButtons(),
                  const SizedBox(height: 4),
                  Text( timeAgo(model.createdAt.toLocal()), style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ),
            if ( !model.isRead )
              const CircleAvatar(radius: 4, backgroundColor: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        //TODO: Replace with actual image
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            color: Colors.white,
            child: CachedImageWidget(
                imageUrl: model.id,
              borderRadius: 100,
              iconSize: 38,

            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(_getIconForType(), size: 14, color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 14),
        children: [
          //TODO: Replace with actual name
          TextSpan(text: model.id, style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: ' '),
          TextSpan(text: _getActionText(), style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildMessageBody() {
    //if (data.content == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        //'"${data.content}"',
        "Content here",
        style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
              child: CustomButton(
                  label: AppStrings.viewProfile,
                onPressed: onViewProfile,
                backgroundColor: Colors.white,
                buttonRadius: 15,
                borderColor: Colors.grey,
                borderWidth: 2,
                buttonHeight: 40,
                textColor:AppColors.primaryColor,
                fontSize: 14,
              )
          ),
          const SizedBox(width: 8),
          Expanded(
              child: CustomButton(
                label: AppStrings.wavedBack,
                onPressed: onWaveBack,
                buttonRadius: 15,
                borderColor: Colors.grey,
                buttonHeight: 40,
                fontSize: 14,
              )
          )
        ],
      )

    );
  }

  // --- Logic Helpers ---

  String _getActionText() {
    switch (type) {
      case NotificationType.waveReceived: return 'waved at you 👋';
      case NotificationType.waveAccepted: return 'accepted your wave';
      case NotificationType.newMessage: return 'sent you a message';
      case NotificationType.postLike:
      case NotificationType.groupPostLike: return 'liked your post';
      case NotificationType.postComment:
      case NotificationType.groupPostComment: return 'commented on your post';
      }
  }

  IconData _getIconForType() {
    switch (type) {
      case NotificationType.waveReceived: return Icons.back_hand;
      case NotificationType.postLike:
      case NotificationType.groupPostLike: return Icons.favorite;
      case NotificationType.postComment:
      case NotificationType.groupPostComment: return Icons.comment;
      case NotificationType.newMessage: return Icons.mail;
      default: return Icons.notifications;
    }
  }
}