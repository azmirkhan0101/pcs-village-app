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

  const MessageScreen({
    super.key
  });

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
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          Obx((){
            if( _controller.isTyping.value ){
              return TypingIndicator(friendName: _controller.conversation.opponentName,);
            }else{
              return const SizedBox.shrink();
            }
          }),
          MessageInputBar(
              textController: _controller.textController,
              onTextChanged: (value){
                if (value.isNotEmpty) {
                  _controller.notifyTyping();
                }
              },
              onSend: (){
                _controller.handleSend();
              }
          ),
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
                  imageUrl: _controller.conversation.opponentProfileImg,
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
                _controller.conversation.opponentName,
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
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.navy),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (!_controller.isConnected.value && _controller.messages.isEmpty) {
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
        itemCount: _controller.messages.length,
        itemBuilder: (context, index) {
          final msg = _controller.messages[index];
          final isMe = msg.senderId == _controller.currentUserId;
          return MessageItem(message: msg, isMe: isMe);
        },
      );
    });
  }
}