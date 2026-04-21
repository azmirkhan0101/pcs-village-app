class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String message;
  final List<String> attachments;
  final bool isSeen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageStatus status;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.message,
    required this.attachments,
    required this.isSeen,
    required this.createdAt,
    required this.updatedAt,
    this.status = MessageStatus.sent,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      conversationId: json['conversation'] as String,
      senderId: json['sender'] as String,
      message: json['message'] as String,
      attachments: List<String>.from(json['attachments'] ?? []),
      isSeen: json['isSeen'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: MessageStatus.sent,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'conversation': conversationId,
    'sender': senderId,
    'message': message,
    'attachments': attachments,
    'isSeen': isSeen,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? message,
    List<String>? attachments,
    bool? isSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageStatus? status,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      attachments: attachments ?? this.attachments,
      isSeen: isSeen ?? this.isSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  /// Creates a temporary optimistic message before server confirmation.
  factory MessageModel.optimistic({
    required String tempId,
    required String conversationId,
    required String senderId,
    required String message,
  }) {
    final now = DateTime.now();
    return MessageModel(
      id: tempId,
      conversationId: conversationId,
      senderId: senderId,
      message: message,
      attachments: [],
      isSeen: false,
      createdAt: now,
      updatedAt: now,
      status: MessageStatus.sending,
    );
  }
}

enum MessageStatus { sending, sent, failed }