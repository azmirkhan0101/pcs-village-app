import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utils/extensions.dart';

class PinFieldWidget extends StatelessWidget {

  final TextEditingController controller;
  final int length;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;

  const PinFieldWidget({
    super.key,
    required this.controller,
    required this.length,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return PinCodeTextField(
      textStyle: TextStyle(fontSize: isTab ? 12.sp : null),
      appContext: context,
      controller: controller,
      length: length,
      obscureText: false,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 100),
      enableActiveFill: true,
      autoDisposeControllers: false,
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      // ✅ pin theme
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: isTab ? 70 : 45,
        fieldWidth: isTab ? 70 : 45,

        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        activeColor: const Color(0xFFE4E4E4),
        inactiveColor: const Color(0xFFE4E4E4),
        selectedColor: const Color(0xFFE4E4E4),

        // // 🔥 gap between fields
        // fieldOuterPadding: EdgeInsets.symmetric(horizontal: 8.w),
      ),

      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}
