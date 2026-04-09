import 'package:pcs_village/data/models/profile/station_model.dart';

import '../auth/branch_model.dart';

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String status;
  final String role;
  final bool isTwoFactorEnabled;
  final bool isOtpVerified;
  final BranchModel? branch;
  final String affiliation;
  final List<String> interestTags;
  final List<String> kidsAgeRanges;
  final DateTime estimatedPcsDate;
  final StationModel? futureStation;
  final StationModel? currentStation;

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
      profileImage: json['profileImage'],
      status: json['status'] ?? '',
      role: json['role'] ?? '',
      isTwoFactorEnabled: json['isTwoFactorEnabled'] ?? false,
      isOtpVerified: json['isOtpVerified'] ?? false,
      branch: json['branch'] != null ? BranchModel.fromJson(json['branch']) : null,
      affiliation: json['affiliation'] ?? '',
      interestTags: List<String>.from(json['interestTags'] ?? []),
      kidsAgeRanges: List<String>.from(json['kidsAgeRanges'] ?? []),
      estimatedPcsDate: DateTime.parse(json['estimatedPcsDate']),
      futureStation: json['futureStation'] != null ? StationModel.fromJson(json['futureStation']) : null,
      currentStation: json['currentStation'] != null ? StationModel.fromJson(json['currentStation']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      "profileImage" : profileImage,
      'status': status,
      'role': role,
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'isOtpVerified': isOtpVerified,
      'branch': branch?.toJson(),
      'affiliation': affiliation,
      'interestTags': interestTags.map((tag) => tag.toString()).toList(),
      'kidsAgeRanges': kidsAgeRanges.map((range) => range.toString()).toList(),
      'estimatedPcsDate': estimatedPcsDate.toIso8601String(),
      'futureStation': futureStation?.toJson(),
      'currentStation': currentStation?.toJson()
    };
  }
}