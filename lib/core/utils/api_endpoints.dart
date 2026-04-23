class ApiEndpoints {

  ApiEndpoints._();

  //=======================BASE====================================
  //BASE URL
  //static const baseUrl = "https://lms-orpin-five.vercel.app/api/v1";
  //static const baseUrl = "http://10.10.20.19:5000/api/v1";
  static const baseUrl = "http://16.171.204.102:5000/api/v1";
  //static const baseUrl = "http://10.0.2.2:5000/api/v1";
  static const socketBaseUrl = "http://16.171.204.102:5000";
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
  static String getMemberProfile({required String memberId}){
    return "/group/member/$memberId/profile";
  }

  //##############################################################
  //=========================POSTS================================
  static const createCommunityPost = "/community-posts";
  static String deleteCommunityPostImage({required String postId}){
    return "/community-posts/attachments/$postId";
  }
  static String updateCommunityPost({required String postId}){
    return "/community-posts/$postId";
  }
  static String getAllCommunityPosts({required int page, required String searchQuery}){
    return "/community-posts/relevant?limit=10&page=$page&searchTerm=$searchQuery&sortBy=content&sortOrder=desc";
  }
  static String getCommunityPostById({required String postId}){
    return "/community-posts/$postId";
  }
  static String getCommunityPostComments({required String id, required int page}){
    return "/community-comments/$id/all?page=$page&limit=10";
  }
  static String likeUnlikeCommunityPost({required String id}){
    return "/community-likes/$id";
  }
  static const addCommunityComment = "/community-comments";
  static String deleteCommunityComment({required String commentId}){
    return "/community-comments/$commentId";
  }
  static String deleteCommunityPost({required String postId}){
    return "/community-posts/$postId";
  }
  //##############################################################
  //==========================GROUPS==============================
  static String getGroups({bool isActive = false, bool isSuggested = false, bool isArchived = false, required int page}){
    if( isActive ){
      return "/group/all?tab=ACTIVE&page=$page&limit=10&sortOrder=desc&sortBy=stationName";
    }else if( isSuggested ){
      return "/group/all?tab=SUGGESTED&page=$page&limit=10&sortOrder=desc&sortBy=stationName";
    }else{
      return "/group/all?tab=ARCHIVED&page=$page&limit=10&sortOrder=desc&sortBy=stationName";
    }
  }
  static String joinGroup({required String groupId}){
    return "/group/join/$groupId";
  }
  static String leaveGroup({required String groupId}){
    return "/group/leave/$groupId";
  }
  static String getGroupPosts({required String groupId, required int page}){
    return "/group/posts/all?group=$groupId&page=$page&limit=10";
  }
  static String getGroupPostById({required String postId}){
    return "/group/posts/$postId";
  }
  static String getGroupPostComments({required String postId, required int page}){
    return "/group-comments/post/$postId?page=$page&limit=10";
  }
  static String groupPostLikeUnlike({required String postId}){
    return "/group-likes/$postId";
  }
  static const addGroupPostComment = "/group-comments";
  static String deleteGroupPostComment({required String commentId}){
    return "/group-comments/$commentId";
  }
  static const createGroupPost = "/group/posts";
  static String deleteGroupPostImage({required String postId}){
    return "/group/posts/attachments/$postId";
  }
  static String updateGroupPost({required String postId}){
    return "/group/posts/$postId";
  }
  static String deleteGroupPost({required String postId}){
    return "/group/posts/$postId";
  }
  static String getGroupMembers({required String groupId, required int page, required String searchQuery}){
    return "/group/member/$groupId?page=$page&limit=10&searchTerm=$searchQuery";
  }

  //REPORT POST
  static String reportPost(){
    return "/reports";
  }
  //##############################################################
  //=======================MEMBERS================================
  static const sendWave = "/wave";
  static String waveBack({required String userId}){
    return "/wave/accept/$userId";
  }
  //##############################################################
  //======================MESSAGE=================================
  static String allConversations({required int page, required String searchQuery}){
    return "/conversations?page=$page&limit=10&searchterm=$searchQuery";
  }
  static String allMessages({required int page, required String conversationId}){
    return "/conversations/messages?page=$page&limit=10&sortBy=createdAt&sortOrder=desc&conversation=$conversationId";
  }
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
  //FAQ
  static String getFaq({required int page}){
    return "/faq?page=$page&limit=10";
  }

  //=====================NOTIFICATION=============================
  static String getNotifications({required int page}){
    //return "/notification?page=$page&limit=10";
    return "/notifications";
  }
  static String notificationMarkAsRead({required String notificationId}){
    return "/notification/mark-as-read/$notificationId";
  }

  //======================SUBSCRIPTION==========================
  static const getSubscriptionPlan = "/sub-plan";
  static const subscribeToPlan = "/subscription/checkout";
  static const activeSubscription = "/subscription/my-subscription";
  static const subscriptionHistory = "/subscription/histories?page=1&limit=10";

  //=========================ABOUT US===========================
  static const String aboutUs = "/about/retrive";
  //=========================PRIVACY POLICY========================
  static const String privacyPolicy = "/privacy/retrive";
//=========================TERMS AND CONDITIONS====================
  static const String termsAndConditions = "/terms/retrive";
  static const String baseReq = "/base-request";
}
