import 'package:flutter/material.dart';

import '../assets_gen/fonts.gen.dart';
import '../utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final FontStyle fontStyle;
  final Color fontColor;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign textAlignment;
  final String? fontFamily;
  final bool underline;
  final Color? underlineColor;
  final double underlineWidth;
  final double figmaLetterSpacing;

  const CustomText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 16,
    this.fontStyle = FontStyle.normal,
    this.fontColor = AppColors.primaryColor,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.textAlignment = TextAlign.center,
    this.fontFamily = FontFamily.inter,
    this.underline = false,
    this.underlineColor,
    this.underlineWidth = 1.0,
    this.figmaLetterSpacing = 0,
  });

  CustomText copyWith({
    FontWeight? fontWeight,
    double? fontSize,
    FontStyle? fontStyle,
    Color? fontColor,
    TextOverflow? overflow,
    int? maxLines,
    TextAlign? textAlignment,
    String? fontFamily,
    bool? underline,
    Color? underlineColor,
    double? underlineWidth,
    double? figmaLetterSpacing,
  }) {
    return CustomText(
      text: text,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      fontColor: fontColor ?? this.fontColor,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textAlignment: textAlignment ?? this.textAlignment,
      fontFamily: fontFamily ?? this.fontFamily,
      underline: underline ?? this.underline,
      underlineColor: underlineColor ?? this.underlineColor,
      underlineWidth: underlineWidth ?? this.underlineWidth,
      figmaLetterSpacing: figmaLetterSpacing ?? this.figmaLetterSpacing
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlignment,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontStyle: fontStyle,
        color: fontColor,
        fontFamily: fontFamily,
        decoration:
        underline ? TextDecoration.underline : TextDecoration.none,
        decorationColor: underline ? underlineColor : null,
        decorationThickness: underline ? underlineWidth : null
      )
    );
  }
}

extension CustomTextSizeExt on CustomText {
  CustomText get s12 => copyWith(fontSize: 12);
  CustomText get s14 => copyWith(fontSize: 14);
  CustomText get s16 => copyWith(fontSize: 16);
  CustomText get s18 => copyWith(fontSize: 18);
  CustomText get s20 => copyWith(fontSize: 20);
  CustomText get s24 => copyWith(fontSize: 24);
  CustomText get s28 => copyWith(fontSize: 28);
}

extension CustomTextWeightExt on CustomText {
  CustomText get bold => copyWith(fontWeight: FontWeight.bold);
  CustomText get w400 => copyWith(fontWeight: FontWeight.w400);
  CustomText get w500 => copyWith(fontWeight: FontWeight.w500);
  CustomText get w600 => copyWith(fontWeight: FontWeight.w600);
  CustomText get w700 => copyWith(fontWeight: FontWeight.w700);
  CustomText get w800 => copyWith(fontWeight: FontWeight.w800);
  CustomText get w900 => copyWith(fontWeight: FontWeight.w900);
}