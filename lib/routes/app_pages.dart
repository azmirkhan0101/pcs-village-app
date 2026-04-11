import 'package:get/get.dart';
import 'package:pcs_village/modules/auth/bindings/duty_stations_binding.dart';
import 'package:pcs_village/modules/auth/bindings/forgot_password_binding.dart';
import 'package:pcs_village/modules/auth/bindings/login_binding.dart';
import 'package:pcs_village/modules/auth/bindings/otp_binding.dart';
import 'package:pcs_village/modules/auth/bindings/reset_password_binding.dart';
import 'package:pcs_village/modules/auth/bindings/signup_binding.dart';
import 'package:pcs_village/modules/auth/screens/login_screen.dart';
import 'package:pcs_village/modules/auth/screens/signup_five_screen.dart';
import 'package:pcs_village/modules/auth/screens/signup_four_screen.dart';
import 'package:pcs_village/modules/auth/screens/signup_one_screen.dart';
import 'package:pcs_village/modules/auth/screens/signup_screen.dart';
import 'package:pcs_village/modules/auth/screens/signup_three_screen.dart';
import 'package:pcs_village/modules/auth/screens/signup_two_screen.dart';
import 'package:pcs_village/modules/groups/bindings/group_details_binding.dart';
import 'package:pcs_village/modules/groups/screens/group_details_screen.dart';
import 'package:pcs_village/modules/post/screens/create_post_screen.dart';
import 'package:pcs_village/modules/post/screens/post_details_screen.dart';
import 'package:pcs_village/modules/main_nav/bindings/main_nav_binding.dart';
import 'package:pcs_village/modules/main_nav/screens/main_nav_screen.dart';
import 'package:pcs_village/modules/message/screens/message_details.dart';
import 'package:pcs_village/modules/onboarding/screens/auth_selection_screen.dart';
import 'package:pcs_village/modules/onboarding/screens/splash_screen.dart';
import 'package:pcs_village/modules/profile/bindings/settings_binding.dart';
import 'package:pcs_village/modules/profile/screens/change_password_screen.dart';
import 'package:pcs_village/modules/profile/screens/community_guidelines.dart';
import 'package:pcs_village/modules/subscription/screens/complete_purchase_screen.dart';
import 'package:pcs_village/modules/profile/screens/edit_profile_screen.dart';
import 'package:pcs_village/modules/subscription/screens/manage_subscription_screen.dart';
import 'package:pcs_village/modules/profile/screens/settings_screen.dart';
import 'package:pcs_village/modules/subscription/screens/upgrade_premium_screen.dart';
import 'package:pcs_village/modules/auth/screens/forgot_password_screen.dart';
import 'package:pcs_village/modules/auth/screens/otp_verify_screen.dart';

import '../modules/auth/screens/reset_password_screen.dart';
import '../modules/post/bindings/create_post_binding.dart';
import '../modules/post/bindings/post_details_binding.dart';
import '../modules/profile/screens/invite_friends.dart';

part 'app_routes.dart';

class AppPages {

  static List<GetPage> pages = [
    GetPage(
        name: AppRoutes.authSelection,
        page: (){
          return const AuthSelectionScreen();
        }
    ),
    GetPage(
        name: AppRoutes.splashScreen,
        page: (){
          return SplashScreen();
        }
    ),
    GetPage(
        name: AppRoutes.loginScreen,
        page: (){
          return LoginScreen();
        },
      binding: LoginBinding()
    ),
    GetPage(
        name: AppRoutes.signupScreen,
        page: (){
          return SignupScreen();
        },
      binding: SignupBinding()
    ),
    GetPage(
        name: AppRoutes.signupStepOneScreen,
        page: (){
          return SignupOneScreen();
        }
    ),
    GetPage(
        name: AppRoutes.signupStepTwoScreen,
        page: (){
          return SignupTwoScreen();
        }
    ),
    GetPage(
        name: AppRoutes.signupStepThreeScreen,
        page: (){
          return SingupThreeScreen();
        }
    ),
    GetPage(
        name: AppRoutes.signupStepFourScreen,
        page: (){
          return SignupFourScreen();
        },
      binding: DutyStationsBinding()
    ),
    GetPage(
        name: AppRoutes.signupStepFiveScreen,
        page: (){
          return SignupFiveScreen();
        }
    ),
    GetPage(
        name: AppRoutes.forgotPasswordScreen,
        page: (){
          return ForgotPasswordScreen();
        },
      binding: ForgotPasswordBinding()
    ),
    GetPage(
        name: AppRoutes.otpVerificationScreen,
        page: (){
          return OtpVerifyScreen();
        },
      binding: OtpBinding()
    ),
    GetPage(
        name: AppRoutes.resetPasswordScreen,
        page: (){
          return ResetPasswordScreen();
        },
      binding: ResetPasswordBinding()
    ),
    //##################################
    GetPage(
        name: AppRoutes.mainNav,
        page: (){
          return MainNavScreen();
        },
      binding: MainNavBinding()
    ),
    GetPage(
        name: AppRoutes.postDetails,
        page: (){
          return PostDetailsScreen();
        },
      binding: PostDetailsBinding()
    ),
    GetPage(
        name: AppRoutes.createPost,
        page: (){
          return CreatePostScreen();
        },
      binding: CreatePostBinding()
    ),
    GetPage(
        name: AppRoutes.messageDetails,
        page: (){
          return ChatScreen();
        }
    ),
    GetPage(
        name: AppRoutes.groupDetails,
        page: (){
          return GroupDetailsScreen();
        },
      binding: GroupDetailsBinding()
    ),
    GetPage(
        name: AppRoutes.editProfile,
        page: (){
          return EditProfileScreen();
        }
    ),
    GetPage(
        name: AppRoutes.settingsScreen,
        page: (){
          return SettingsScreen();
        },
      binding: SettingsBinding()
    ),
    GetPage(
        name: AppRoutes.changePassword,
        page: (){
          return ChangePasswordScreen();
        }
    ),
    GetPage(
        name: AppRoutes.inviteFriends,
        page: (){
          return InviteFriendsScreen();
        }
    ),
    GetPage(
        name: AppRoutes.upgradePremium,
        page: (){
          return UpgradePremiumScreen();
        }
    ),
    GetPage(
        name: AppRoutes.completePurchase,
        page: (){
          return CompletePurchaseScreen();
        }
    ),
    GetPage(
        name: AppRoutes.manageSubscription,
        page: (){
          return ManageSubscriptionScreen();
        }
    ),
    GetPage(
        name: AppRoutes.communityGuidelines,
        page: (){
          return CommunityGuidelinesScreen();
        }
    ),
  ];

}