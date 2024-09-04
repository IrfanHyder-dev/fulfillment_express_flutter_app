import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/common_widgtets/inputfield_widget.dart';
import 'package:express/screens/scanning_view/widgets/button_widget.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<Object?> customDialog(
    {required BuildContext context,
       Function? onCancel,
      bool showCancelButton = true,
      String confirmBtnText = "Confirm",
      required Function? onConfirm,
      double fontSize=14,
    String description="Current Stock Will Be Lost\nIf You Confirm",
    }) {
  return showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 165.h,
          child: SizedBox.expand(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: KColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  23.verticalSpace,
                  CustomText(
                    maxLines: 3,
                    // text: "Current Stock Will Be Lost\nIf You Confirm",
                    text: description,
                    textStyle: KTextStyles().medium(
                      fontSize: fontSize.sp,
                      textColor: KColors.blackColor,
                      fontWeight: KTextStyles.mediumText,
                    ),
                  ),
                  25.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(showCancelButton)
                      ButtonWidget(
                        onTap: () => onCancel!(),
                        text: "Cancel",
                        color: KColors.blackColor,
                        textColor: KColors.whiteColor,
                      ),
                      if(showCancelButton)
                      13.horizontalSpace,
                      ButtonWidget(
                        onTap: () => onConfirm!(),
                        text: confirmBtnText,
                        color: KColors.redColor,
                        textColor: KColors.whiteColor,
                      ),
                    ],
                  ),
                  13.verticalSpace,
                ],
              ),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
Future<Object?> emailDialog(
    {required BuildContext context,
      double fontSize=14,
      required Function? onConfirm,
      required TextEditingController controller,
    String description="Enter your express email account",
    }) {
  return showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 220.h,
          child: SizedBox.expand(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: KColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  23.verticalSpace,
                  CustomText(
                    maxLines: 3,
                    // text: "Current Stock Will Be Lost\nIf You Confirm",
                    text: description,
                    alignText: TextAlign.left,
                    textStyle: KTextStyles().medium(
                      fontSize: 14.sp,
                      textColor: KColors.blackColor,
                      fontWeight: KTextStyles.mediumText,
                    ),
                  ),
                  10.verticalSpace,
                  Material(
                    // color: KColors.primaryColor,
                    child:    SizedBox(
                      width: 250.w,
                      child: InputFieldWidget(
                        prefixImage: "assets/images/sms.svg",
                        isSvg: true,
                        borderColor: KColors.primaryColor,
                        controller: controller,
                        keyboardType: TextInputType.emailAddress,
                        hint: "Enter Email",
                        borderRadius: 3,
                        // onChange: (val) => orderNotifier.enableButton(),

                      ),
                    ),
                  ),
                  10.verticalSpace,
                  ButtonWidget(
                    onTap: () => onConfirm!(),
                    text: "Confirm",
                    color: KColors.redColor,
                    textColor: KColors.whiteColor,
                  ),


                ],
              ),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}