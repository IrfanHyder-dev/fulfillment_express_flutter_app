import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPopUp extends StatelessWidget {
  const CustomPopUp({
    required this.text,
    required this.success,
    required this.padding,
    required this.horizontalPadding,
    super.key,
  });

  final String text;
  final bool success;
  final double padding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 0.7),
      child: new Dialog(
        insetPadding: EdgeInsets.only(
            left: horizontalPadding.w,
            right: horizontalPadding.w,
            top: padding),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
              color: success ? KColors.primaryColor : KColors.redColor,
              borderRadius: BorderRadius.circular(5)),
          height: 60.h,
          child: Center(
              child: CustomText(
            text: text,
            textStyle: KTextStyles().medium(
              textColor: success ? KColors.blackColor : KColors.whiteColor,
            ),
          )),
        ),
      ),
    );
  }
}
