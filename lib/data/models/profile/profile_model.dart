import 'package:pcs_village/data/models/profile/station_model.dart';

import '../auth/branch_model.dart';

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String status;
  final String role;
  final bool isTwoFactorEnabled;
  final bool isOtpVerified;
  final BranchModel branch;
  final String affiliation;
  final List<String> interestTags;
  final List<String> kidsAgeRanges;
  final DateTime estimatedPcsDate;
  final StationModel futureStation;
  final StationModel currentStation;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.status,
    required this.role,
    required this.isTwoFactorEnabled,
    required this.isOtpVerified,
    required this.branch,
    required this.affiliation,
    required this.interestTags,
    required this.kidsAgeRanges,
    required this.estimatedPcsDate,
    required this.futureStation,
    required this.currentStation,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      status: json['status'] ?? '',
      role: json['role'] ?? '',
      isTwoFactorEnabled: json['isTwoFactorEnabled'] ?? false,
      isOtpVerified: json['isOtpVerified'] ?? false,
      branch: BranchModel.fromJson(json['branch']),
      affiliation: json['affiliation'] ?? '',
      interestTags: List<String>.from(json['interestTags'] ?? []),
      kidsAgeRanges: List<String>.from(json['kidsAgeRanges'] ?? []),
      estimatedPcsDate: DateTime.parse(json['estimatedPcsDate']),
      futureStation: StationModel.fromJson(json['futureStation']),
      currentStation: StationModel.fromJson(json['currentStation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'status': status,
      'role': role,
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'isOtpVerified': isOtpVerified,
      'branch': branch.toJson(),
      'affiliation': affiliation,
      'interestTags': interestTags,
      'kidsAgeRanges': kidsAgeRanges,
      'estimatedPcsDate': estimatedPcsDate.toIso8601String(),
      'futureStation': futureStation.toJson(),
      'currentStation': currentStation.toJson(),
    };
  }
}