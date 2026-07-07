import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pcs_village/core/utils/app_colors.dart';

import '../../../core/utils/extensions.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String members;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.title,
    required this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  title.isNotEmpty ? title[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTab ? 11.sp : 16,
                      color: Color(0xFF213A5E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people_outline,
                          size: isTab ? 30 : 16, color: Colors.grey.shade500),
                      const SizedBox(width: 5),
                      Text(
                        members,
                        style:
                        TextStyle(color: Colors.grey.shade500, fontSize: isTab ? 10.sp : 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey, size: isTab ? 30 : null,),
          ],
        ),
      ),
    );
  }
}