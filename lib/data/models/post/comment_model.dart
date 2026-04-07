class Comment {
  final String id;
  final String postId;
  final String content;
  final DateTime createdAt;
  final String authorName;
  final String? authorProfileImg;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.authorName,
    this.authorProfileImg,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] as String,
      postId: json['post'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorName: json['authorName'] as String,
      authorProfileImg: json['authorProfileImg'] as String?,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'post': postId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'authorName': authorName,
      'authorProfileImg': authorProfileImg,
      'replies': replies.map((e) => e.toJson()).toList()
    };
  }
}