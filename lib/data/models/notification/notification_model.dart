enum NotificationType {
  waveReceived,
  waveAccepted,
  newMessage,
  postLike,
  postComment,
  groupPostComment,
  groupPostLike;

  static NotificationType fromString(String value) {
    switch (value) {
      case 'WAVE_RECEIVED':
        return NotificationType.waveReceived;
      case 'WAVE_ACCEPTED':
        return NotificationType.waveAccepted;
      case 'NEW_MESSAGE':
        return NotificationType.newMessage;
      case 'POST_LIKE':
        return NotificationType.postLike;
      case 'POST_COMMENT':
        return NotificationType.postComment;
      case 'GROUP_POST_COMMENT':
        return NotificationType.groupPostComment;
      case 'GROUP_POST_LIKE':
        return NotificationType.groupPostLike;
      default:
        throw ArgumentError('Unknown NotificationType: $value');
    }
  }

  String toJson() {
    switch (this) {
      case NotificationType.waveReceived:
        return 'WAVE_RECEIVED';
      case NotificationType.waveAccepted:
        return 'WAVE_ACCEPTED';
      case NotificationType.newMessage:
        return 'NEW_MESSAGE';
      case NotificationType.postLike:
        return 'POST_LIKE';
      case NotificationType.postComment:
        return 'POST_COMMENT';
      case NotificationType.groupPostComment:
        return 'GROUP_POST_COMMENT';
      case NotificationType.groupPostLike:
        return 'GROUP_POST_LIKE';
    }
  }
}

// ---------------------------------------------------------------------------
// Abstract base for all entityDetails variants
// ---------------------------------------------------------------------------

abstract class BaseEntityDetails {
  const BaseEntityDetails();
}

// ---------------------------------------------------------------------------
// CommunityPostEntityDetails
// Used for: POST_LIKE, POST_COMMENT
// ---------------------------------------------------------------------------

class CommunityPostEntityDetails extends BaseEntityDetails {
  final String id;
  final String author;
  final String station;
  final String content;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommunityPostEntityDetails({
    required this.id,
    required this.author,
    required this.station,
    required this.content,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommunityPostEntityDetails.fromJson(Map<String, dynamic> json) {
    return CommunityPostEntityDetails(
      id: json['_id'] as String,
      author: json['author'] as String,
      station: json['station'] as String,
      content: json['content'] as String,
      attachments: List<String>.from(json['attachments'] as List? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'author': author,
    'station': station,
    'content': content,
    'attachments': attachments,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

// ---------------------------------------------------------------------------
// GroupPostEntityDetails
// Used for: GROUP_POST_LIKE, GROUP_POST_COMMENT
// ---------------------------------------------------------------------------

class GroupPostEntityDetails extends BaseEntityDetails {
  final String id;
  final String group;
  final String author;
  final String content;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GroupPostEntityDetails({
    required this.id,
    required this.group,
    required this.author,
    required this.content,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupPostEntityDetails.fromJson(Map<String, dynamic> json) {
    return GroupPostEntityDetails(
      id: json['_id'] as String,
      group: json['group'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      attachments: List<String>.from(json['attachments'] as List? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'group': group,
    'author': author,
    'content': content,
    'attachments': attachments,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

// ---------------------------------------------------------------------------
// ConversationEntityDetails
// Used for: WAVE_RECEIVED, WAVE_ACCEPTED, NEW_MESSAGE
// ---------------------------------------------------------------------------

class ConversationEntityDetails extends BaseEntityDetails {
  final String id;
  final List<String> participant;
  final String initiator;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationEntityDetails({
    required this.id,
    required this.participant,
    required this.initiator,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationEntityDetails.fromJson(Map<String, dynamic> json) {
    return ConversationEntityDetails(
      id: json['_id'] as String,
      participant: List<String>.from(json['participant'] as List? ?? []),
      initiator: json['initiator'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'participant': participant,
    'initiator': initiator,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

// ---------------------------------------------------------------------------
// NotificationModel — main model
// ---------------------------------------------------------------------------

class NotificationModel {
  final String id;
  final String receiver;
  final NotificationType type;
  final String title;
  final String message;
  final String entityId;
  final String entityModel;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? readAt;
  final BaseEntityDetails? entityDetails;

  const NotificationModel({
    required this.id,
    required this.receiver,
    required this.type,
    required this.title,
    required this.message,
    required this.entityId,
    required this.entityModel,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
    this.entityDetails,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final NotificationType type =
    NotificationType.fromString(json['type'] as String);

    final rawDetails = json['entityDetails'] as Map<String, dynamic>?;

    BaseEntityDetails? entityDetails;
    if (rawDetails != null) {
      switch (type) {
        case NotificationType.postLike:
        case NotificationType.postComment:
          entityDetails = CommunityPostEntityDetails.fromJson(rawDetails);
          break;
        case NotificationType.groupPostComment:
        case NotificationType.groupPostLike:
          entityDetails = GroupPostEntityDetails.fromJson(rawDetails);
          break;
        case NotificationType.waveReceived:
        case NotificationType.waveAccepted:
        case NotificationType.newMessage:
          entityDetails = ConversationEntityDetails.fromJson(rawDetails);
          break;
      }
    }

    return NotificationModel(
      id: json['_id'] as String,
      receiver: json['receiver'] as String,
      type: type,
      title: json['title'] as String,
      message: json['message'] as String,
      entityId: json['entityId'] as String,
      entityModel: json['entityModel'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      entityDetails: entityDetails,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? detailsJson;
    if (entityDetails is CommunityPostEntityDetails) {
      detailsJson =
          (entityDetails as CommunityPostEntityDetails).toJson();
    } else if (entityDetails is GroupPostEntityDetails) {
      detailsJson = (entityDetails as GroupPostEntityDetails).toJson();
    } else if (entityDetails is ConversationEntityDetails) {
      detailsJson =
          (entityDetails as ConversationEntityDetails).toJson();
    }

    return {
      '_id': id,
      'receiver': receiver,
      'type': type.toJson(),
      'title': title,
      'message': message,
      'entityId': entityId,
      'entityModel': entityModel,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (readAt != null) 'readAt': readAt!.toIso8601String(),
      if (detailsJson != null) 'entityDetails': detailsJson,
    };
  }

  CommunityPostEntityDetails? get asCommunityPost =>
      entityDetails is CommunityPostEntityDetails
          ? entityDetails as CommunityPostEntityDetails
          : null;

  GroupPostEntityDetails? get asGroupPost =>
      entityDetails is GroupPostEntityDetails
          ? entityDetails as GroupPostEntityDetails
          : null;

  ConversationEntityDetails? get asConversation =>
      entityDetails is ConversationEntityDetails
          ? entityDetails as ConversationEntityDetails
          : null;
}