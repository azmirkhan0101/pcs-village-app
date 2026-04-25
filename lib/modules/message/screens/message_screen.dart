import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcs_village/core/utils/app_colors.dart';
import 'package:pcs_village/core/widgets/cached_image_widget.dart';
import 'package:pcs_village/modules/message/controllers/message_controller.dart';
import 'package:pcs_village/modules/message/widgets/message_input_bar.dart';

import '../widgets/message_item.dart';
import '../widgets/skeleton_message_loader.dart';
import '../widgets/typing_indicator.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final MessageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MessageController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildBody()),

          // Typing indicator
          Obx(() {
            if (_controller.isTyping.value) {
              return TypingIndicator(friendName: _controller.participantModel.name);
            }
            return const SizedBox.shrink();
          }),

          // Staged image preview strip (shown when images are selected)
          Obx(() {
            if (_controller.selectedImages.isEmpty) return const SizedBox.shrink();
            return _buildImagePreviewStrip();
          }),

          // Input bar — now with image button
          _buildInputBar(),
        ],
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const BackButton(),
      title: Row(
        children: [
          Stack(
            children: [
              CachedImageWidget(
                imageUrl: _controller.participantModel.profileImage,
                borderRadius: 100,
                height: 45,
                width: 45,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _controller.participantModel.name,
                style: TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() => Text(
                _controller.isConnected.value ? 'Connected' : 'Connecting...',
                style: TextStyle(
                  color: _controller.isConnected.value
                      ? AppColors.greenPrimary
                      : Colors.orange,
                  fontSize: 12,
                ),
              )),
            ],
          ),
          const SizedBox(width: 4),
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return Obx(() {
      if (_controller.messageHelper.isLoading.value && _controller.messages.isEmpty) {
        return const SkeletonMessageLoader();
      }

      if (_controller.messages.isEmpty) {
        return const Center(
          child: Text(
            'No messages yet.\nSay hello!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        controller: _controller.scrollController,
        padding: const EdgeInsets.all(16),
        reverse: true,
        itemCount: _controller.messages.length + 1,
        itemBuilder: (context, index) {
          if (index == _controller.messages.length) {
            return Obx(() => _controller.messageHelper.isMoreLoading.value
                ? const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator()),
            )
                : const SizedBox.shrink());
          }

          final msg = _controller.messages[index];
          final isMe = msg.senderId == _controller.currentUserId;

          // Pass image tap handler down to MessageItem
          return MessageItem(
            message: msg,
            isMe: isMe,
            //onImageTap: (imageUrl) => _showImageOverlay(context, imageUrl),
          );
        },
      );
    });
  }

  // ─── Staged image preview strip ───────────────────────────────────────────

  Widget _buildImagePreviewStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Selected images',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _controller.clearSelectedImages,
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: Obx(() => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.selectedImages.length + 1, // +1 for add button
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                // Last item = "add more" button
                if (index == _controller.selectedImages.length) {
                  return _buildAddMoreButton();
                }
                return _buildStagedImageThumbnail(index);
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildStagedImageThumbnail(int index) {
    final file = _controller.selectedImages[index];
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            file,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _controller.removeSelectedImage(index),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddMoreButton() {
    return GestureDetector(
      onTap: _controller.pickImages,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[500], size: 28),
      ),
    );
  }

  // ─── Input bar with image button ──────────────────────────────────────────

  Widget _buildInputBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Image picker button
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Obx(() => IconButton(
            onPressed: _controller.isUploadingImages.value ? null : _controller.pickImages,
            icon: _controller.isUploadingImages.value
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Icon(
              Icons.image_outlined,
              color: AppColors.navy,
              size: 26,
            ),
          )),
        ),

        // Original input bar
        Expanded(
          child: MessageInputBar(
            textController: _controller.textController,
            onTextChanged: (value) {
              if (value.isNotEmpty) {
                _controller.notifyTyping();
              }
            },
            onSend: () {
              _controller.handleSend();
            },
          ),
        ),
      ],
    );
  }

  // ─── Full-screen image overlay ─────────────────────────────────────────────

  void _showImageOverlay(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ImageOverlay(imageUrl: imageUrl),
    );
  }
}

// ─── Full-screen image overlay widget ─────────────────────────────────────────

class _ImageOverlay extends StatefulWidget {
  final String imageUrl;
  const _ImageOverlay({required this.imageUrl});

  @override
  State<_ImageOverlay> createState() => _ImageOverlayState();
}

class _ImageOverlayState extends State<_ImageOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  late final TransformationController _transformController;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  bool get _isLocal => widget.imageUrl.startsWith('/');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pinch-to-zoom image
            GestureDetector(
              onDoubleTap: _resetZoom,
              child: InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.5,
                maxScale: 5.0,
                child: _isLocal
                    ? Image.file(
                  File(widget.imageUrl),
                  fit: BoxFit.contain,
                )
                    : Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),

            // Close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),

            // "Double-tap to reset zoom" hint — disappears after 2s
            Positioned(
              bottom: 24,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 0.0),
                duration: const Duration(seconds: 2),
                builder: (_, opacity, child) =>
                    Opacity(opacity: opacity, child: child),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Pinch to zoom · Double-tap to reset',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}