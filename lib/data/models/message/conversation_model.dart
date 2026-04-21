class Conversation {
  final String? id;
  final String? initiator;
  final LastMessage? lastMessage;
  final String? opponentName;
  final String? opponentEmail;
  final String? opponentProfileImg;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Conversation({
    this.id,
    this.initiator,
    this.lastMessage,
    this.opponentName,
    this.opponentEmail,
    this.opponentProfileImg,
    this.createdAt,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'],
      initiator: json['initiator'],
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
      opponentName: json['opponentName'],
      opponentEmail: json['opponentEmail'],
      opponentProfileImg: json['opponentProfileImg'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'initiator': initiator,
      'lastMessage': lastMessage?.toJson(),
      'opponentName': opponentName,
      'opponentEmail': opponentEmail,
      'opponentProfileImg': opponentProfileImg,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class LastMessage {
  final String? id;
  final String? conversation;
  final String? sender;
  final String? message;
  final List<dynamic>? attachments;
  final bool? isSeen;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LastMessage({
    this.id,
    this.conversation,
    this.sender,
    this.message,
    this.attachments,
    this.isSeen,
    this.createdAt,
    this.updatedAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['_id'],
      conversation: json['conversation'],
      sender: json['sender'],
      message: json['message'],
      attachments: json['attachments'] != null
          ? List<dynamic>.from(json['attachments'])
          : [],
      isSeen: json['isSeen'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'conversation': conversation,
      'sender': sender,
      'message': message,
      'attachments': attachments,
      'isSeen': isSeen,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}