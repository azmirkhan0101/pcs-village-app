class NotificationModel {
  final String name;
  final String action;
  final String time;
  final String imageUrl;
  final bool isUnread;
  final bool hasActionButtons;
  String? content;

  NotificationModel({
    required this.name,
    required this.action,
    required this.time,
    required this.imageUrl,
    this.isUnread = false,
    this.hasActionButtons = false,
    this.content,
  });

  // Optional: Factory constructor for JSON mapping
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      name: json['name'] as String,
      action: json['action'] as String,
      time: json['time'] as String,
      imageUrl: json['imageUrl'] as String,
      isUnread: json['isUnread'] as bool? ?? false,
      hasActionButtons: json['hasActionButtons'] as bool? ?? false,
    );
  }

  // Optional: Method to convert object back to Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'action': action,
      'time': time,
      'imageUrl': imageUrl,
      'isUnread': isUnread,
      'hasActionButtons': hasActionButtons,
    };
  }
}