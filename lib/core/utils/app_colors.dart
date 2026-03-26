import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors {

  static const Color white = Color(0xFFFFFFFF);
  static const Color white30Percent = Color(0x50FFFFFF);
  static const Color grey4E = Color(0xFF4E4E4E);
  static const Color grey78 = Color(0xFF787878);
  static const Color grey92 = Color(0xFF929292);
  static const Color greyB2 = Color(0xFFB2B2B2);
  static const Color greyEB = Color(0xFFEBEBEB);
  static const Color greyF9 = Color(0xFFF9FAFB);
  static const Color black = Color(0xFF000000);
  static const Color black40Percent = Color(0x70000000);
  static const Color secondaryGreen = Color(0xFF64937D);
  static const Color greenPrimary = Color(0xFF00B047);

  static const Color primaryColor = Color(0xFF1F3A5F);
  static const Color subtitleTextColor = Color(0xFF6B7280);

  static const Color red10Percent = Color(0x1AF70004);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color errorRed2 = Color(0xFFF70004);
  static const Color yellowWarning = Color(0xFFFFC804);
  static const Color warningYellow = Color(0xFFF57C00);
  static const Color warningYellow3 = Color(0xFFF9A825);
  static const Color warningYellow2 = Color(0xffffcc00);

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E3A5F),
      Color(0xFF556B2F)
    ],
  );
}