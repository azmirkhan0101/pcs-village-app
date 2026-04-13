
class  Post {
  final String id;
  final String content;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authorId;
  final String authorName;
  final String authorEmail;
  final String authorImage;
  final String authorStatus;
  final String authorRole;
  final String stationId;
  final String stationName;
  final String affiliation;
  final String stationCountry;
  final String stationState;
  final String stationCity;
  final String stationType;
  final int commentsCount;
  final int likesCount;

  Post({
    required this.id,
    required this.content,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.authorImage,
    required this.authorStatus,
    required this.authorRole,
    required this.stationId,
    required this.stationName,
    required this.affiliation,
    required this.stationCountry,
    required this.stationState,
    required this.stationCity,
    required this.stationType,
    required this.commentsCount,
    required this.likesCount
  });

  // Factory method to create an instance from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      attachments: List<String>.from(json['attachments'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorEmail: json['authorEmail'] ?? '',
      authorImage: json['authorImage'] ?? '',
      authorStatus: json['authorStatus'] ?? '',
      authorRole: json['authorRole'] ?? '',
      stationId: json['stationId'] ?? '',
      stationName: json['stationName'] ?? '',
      affiliation: json['affiliation'] ?? '',
      stationCountry: json['stationCountry'] ?? '',
      stationState: json['stationState'] ?? '',
      stationCity: json['stationCity'] ?? '',
      stationType: json['stationType'] ?? '',
      commentsCount: json['comments'] ?? 0,
      likesCount: json['likes'] ?? 0,
    );
  }

  // Method to convert instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'authorId': authorId,
      'authorName': authorName,
      'authorEmail': authorEmail,
      'authorImage': authorImage,
      'authorStatus': authorStatus,
      'authorRole': authorRole,
      'stationId': stationId,
      'stationName': stationName,
      'stationCountry': stationCountry,
      'stationState': stationState,
      'stationCity': stationCity,
      'stationType': stationType,
      'comments': commentsCount,
      'likes': likesCount
    };
  }
}