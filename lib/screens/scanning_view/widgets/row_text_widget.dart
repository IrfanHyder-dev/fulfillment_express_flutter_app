import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowTextWidget extends StatelessWidget {
  const RowTextWidget({
    required this.title,
    required this.subtitle,
    required this.textColor,
    super.key,
    this.textStyle,
  });

  final String title;
  final TextStyle? textStyle;
  final String subtitle;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          textStyle: textStyle ??
              KTextStyles().medium(
                fontSize: 14.sp,
                textColor: textColor,
              ),
        ),
        CustomText(
            text: subtitle,
            textStyle: textStyle ??
                KTextStyles().medium(
                  fontSize: 14.sp,
                  textColor: textColor,
                )),
      ],
    );
  }
}
