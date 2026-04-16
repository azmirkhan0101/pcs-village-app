import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pcs_village/core/utils/app_colors.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/app_constants.dart';
import '../../../routes/app_pages.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});


  final storage = GetStorage();

  Future<AuthStatus> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    //return AuthStatus.loggedOut;

    // Read the token and verification status
    final String? token = storage.read( accessTokenKey );

    // If token is null or empty, the user is logged out (or never logged in)
    if ( token == null || token.isEmpty ) {//NO TOKEN -> LOGGED OUT
      return AuthStatus.loggedOut;
    }else{//TOKEN FOUND -> LOGGED IN
      return AuthStatus.loggedInAndVerified;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder<AuthStatus>(
          future: checkAuthStatus(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return splashWidget();
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              final AuthStatus status = snapshot.data!;
              if (status == AuthStatus.loggedInAndVerified) {
                Get.offNamed(AppRoutes.mainNav);
              } else {
                Get.offNamed(AppRoutes.authSelection);
              }
            });

            return const SizedBox.shrink();
          }
      ),
    );
  }


  //SPLASH WIDGET
  Widget splashWidget() {
    return Container(
      // 1. Background Gradient
      decoration: const BoxDecoration(
          gradient: AppColors.splashGradient
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2. White Circular Logo Container
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                // Replace with your actual image asset
                child: Image.asset(
                    Assets.images.appLogo.keyName
                ),
              ),
            ),
            const SizedBox(height: 30),
            // 3. Three Loading Dots
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DotWidget(),
                SizedBox(width: 8),
                DotWidget(),
                SizedBox(width: 8),
                DotWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class DotWidget extends StatelessWidget {
  const DotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}