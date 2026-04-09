
class GroupModel {
  final String id;
  final String type;
  final String timeline;
  final String groupName;
  final String stationId;
  final String stationName;
  final String stationCity;
  final String stationType;
  final String stationState;
  final String stationCountry;
  final DateTime createdAt;
  final int totalMember;
  final bool isAlreadyJoined;
  final bool isArchived;
  final bool isActiveInGroup;

  GroupModel({
    required this.id,
    required this.type,
    required this.timeline,
    required this.groupName,
    required this.stationId,
    required this.stationName,
    required this.stationCity,
    required this.stationType,
    required this.stationState,
    required this.stationCountry,
    required this.createdAt,
    required this.totalMember,
    required this.isAlreadyJoined,
    required this.isArchived,
    required this.isActiveInGroup,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['_id'] as String,
      type: json['type'] as String,
      timeline: json['timeline'] as String,
      groupName: json['groupName'] as String,
      stationId: json['stationId'] as String,
      stationName: json['stationName'] as String,
      stationCity: json['stationCity'] as String,
      stationType: json['stationType'] as String,
      stationState: json['stationState'] as String,
      stationCountry: json['stationCountry'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalMember: json['totalMember'] as int,
      isAlreadyJoined: json['isAlreadyJoined'] as bool,
      isArchived: json['isArchived'] as bool,
      isActiveInGroup: json['isActiveInGroup'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'timeline': timeline,
      'groupName': groupName,
      'stationId': stationId,
      'stationName': stationName,
      'stationCity': stationCity,
      'stationType': stationType,
      'stationState': stationState,
      'stationCountry': stationCountry,
      'createdAt': createdAt.toIso8601String(),
      'totalMember': totalMember,
      'isAlreadyJoined': isAlreadyJoined,
      'isArchived': isArchived,
      'isActiveInGroup': isActiveInGroup
    };
  }
}