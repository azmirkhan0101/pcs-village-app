
import 'package:get/get.dart';

class MemberModel {
  final String id;
  final DateTime joinedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isMatched;
  bool isWavePending;
  bool isIncomingWave;
  final bool isDeclinedByMe;
  final bool isDeclinedByThem;
  final String name;
  final String email;
  final String userId;
  final String group;
  final String membershipStatus;
  final String profileImage;
  final String affiliation;
  final String movement;

  //WAVE LOADING SATE
  RxBool isWaveLoading = false.obs;

  MemberModel({
    required this.id,
    required this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isMatched,
    required this.isWavePending,
    required this.isIncomingWave,
    required this.isDeclinedByMe,
    required this.isDeclinedByThem,
    required this.name,
    required this.email,
    required this.userId,
    required this.group,
    required this.membershipStatus,
    required this.profileImage,
    required this.affiliation,
    required this.movement
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['_id'] ?? '',
      joinedAt: DateTime.parse(json['joinedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isMatched: json['isMatched'] ?? false,
      isWavePending: json['isWavePending'] ?? false,
      isIncomingWave: json['isIncomingWave'] ?? false,
      isDeclinedByMe: json['isDeclinedByMe'] ?? false,
      isDeclinedByThem: json['isDeclinedByThem'] ?? false,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userId: json['userId'] ?? '',
      group: json['group'] ?? '',
      membershipStatus: json['membershipStatus'] ?? '',
      profileImage: json['profileImage'] ?? '',
      affiliation: json['affiliation'] ?? '',
      movement: json['movement'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'joinedAt': joinedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isMatched': isMatched,
      'isWavePending': isWavePending,
      'isIncomingWave': isIncomingWave,
      'isDeclinedByMe': isDeclinedByMe,
      'isDeclinedByThem': isDeclinedByThem,
      'name': name,
      'email': email,
      'userId': userId,
      'group': group,
      'membershipStatus': membershipStatus,
      'profileImage': profileImage,
      'affiliation': affiliation,
      'movement': movement
    };
  }
}