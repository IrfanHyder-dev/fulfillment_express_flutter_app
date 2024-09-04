import 'dart:io';

import 'package:express/common_services/ui_services.dart';
import 'package:express/common_widgtets/status_bar_widget.dart';
import 'package:express/screens/checkout/view/custom_upload_btn_widget.dart';
import 'package:express/screens/scanning_view/widgets/custom_dialog.dart';
import 'package:express/screens/signin_with_passcode/view/signin_passcode_view.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/global_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../notifier/login_with_notifier.dart';

class LoginWithView extends ConsumerStatefulWidget {
  LoginWithView({
    super.key,
  });

  @override
  ConsumerState<LoginWithView> createState() => _LoginWithViewState();
}

class _LoginWithViewState extends ConsumerState<LoginWithView> {
  final loginProvider = ChangeNotifierProvider<LoginWithNotifier>((ref) {
    return LoginWithNotifier();
  });

  @override
  Widget build(BuildContext context) {
    final loginNotifier = ref.watch(loginProvider);
    return StatusBarWidget(
      child: Scaffold(
        backgroundColor: KColors.whiteColor,
        body: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric(
            horizontal: hMargin,
            vertical: vMargin,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (Platform.isIOS)
                  SignInWithAppleButton(
                      style: SignInWithAppleButtonStyle.black,
                      height: 45,
                      borderRadius: BorderRadius.circular(5),
                      onPressed: () async => loginNotifier.signInWithApple()),
                20.verticalSpace,
                customUploadBtnWidget(
                    isLoading: loginNotifier.loading,
                    loaderColor: KColors.whiteColor,
                    onTap: () async => await loginNotifier.signInWithGoogle(),
                    gIcon: "assets/images/google_icon.svg",
                    text: "Sign in with Google",
                    width: Get.width,
                    height: 45,
                    isFromShopping: true),
                20.verticalSpace,
                customUploadBtnWidget(
                    onTap: () => Get.to(() => SignInPasscodeView()),
                    text: "Sign in with Passcode",
                    width: Get.width,
                    height: 45),
                20.verticalSpace,
                customUploadBtnWidget(
                    onTap: () => Get.back(),
                    text: "Shopping as Guest",
                    width: Get.width,
                    height: 45),
              ]),
        ),
      ),
    );
  }
}
