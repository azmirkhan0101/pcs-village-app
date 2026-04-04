class BranchModel {
  final String id;
  final String name;

  BranchModel({
    required this.id,
    required this.name
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['_id'] as String,
      name: json['name'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name
    };
  }
}