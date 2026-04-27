

class BlastPostModel {
  final String id;
  final String name;
  final String email;
  final String url;
  final String banner;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlastPostModel({
    required this.id,
    required this.name,
    required this.email,
    required this.url,
    required this.banner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlastPostModel.fromJson(Map<String, dynamic> json) {
    return BlastPostModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      url: json['url'] as String,
      banner: json['banner'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'url': url,
      'banner': banner,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}