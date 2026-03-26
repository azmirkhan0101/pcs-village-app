class ApiEndpoints {

  ApiEndpoints._();

  //=======================BASE====================================
  //BASE URL
  static const baseUrl = "https://lms-orpin-five.vercel.app/api/v1";
  //static const baseUrl = "http://10.10.20.34:5001/api/v1";
  //=======================AUTH====================================
  //LOGIN/SIGNIN
  static const login = "/auth/login";
  //SIGNUP
  static const signup = "/auth/register";
  //SEND FORGOT PASSWORD OTP
  static const otpForgotPassword = "/auth/forgotPass";
  //RESEND OTP
  static const otpResend = "/auth/resendOtp";
  //VERIFY SIGNUP OTP
  static const verifySignupOtp = "/auth/regOtpVerify";
  //VERIFY FORGOT PASSWORD OTP
  static const otpVerifyForgotPassword = "/auth/verifyOtp";
  //RESET PASSWORD - NEW PASSWORD
  static const resetPassword = "/auth/resetPass";
  //REFRESH TOKEN
  static const refreshToken = "/auth/refresh-token";

  //##############################################################
  //=====================TEACHER AND ASSISTANT====================
  static String myAssignCourses({required int page}){
    return "/courses/my-courses?page=$page&limit=10";
  }
  static const staffCourseStats = "/courses/teacher-stats";
  static String overallCourseStats({required String courseID}){
    return  "/report/overall-stats/$courseID";
  }
  static String studentReport({required String courseId}){
    return "/report/tabular-report/$courseId";
  }
  static String courseOverviewStats({required String courseId}){
    return "/report/course-overview/$courseId";
  }
  static String studentStatusList({required String courseId}){
    return "/report/student-list/$courseId";
  }
  static String singleStudentProgress({required String courseId, required String studentId}){
    return "/report/view-progress/$courseId/$studentId";
  }
  static String singleStudentAttendance({required String courseId, required String studentId}){
    return "/report/student-attendance/$courseId/$studentId";
  }
  static String singleStudentAllMarks({required String courseId, required String studentId}){
    return "/report/student-marks/$courseId/$studentId";
  }
  static String getClasses({required String courseId, required int page}){
    return "/class/$courseId?page=$page&limit=10";
  }
  static String getHomeworks({required String courseId, required int page}){
    return "/task/$courseId?type=homework&page=$page&limit=10";
  }
  static String getExams({required String courseId, required int page}){
    return "/task/$courseId?type=exam&page=$page&limit=10";
  }
  static String getAnnouncements({required String courseId, required int page}){
    return "/announcements/course/$courseId?page=$page&limit=10";
  }
  static const takeAttendance = "/attendance/mark";
  static String getAttendanceSheet({required String classId}){
    return "/attendance/course-attendance/$classId";
  }
  static String provideMark({required String submissionId}){
    return "/submit/mark/$submissionId";
  }
  static String getTaskAnswer({required String taskId, required bool isExam}){
    if( isExam ){
      return "/submit/task/$taskId?type=exam";
    }else{
      return "/submit/task/$taskId?type=homework";
    }
  }
  //==================ADD CONTENTS===================
  static const uploadClass = "/class/add";
  static const uploadExamHomeWork = "/task/create";
  static const uploadAnnouncement = "/announcements/create";

  //#############################################################
  //=========================STUDENTS============================
  static const comment = "/announcements/comment";
  static const getAllParents = "/user/all?role=parent";
  static const addParent = "/user/assign-parent";
  static String myMarks({required String courseId}){
    return "/report/my-marks-history/$courseId";
  }
  static String myAttendance({required String courseId}){
    return "/report/my-attendance-history/$courseId";
  }
  static const submitAnswer = "/submit/task";

  //#############################################################
  //=========================PARENT==============================
  static String childCourses({required String childId, required int page}){
    return "/report/child-courses/$childId?page=$page&limit=10";
  }
  static String childProgress({required String courseId, required String childId}){
    return "/report/child-progress/$courseId/$childId";
  }
  static String childAllMarks({required String courseId, required String childId}){
    return "/report/student-marks/$courseId/$childId";
  }
  static const myChildren = "/user/my-children";

  //=======================PROFILE================================
  //GET PROFILE
  static const getProfile = "/user/my-profile";
  //CHANGE PASSWORD - UPDATE PASSWORD
  static const changePassword = "/auth/changePassword";
  //DELETE ACCOUNT
  static const deleteAccount = "/user/delete-profile";
  //UPDATE PROFILE
  static const updateProfile = "/user/edit-profile";

  //=====================NOTIFICATION=============================
  static String getNotifications({required int page}){
    return "/notification/my-notifications/?page=$page&limit=10";
  }
  static String notificationMarkAsRead({required String notificationId}){
    return "/notification/mark-as-read/$notificationId";
  }

  //=========================ABOUT US===========================
  static const String aboutUs = "/about/retrive";
  //=========================PRIVACY POLICY========================
  static const String privacyPolicy = "/privacy/retrive";
//=========================TERMS AND CONDITIONS====================
  static const String termsAndConditions = "/terms/retrive";
}
