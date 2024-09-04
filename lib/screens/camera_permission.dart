import 'dart:io';

import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/common_widgtets/status_bar_widget.dart';
import 'package:express/screens/checkout/view/check_out_widget.dart';
import 'package:express/screens/checkout/view/custom_upload_btn_widget.dart';
import 'package:express/screens/scanning_view/view/scanning_view.dart';
import 'package:express/screens/scanning_view/widgets/custom_dialog.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckCameraPermission extends ConsumerWidget {
  CheckCameraPermission({super.key});

  final permissionCheck = Provider((ref) async {
    var status = await Permission.camera.status;
    if(status.isPermanentlyDenied)
      {
        customDialog(
          description: "Please go to settings to allow camera permission",
          context: Get.context!,
          onCancel: () {
           Platform.isAndroid? SystemNavigator.pop():exit(0);
          },
          onConfirm: () {
            print("confirm");

            openAppSettings().then((value) async {
              var status = await Permission.camera.status;
              if (!status.isGranted) {
                print("__________permission denied_____________");
                Platform.isAndroid? SystemNavigator.pop():exit(0);
              }
              else {
                print("__________________else inner____________________");
                Get.offAll(() => BarcodeScanner());
              }
            });
            Get.back();
          },
        );
        print("hello");
      }
    else
      {
        var result = await Permission.camera.request();
        print("_______________result $result _____________________");
        if (!result.isGranted) {
          print("__________permission denied_____________");
          SystemNavigator.pop();
        }
        else {
          print("__________________else inner____________________");
          Get.offAll(() => BarcodeScanner());
        }
      }

  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StatusBarWidget(
      child: Scaffold(
        body: Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: hMargin,
            vertical: vMargin,
          ),
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/camera.svg'),
              141.verticalSpace,
              CustomText(
                text: 'Enable Camera',
                textStyle: KTextStyles().heading(
                  fontSize: 22.h,
                  textColor: KColors.blackColor,
                ),
              ),
              customDivider(width: 110.w),
              CustomText(
                alignText: TextAlign.center,
                maxLines: 3,
                text:
                    'To use this camera scanner,\nPlease allow us the camera permission by pressing\nthe below button',
                textStyle: KTextStyles().heading(
                  fontSize: 18.h,
                  textColor: KColors.blackColor,
                  fontWeight: KTextStyles.normalText,
                ),
              ),
              30.verticalSpace,
              customUploadBtnWidget(
                onTap: () => ref.read(permissionCheck),
                buttonColor: KColors.primaryColor,
                width: Get.width,
                text: "Allow",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
