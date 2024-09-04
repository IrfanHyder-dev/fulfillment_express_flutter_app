import 'package:express/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KTextStyles {
  static const normalText = FontWeight.w400;
  static const mediumText = FontWeight.w500;
  static const semiBoldText = FontWeight.w600;
  static const boldText = FontWeight.w700;

  heading({
    Color textColor = KColors.whiteColor,
    double fontSize = 18,
    FontWeight fontWeight = boldText,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      decoration: decoration,
    );
  }

  subHeading({
    Color textColor = KColors.whiteColor,
    double fontSize = 16,
    FontWeight fontWeight = semiBoldText,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      decoration: decoration,
      fontFamily: 'Roboto',
    );
  }
  medium({
    Color textColor = KColors.whiteColor,
    double fontSize = 14,
    FontWeight fontWeight = normalText,
    TextDecoration decoration = TextDecoration.none,
    double decorationThickness = 2.0,
    Color decorationColor = KColors.blackColor,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationThickness: decorationThickness,
      decorationColor: decorationColor,
      fontFamily: 'Roboto',
    );
  }

  normal({
    Color textColor = KColors.whiteColor,
    double fontSize = 12,
    FontWeight fontWeight = normalText,
    TextDecoration decoration = TextDecoration.none,
    double decorationThickness = 2.0,
    Color decorationColor = KColors.blackColor,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationThickness: decorationThickness,
      decorationColor: decorationColor,
      fontFamily: 'Roboto',
    );
  }

  small({
    Color textColor = KColors.blackColor,
    double fontSize = 10,
    FontWeight fontWeight = normalText,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      decoration: decoration,
      fontFamily: 'Roboto',
    );
  }
}

//   buttonStyle({
//     Color textColor = KColors.kWhite,
//     double fontSize = 16,
//     FontWeight fontWeight = semiBoldText,
//   }) {
//     return TextStyle(
//       color: textColor,
//       fontSize: fontSize,
//       fontWeight: fontWeight,
//     );
//   }
//
//   buttonStyle1({
//     Color textColor = KColors.blackColor,
//     double fontSize = 16,
//     FontWeight fontWeight = semiBoldText,
//   }) {
//     return TextStyle(
//       color: textColor,
//       fontSize: fontSize,
//       fontWeight: fontWeight,
//     );
//   }
// }

// final interRegular = TextStyle(
//   fontFamily: 'Roboto',
//   fontWeight: FontWeight.w400,
//   fontSize: 12.sp,
// );
//
// final interMedium = TextStyle(
//   fontFamily: 'Roboto',
//   fontWeight: FontWeight.w500,
//   fontSize: 12.sp,
// )