import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/services/subscription_service.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/show_snackbar.dart';
import '../../../routes/app_pages.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaywallView(
        displayCloseButton: true,
        onDismiss: (){
          Navigator.of(context).pop();
        },
        offering: null, // Loads the default active offering and paywall configured in RC dashboard
        onPurchaseCompleted: (customerInfo, storeTransaction) async {
          await SubscriptionService.to.checkPremiumStatus();
          if (SubscriptionService.to.hasPremium) {
            Get.offAllNamed(AppRoutes.mainNav);
            showSnackBar(title: "Subscribed!", message: "Your subscription has been successfully completed.", backgroundColor: AppColors.greenPrimary);
          }
        },
        onRestoreCompleted: (customerInfo) async {
          await SubscriptionService.to.checkPremiumStatus();
          if (SubscriptionService.to.hasPremium) {
            Get.offAllNamed(AppRoutes.mainNav);
            Get.snackbar("Restored!", "Your purchases have been successfully restored.", backgroundColor: AppColors.greenPrimary, snackPosition: SnackPosition.TOP);
          } else {
            Get.snackbar("Restore Failed", "No active subscription found for this account.",backgroundColor: AppColors.warningYellow, snackPosition: SnackPosition.TOP);
          }
        },
        onPurchaseCancelled: (){
          showSnackBar(title: "Cancelled", message: "Your purchase has been cancelled.", backgroundColor: AppColors.errorRed);
        },
        onRestoreError: (restoreError){
          showSnackBar(title: "Error", message: restoreError.message, backgroundColor: AppColors.errorRed);
        },
        onPurchaseError: (purchaseError){
          showSnackBar(title: "Error", message: purchaseError.message, backgroundColor: AppColors.errorRed);
        },
      ),
    );
  }
}