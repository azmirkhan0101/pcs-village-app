

//GET STORAGE KEYS
const String isSignupKey = "isSignupKey";
const String isLoginKey = "isLoginKey";
const String emailKey = "emailKey";
const String accessTokenKey = "accessTokenKey";
const String refreshTokenKey = "refreshTokenKey";
const String resetTokenKey = "resetTokenKey";
const String forgotPasswordTokenKey = "forgotPasswordTokenKey";
const String profileModelKey = "profileModelKey";
const String userNameKey = "userNameKey";

//AUTH STATUS
enum AuthStatus {
  loggedInAndVerified,
  loggedOut
}

enum Affiliation {
  activeDutySpouse,
  activeDuty,
  veteran,
  militaryFamily
}

extension AffiliationExtension on Affiliation {
  String get displayName {
    switch (this) {
      case Affiliation.activeDutySpouse: return "Active Duty Spouse";
      case Affiliation.activeDuty:       return "Active Duty";
      case Affiliation.veteran:          return "Veteran";
      case Affiliation.militaryFamily:   return "Military Family";
    }
  }

  String get value {
    switch (this) {
      case Affiliation.activeDutySpouse: return "ACTIVE_DUTY_SPOUSE";
      case Affiliation.activeDuty:       return "ACTIVE_DUTY";
      case Affiliation.veteran:          return "VETERAN";
      case Affiliation.militaryFamily:   return "MILITARY_FAMILY";
    }
  }

  static String fromString(String value) {
    try {
      return Affiliation.values
          .firstWhere((e) => e.value == value)
          .displayName;
    } catch (e) {
      return value;
    }
  }
}

enum KidsAgeRange {
  infant,
  toddler,
  preSchool,
  schoolAge,
  teenager
}

extension KidsAgeRangeExtension on KidsAgeRange {

  String get value {
    switch (this) {
      case KidsAgeRange.infant:
        return 'INFANT';
      case KidsAgeRange.toddler:
        return 'TODDLER';
      case KidsAgeRange.preSchool:
        return 'PRE_SCHOOL';
      case KidsAgeRange.schoolAge:
        return 'SCHOOL_AGE';
      case KidsAgeRange.teenager:
        return 'TEENAGER';
    }
  }

  String get displayName {
    switch (this) {
      case KidsAgeRange.infant:
        return 'Infant';
      case KidsAgeRange.toddler:
        return 'Toddler';
      case KidsAgeRange.preSchool:
        return 'Pre-School';
      case KidsAgeRange.schoolAge:
        return 'School Age';
      case KidsAgeRange.teenager:
        return 'Teenager';
    }
  }
}
