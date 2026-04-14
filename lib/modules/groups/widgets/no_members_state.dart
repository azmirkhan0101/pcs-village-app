import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoMembersState extends StatelessWidget {
  const NoMembersState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: Get.height * 0.3),
        const Center(
          child: Text(
            "No members found in this group.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
