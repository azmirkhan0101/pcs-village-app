import 'package:flutter/material.dart';

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
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(Icons.more_vert, color: Colors.grey),
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
          ? _buildMyPostItems()
          : _buildOtherPostItems(),
    );
  }

  List<PopupMenuEntry<String>> _buildMyPostItems() {
    return [
      _buildMenuItem(
        value: 'edit',
        icon: Icons.edit_outlined,
        label: 'Edit',
      ),
      _buildMenuItem(
        value: 'delete',
        icon: Icons.delete_outline,
        label: 'Delete',
        color: Colors.red,
      ),
    ];
  }

  List<PopupMenuEntry<String>> _buildOtherPostItems() {
    return [
      _buildMenuItem(
        value: 'report',
        icon: Icons.report_problem_outlined,
        label: 'Report',
        color: Colors.orange,
      ),
    ];
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(color: color),
        ),
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact
      ),
    );
  }
}