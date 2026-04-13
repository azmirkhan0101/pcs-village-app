//SHOW SNACKBAR
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'app_colors.dart';

void showSnackBar({required String title, required String message, required Color backgroundColor, Color textColor = Colors.white}) {
  Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor
  );
}

void showApiSnackBar({
  required int? statusCode,
  dynamic data,
}) {
  String title;
  Color backgroundColor;

  String message = data?['message']?.toString().trim().isNotEmpty == true
      ? data['message']
      : "Something went wrong. Please try again.";

  if (statusCode == null) {
    title = "Error";
    backgroundColor = Colors.grey;
  } else if (statusCode >= 200 && statusCode < 300) {
    title = "Success";
    backgroundColor = Colors.green;
  } else if (statusCode >= 400 && statusCode < 500) {
    title = "Attention";
    backgroundColor = Colors.orange;
  } else if (statusCode >= 500) {
    title = "Failed";
    backgroundColor = Colors.red;
  } else {
    title = "Error";
    backgroundColor = Colors.grey;
  }

  Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white
  );
}

void noInternetSnackBar() {
  Get.snackbar(
      "No internet!",
      "Please check your internet connection and try again",
      backgroundColor: AppColors.warningYellow,
      colorText: AppColors.white
  );
}


void errorSnackBar() {
  Get.snackbar(
      "Error occurred!",
      "Something went wrong. Please try again.",
      backgroundColor: AppColors.errorRed,
      colorText: AppColors.white
  );
}

void timeOutSnackBar() {
  Get.snackbar(
      "Time out!",
      "Please check your internet connection or try again later.",
      backgroundColor: AppColors.errorRed,
      colorText: AppColors.white
  );
}

void incorrectCredentialsSnackBar() {
  Get.snackbar(
      "Incorrect Credentials!",
      "Please enter email and password correctly.",
      backgroundColor: AppColors.errorRed,
      colorText: AppColors.white
  );
}