class ApiEndpoints {

  ApiEndpoints._();

  //=======================BASE====================================
  //BASE URL
  //static const baseUrl = "https://lms-orpin-five.vercel.app/api/v1";
  static const baseUrl = "http://10.10.20.42:5000/api/v1";
  //=======================AUTH====================================
  //LOGIN/SIGNIN
  static const login = "/auth/login";
  //SIGNUP
  static const signup = "/auth/sign-up";
  static const getAllBranches = "/branches/all";
  static String getDutyStations({required String search}){
    return "/dutystations/all?searchTerm=$search";
  }
  //SEND FORGOT PASSWORD OTP
  static const otpForgotPassword = "/auth/forgot-password";
  //RESEND OTP
  static const otpResend = "/auth/resend-signup-otp";
  //VERIFY SIGNUP OTP
  static const verifySignupOtp = "/auth/verify-signup-otp";
  //VERIFY FORGOT PASSWORD OTP
  static const otpVerifyForgotPassword = "/auth/verify-otp";
  //RESET PASSWORD - NEW PASSWORD
  static String resetPassword({required String resetToken}){
    return "/auth/reset-password?resetToken=$resetToken";
  }
  //REFRESH TOKEN
  static const refreshToken = "/auth/refresh-token";

  //##############################################################
  //=========================POSTS================================
  static const createPost = "/community-posts";
  static String getAllPosts({required int page}){
    return "/community-posts/relevant?limit=10&page=$page&sortBy=content&sortOrder=desc";
  }
  static String getPostComments({required String id}){
    return "/community-comments/$id/all";
  }
  static String likeUnlikePost({required String id}){
    return "/community-likes/$id";
  }
  static const addComment = "/community-comments";
  //##############################################################
  //==========================GROUPS==============================
  static const getGroups = "/group/all?tab=ACTIVE&page=1&limit=10&sortOrder=desc&sortBy=stationName";
  //##############################################################
  //=======================PROFILE================================
  //GET PROFILE
  static const getProfile = "/auth/me";
  //CHANGE PASSWORD - UPDATE PASSWORD
  static const changePassword = "/auth/changed-password";
  //DELETE ACCOUNT
  static const deleteAccount = "/user/delete-profile";
  //UPDATE PROFILE
  static const updateProfile = "/auth/update-profile";

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
