import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/extensions.dart';

class PostMenuButton extends StatelessWidget {
  final bool isMyPost;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const PostMenuButton({
    super.key,
    required this.isMyPost,
    this.onEdit,
    this.onDelete,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(Icons.more_vert, color: Colors.grey, size: isTab ? 30 : null,),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
          case 'report':
            onReport?.call();
            break;
        }
      },
      itemBuilder: (context) => isMyPost
          ? _buildMyPostItems(isTab: isTab)
          : _buildOtherPostItems(isTab: isTab),
    );
  }

  List<PopupMenuEntry<String>> _buildMyPostItems({required bool isTab}) {
    return [
      _buildMenuItem(
        value: 'edit',
        icon: Icons.edit_outlined,
        label: 'Edit',
        isTab: isTab
      ),
      _buildMenuItem(
        value: 'delete',
        icon: Icons.delete_outline,
        label: 'Delete',
        color: Colors.red,
        isTab: isTab
      ),
    ];
  }

  List<PopupMenuEntry<String>> _buildOtherPostItems({required bool isTab}) {
    return [
      _buildMenuItem(
        value: 'report',
        icon: Icons.report_problem_outlined,
        label: 'Report',
        color: Colors.orange,
        isTab: isTab
      ),
    ];
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    Color? color,
    required bool isTab
  }) {

    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Icon(icon, color: color, size: isTab ? 30 : null,),
        title: Text(
          label,
          style: TextStyle(color: color, fontSize: isTab ? 10.sp : 14),
        ),
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact
      ),
    );
  }
}