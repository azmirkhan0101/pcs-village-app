

//GET STORAGE KEYS
const String isSignupKey = "isSignupKey";
const String isLoginKey = "isLoginKey";
const String emailKey = "emailKey";
const String accessTokenKey = "accessTokenKey";
const String refreshTokenKey = "refreshTokenKey";
const String requireVerificationKey = "requireVerificationKey";
const String forgotPasswordTokenKey = "forgotPasswordTokenKey";
const String profileModelKey = "profileModelKey";
const String userNameKey = "userNameKey";
const String userContactKey = "userContactKey";

//AUTH STATUS
enum AuthStatus {
  loggedInAndVerified,
  loggedInNotVerified,
  loggedOut
}