class Post {
  final String name;
  final String role;
  final String time;
  final String location;
  final String content;
  final String avatarUrl;
  final int likes;
  final int comments;

  Post({
    required this.name,
    required this.role,
    required this.time,
    required this.location,
    required this.content,
    required this.avatarUrl,
    required this.likes,
    required this.comments,
  });

  // Factory method to create a Post from a Map (useful for JSON)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      content: json['content'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }

  // Method to convert the model back to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'time': time,
      'location': location,
      'content': content,
      'avatarUrl': avatarUrl,
      'likes': likes,
      'comments': comments,
    };
  }
}