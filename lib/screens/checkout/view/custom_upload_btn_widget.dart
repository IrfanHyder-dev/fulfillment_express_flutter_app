import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common_widgtets/custom_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';

Widget customUploadBtnWidget(
    {icon,
    text,
    width,
    onTap,
    isFromShopping = false,
    bool isLoading = false,
    bool isEnable = true,
    double stroke = 2,
    Color textColor = KColors.blackColor,
    Color loaderColor = KColors.primaryColor,
    Color buttonColor = KColors.primaryColor,
    double height = 49,
    gIcon}) {
  return GestureDetector(
    onTap: isEnable && !isLoading ? onTap : null,
    child: Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: ShapeDecoration(
        color:
            // isFromShopping
            //     ? KColors.whiteColor
            //     :
            isEnable ? buttonColor : KColors.greySeparatorColor,
        shape: isFromShopping
            ? RoundedRectangleBorder(
                side: BorderSide(width: 1, color: KColors.primaryColor),
                borderRadius: BorderRadius.circular(3),
              )
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: isLoading
          ? Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: loaderColor,
                  strokeWidth: stroke,
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                gIcon != null
                    ? SvgPicture.asset(
                        gIcon,
                      )
                    : SizedBox(),
                gIcon != null ? 10.horizontalSpace : SizedBox(),
                CustomText(
                    text: text,
                    textStyle: KTextStyles().medium(
                        textColor: gIcon == null
                            ? isFromShopping
                                ? KColors.primaryColor
                                : isEnable
                                    ? textColor
                                    : textColor.withOpacity(0.4)
                            : KColors.blackColor,
                        fontWeight: KTextStyles.mediumText,
                        fontSize: 16)),
                icon != null ? 10.horizontalSpace : SizedBox(),
                icon != null
                    ? SvgPicture.asset(
                        icon,
                      )
                    : SizedBox(),
              ],
            ),
    ),
  );
}
