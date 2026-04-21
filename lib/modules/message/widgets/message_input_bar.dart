import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';

class MessageInputBar extends StatelessWidget {

  final TextEditingController textController;
  final Function(String value) onTextChanged;
  final VoidCallback onSend;

  const MessageInputBar({super.key, required this.textController, required this.onTextChanged, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                onChanged: (value){
                  onTextChanged(value);
                },
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: AppColors.inputGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onSend,
              child: CircleAvatar(
                backgroundColor: AppColors.avatarGrey,
                child: Transform.rotate(
                    angle: -pi/4,
                    child: const Icon(
                      Icons.send, color: Colors.white, size: 20,
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
