import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../utils/rc_constants.dart';

class SubscriptionService extends GetxService {
  static SubscriptionService get to => Get.find<SubscriptionService>();
  final storage = GetStorage();

  RxBool isRevenueCatPremium = false.obs;
  RxBool isBackendPremium = false.obs;

  // SYSTEM 1 + SYSTEM 2: Combines Backend Free Premium + RevenueCat Paid Premium
  bool get hasPremium => isBackendPremium.value || isRevenueCatPremium.value;

  Future<SubscriptionService> init() async {
    await Purchases.setLogLevel(LogLevel.info);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(RevenueCatConstants.androidApiKey);
    } else {
      configuration = PurchasesConfiguration(RevenueCatConstants.iosApiKey);
    }

    // Only configure the app here. We identify the user LATER during your custom login.
    await Purchases.configure(configuration);

    // Listen to entitlement changes (e.g., from external purchases or background renewals)
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _updateRevenueCatStatus(customerInfo);
    });

    return this;
  }

  // Checks if the 6-month free premium granted by the backend is still active
  // void checkBackendPremium() {
  //   String? expiry = storage.read(subscriptionExpiryDateKey);
  //   bool isSubscribed = storage.read(subscriptionKey) ?? false;
  //
  //   if (expiry != null && expiry.isNotEmpty) {
  //     try {
  //       DateTime expiryDate = DateTime.parse(expiry);
  //       DateTime nowUtc = DateTime.now().toUtc();
  //       isBackendPremium.value = nowUtc.isBefore(expiryDate);
  //     } catch (e) {
  //       isBackendPremium.value = isSubscribed;
  //     }
  //   } else {
  //     isBackendPremium.value = isSubscribed;
  //   }
  // }

  // Identifies the user in RevenueCat using your backend User ID
  Future<void> loginUser(String businessId) async {
    try {
      LogInResult result = await Purchases.logIn(businessId);
      _updateRevenueCatStatus(result.customerInfo);
      // Print this to see if RevenueCat knows they paid:
      bool hasPremium = result.customerInfo.entitlements.all[RevenueCatConstants.entitlementID]?.isActive ?? false;
      print("RC Login Success! Has Paid Premium: $hasPremium");
      } catch (e) {
      print("RevenueCat Login Error: $e");
    }
  }

  // Clears the RevenueCat user on backend logout
  Future<void> logoutUser() async {
    try {
      await Purchases.logOut();
      isRevenueCatPremium.value = false;
      print("RC Logout done");
    } catch (e) {
      print("RevenueCat Logout Error: $e");
    }
  }

  // Validates the combined premium status on app restart or screen load
  Future<void> checkPremiumStatus() async {
    //checkBackendPremium();

    // Check RevenueCat even if backend is active, to keep local cache updated
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _updateRevenueCatStatus(customerInfo);
    } catch (e) {
      print("Error fetching RC customer info: $e");
    }
  }

  void _updateRevenueCatStatus(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.all[RevenueCatConstants.entitlementID] != null &&
        customerInfo.entitlements.all[RevenueCatConstants.entitlementID]!.isActive) {
      isRevenueCatPremium.value = true;
    } else {
      isRevenueCatPremium.value = false;
    }
  }

  Future<void> restorePurchase(BuildContext context) async {
    // 1. Show a "loading" SnackBar or loading indicator if you prefer.
    // For simplicity, we will just show the result after the async operation completes.

    try {
      // Attempt to restore purchases
      CustomerInfo customerInfo = await Purchases.restorePurchases();

      // 2. Check if the user actually has any active entitlements now
      if (customerInfo.entitlements.active.isNotEmpty) {
        // Success: Purchases restored and they have active premium features
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchases successfully restored!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Partial Success: The sync worked, but they don't actually own any premium items
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Restoration complete, but no active purchases were found.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      // 3. Handle errors (e.g., network issues, user canceled, invalid store configuration)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore purchases: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}