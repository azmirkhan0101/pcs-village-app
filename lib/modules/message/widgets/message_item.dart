import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/message/message_model.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  static const _navy = Color(0xFF1B365D);

  const MessageItem({
    required this.message,
    required this.isMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = message.attachments.isNotEmpty || message.localImagePaths.isNotEmpty;
    final hasText = message.message.trim().isNotEmpty;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? _navy : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (hasImages) _buildImageGrid(context),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasText)
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  if (hasText) const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.createdAt.toLocal()),
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Image grid ─────────────────────────────────────────────────────────────

  Widget _buildImageGrid(BuildContext context) {
    // Optimistic message: localImagePaths is set, attachments is still empty.
    // Confirmed message: attachments has remote URLs, localImagePaths is empty.
    final isLocal = message.localImagePaths.isNotEmpty && message.attachments.isEmpty;
    final allImages = isLocal ? message.localImagePaths : message.attachments;

    if (allImages.isEmpty) return const SizedBox.shrink();

    if (allImages.length == 1) {
      return _ImageTile(
        url: allImages[0],
        isLocal: isLocal,
        height: 200,
        onTap: () => _openOverlay(context, allImages[0], isLocal),
      );
    }

    if (allImages.length == 2) {
      return Row(
        children: allImages
            .map((url) => Expanded(
          child: _ImageTile(
            url: url,
            isLocal: isLocal,
            height: 140,
            padding: const EdgeInsets.all(2),
            onTap: () => _openOverlay(context, url, isLocal),
          ),
        ))
            .toList(),
      );
    }

    // 3+ images: 2-column grid, max 4 visible, "+N" badge on last cell
    final display = allImages.take(4).toList();
    final extra = allImages.length - 4;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      childAspectRatio: 1,
      children: List.generate(display.length, (i) {
        final isLastWithMore = i == 3 && extra > 0;
        return GestureDetector(
          onTap: () => _openOverlay(context, display[i], isLocal),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _rawImageWidget(display[i], isLocal: isLocal),
              if (isLastWithMore)
                Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Text(
                    '+$extra',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  void _openOverlay(BuildContext context, String url, bool isLocal) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ImageOverlay(imageUrl: url, isLocal: isLocal),
    );
  }

  Widget _rawImageWidget(String url, {required bool isLocal, double? height}) {
    if (isLocal) {
      return Image.file(
        File(url),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _BrokenImage(),
      );
    }
    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          height: height ?? 120,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (_, __, ___) => const _BrokenImage(),
    );
  }

  // ─── Status icon (unchanged) ─────────────────────────────────────────────────

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.white54,
          ),
        );
      case MessageStatus.failed:
        return const Tooltip(
          message: 'Failed to send',
          child: Icon(Icons.error_outline, size: 14, color: Colors.redAccent),
        );
      case MessageStatus.sent:
        return Icon(
          message.isSeen ? Icons.done_all : Icons.done,
          size: 14,
          color: message.isSeen ? Colors.lightBlueAccent : Colors.white54,
        );
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
}

// ─── Reusable image tile ───────────────────────────────────────────────────────

class _ImageTile extends StatelessWidget {
  final String url;
  final bool isLocal;
  final double height;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;

  const _ImageTile({
    required this.url,
    required this.isLocal,
    required this.height,
    required this.onTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: isLocal
              ? Image.file(
            File(url),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _BrokenImage(),
          )
              : Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
            errorBuilder: (_, __, ___) => const _BrokenImage(),
          ),
        ),
      ),
    );
  }
}

// ─── Full-screen overlay ───────────────────────────────────────────────────────

class _ImageOverlay extends StatefulWidget {
  final String imageUrl;
  final bool isLocal;

  const _ImageOverlay({required this.imageUrl, required this.isLocal});

  @override
  State<_ImageOverlay> createState() => _ImageOverlayState();
}

class _ImageOverlayState extends State<_ImageOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  final TransformationController _transformController = TransformationController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scaleAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _transformController.dispose();
    super.dispose();
  }

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
            GestureDetector(
              onDoubleTap: () =>
              _transformController.value = Matrix4.identity(),
              child: InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.5,
                maxScale: 5.0,
                child: widget.isLocal
                    ? Image.file(File(widget.imageUrl), fit: BoxFit.contain)
                    : Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 200,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Colors.white)),
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
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
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
            Positioned(
              bottom: 28,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 0.0),
                duration: const Duration(seconds: 2),
                builder: (_, opacity, child) =>
                    Opacity(opacity: opacity, child: child),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
    );
  }
}