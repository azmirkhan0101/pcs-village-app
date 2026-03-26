import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pcs_village/core/widgets/custom_text.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData? prefixIcon;
  final double prefixIconSize;
  final Color prefixIconColor;
  final IconData? icon;
  final double? iconHeight;
  final double? iconWidth;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onPressed;
  final double buttonHeight;
  final double? buttonWidth;
  final EdgeInsetsGeometry? padding;
  final double buttonRadius;
  final Color backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? iconSize;
  final double borderWidth;
  final Gradient? gradient;

  //state control
  final bool isEnabled;
  final Color disabledColor;

  //LOADING CONTROLLER
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    this.icon,
    this.prefixIcon,
    this.prefixIconSize = 20,
    this.prefixIconColor = AppColors.white,
    this.iconHeight,
    this.iconWidth,
    this.textColor = AppColors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.onPressed,
    this.buttonHeight = 50,
    this.buttonWidth,
    this.padding,
    this.buttonRadius = 16,
    this.backgroundColor = AppColors.primaryColor,
    this.borderColor = AppColors.primaryColor,
    this.iconColor,
    this.iconSize,
    this.borderWidth = 0,
    this.gradient,
    this.isEnabled = true, // Defaulting to true
    this.disabledColor = Colors.grey, // Default disabled color
    this.isLoading = false, // Defaulting to false
  });

  @override
  Widget build(BuildContext context) {
    // Logic to determine the background color based on state
    final Color effectiveBackgroundColor = isEnabled
        ? backgroundColor
        : disabledColor;

    return Container(
      height: buttonHeight.h,
      width: buttonWidth?.w,
      decoration: BoxDecoration(
        // We only show the gradient if enabled and provided
        gradient: isEnabled ? gradient : null,
        color: (isEnabled && gradient != null)
            ? null
            : effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(buttonRadius.r),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth.r)
            : null,
      ),
      child: ElevatedButton(
        // Passing null to onPressed disables the button
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          // Defines the look when isEnabled is false
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: textColor.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius.r),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 25.h,
                  width: 25.h,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                    padding: EdgeInsets.zero,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null)
                    Icon(
                      prefixIcon,
                      color: isEnabled
                          ? prefixIconColor
                          : prefixIconColor.withValues(alpha: 0.5),
                      size: prefixIconSize.r,
                    ),
                  if (prefixIcon != null) SizedBox(width: 12.w),
                  CustomText(
                    text: label,
                    fontColor: isEnabled
                        ? textColor
                        : textColor.withValues(alpha: 0.6),
                    fontSize: fontSize.sp,
                    fontWeight: fontWeight,
                  ),
                  if (icon != null) const SizedBox(width: 12),
                  if (icon != null)
                    Icon(
                      icon,
                      color: isEnabled
                          ? (iconColor ?? textColor)
                          : (iconColor ?? textColor).withOpacity(0.5),
                      size: iconSize ?? fontSize,
                    ),
                ],
              ),
      ),
    );
  }
}
