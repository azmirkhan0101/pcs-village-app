class SignupModel {

  String? fullName;
  String? email;
  String? password;
  String? militaryBranch;
  String? militaryAffiliation;
  List<String>? interests;
  List<String>? kidsAgeRanges;
  String? currentDutyStation;
  String? futureDutyStation;
  DateTime? timeline;

  SignupModel({
    this.fullName,
    this.email,
    this.password,
    this.militaryBranch,
    this.militaryAffiliation,
    this.interests,
    this.kidsAgeRanges,
    this.currentDutyStation,
    this.futureDutyStation,
    this.timeline
});

  factory SignupModel.fromJson(Map<String, dynamic> json){
    return SignupModel(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      militaryBranch: json['militaryBranch'],
      militaryAffiliation: json['militaryAffiliation'],
      interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
      kidsAgeRanges: json['kidsAgeRanges'] != null ? List<String>.from(json['kidsAgeRanges']) : null,
      currentDutyStation: json['currentDutyStation'],
      futureDutyStation: json['futureDutyStation'],
      timeline: json['timeline'] != null ? DateTime.parse(json['timeline']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'militaryBranch': militaryBranch,
      'militaryAffiliation': militaryAffiliation,
      'interests': interests,
      'kidsAgeRanges': kidsAgeRanges,
      'currentDutyStation': currentDutyStation,
      'futureDutyStation': futureDutyStation,
      'timeline': timeline?.toIso8601String()
    };
  }

}