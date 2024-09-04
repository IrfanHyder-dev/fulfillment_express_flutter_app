import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.text,
    required this.color,
    required this.textColor,
    this.onTap,
    super.key,
  });

  final String text;
  final Color color;
  final Color textColor;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        height: 40.h,
        width: 125.w,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: KColors.whiteColor,
            )),
        child: Center(
          child: CustomText(
            text: text,
            textStyle: KTextStyles().subHeading(
              fontWeight: KTextStyles.mediumText,
              textColor: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
