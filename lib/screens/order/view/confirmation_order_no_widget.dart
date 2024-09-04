import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_widgtets/custom_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';

Widget confirmOrderNoWidget({orderNo, totalAmount}) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: KColors.whiteColor,
      boxShadow: [
        BoxShadow(
          color: Colors.transparent, // Top shadow (transparent)
        ),
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          // Bottom shadow color
          offset: Offset(0, 2),
          // Offset of the bottom shadow
          blurRadius: 4, // Spread of the bottom shadow
        ),
      ],
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(5),
        bottomRight: Radius.circular(5),
      ),
    ),
    child: Container(
      alignment: Alignment.center,
      width: ScreenUtil().screenWidth,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 11.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: KColors.primaryColor,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                    text: "Order Number:",
                    textStyle: KTextStyles().medium(
                        textColor: KColors.blackColor,
                        fontWeight: KTextStyles.mediumText,
                        fontSize: 20.sp)),
                10.horizontalSpace,
                CustomText(
                    text: orderNo,
                    textStyle: KTextStyles().medium(
                        textColor: KColors.blackColor,
                        fontWeight: KTextStyles.normalText,
                        fontSize: 20.sp)),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.h),
              height: 1,
              width: 110.w,
              color: KColors.greySeparatorColor,
            ),
            CustomText(
                text: "ZAR $totalAmount is Paid",
                textStyle: KTextStyles().medium(
                    textColor: KColors.blackColor,
                    fontWeight: KTextStyles.mediumText,
                    fontSize: 18.sp)),
          ]),
    ),
  );
}
