class StationModel {
  final String id;
  final String name;
  final String country;
  final String state;
  final String city;
  final String type;
  final bool isApproved;
  final String suggestedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  StationModel({
    required this.id,
    required this.name,
    required this.country,
    required this.state,
    required this.city,
    required this.type,
    required this.isApproved,
    required this.suggestedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      type: json['type'] ?? '',
      isApproved: json['isApproved'] ?? false,
      suggestedBy: json['suggestedBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'type': type,
      'isApproved': isApproved,
      'suggestedBy': suggestedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}