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
  final List<String> localImagePaths; // local file paths for optimistic image bubbles

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
    this.localImagePaths = const [],  // defaults to empty — no change to existing usage
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
      // localImagePaths intentionally omitted — server never sends local paths
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
    // localImagePaths intentionally omitted — client-only field
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
    List<String>? localImagePaths,
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
      localImagePaths: localImagePaths ?? this.localImagePaths,
    );
  }

  factory MessageModel.optimistic({
    required String tempId,
    required String conversationId,
    required String senderId,
    required String message,
    List<String> attachments = const [],
    List<String> localImagePaths = const [],
  }) {
    final now = DateTime.now();
    return MessageModel(
      id: tempId,
      conversationId: conversationId,
      senderId: senderId,
      message: message,
      attachments: attachments,
      isSeen: false,
      createdAt: now,
      updatedAt: now,
      status: MessageStatus.sending,
      localImagePaths: localImagePaths,
    );
  }
}

enum MessageStatus { sending, sent, failed }