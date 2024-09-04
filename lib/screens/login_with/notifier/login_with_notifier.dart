import 'dart:convert';
import 'package:express/common_models/api_response.dart';
import 'package:express/common_services/shared_preference.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/screens/login_with/services/login_with_services.dart';
import 'package:express/screens/scanning_view/widgets/custom_dialog.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/static_info.dart';
import 'package:express/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../model/user_data_model.dart';

class LoginWithNotifier extends ChangeNotifier {
  String errorMsg = "";
  bool loading = false;
  TextEditingController emailController = TextEditingController();

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> signInWithApple() async {
   // setLoading(true);
    final user = LoginServices.appleSignIn().then((value) async {
      print("User signed in successfully");
      print("User is authorized");
      print("User ID: ${value?.userIdentifier}");
      print("Email: ${value?.email}");
      print("Full Name: ${value?.givenName} ${value?.familyName}");
      if(value?.email ==null|| value!.email!.isEmpty)
        {
          emailDialog(
              controller: emailController,
              context: Get.context!,onConfirm: () async {
            print(emailController.text);
            if (emailController.text.isEmpty ||
                !GetUtils.isEmail(emailController.text)) {
              emailController.clear();
              UiServices().customPopUp(
                  key: "Please enter valid email", success: false, padding: 0);
            }
            else
            {
              await loginUser(email: emailController.text, photo: "", loginWith: "apple");
              print("${emailController.text}is validated");
              emailController.clear();
              Get.back();
            }
          } );
        }
      else
        {
          StaticInfo.appleCredentials = value;
          await loginUser(email: value.email.toString(), photo: "", loginWith: "apple");
        }

    }).catchError((e) {
      print("User signed in failed");
    });
  }

  Future<void> signInWithGoogle() async {
    setLoading(true);
    backgroundApp = true;
    final user = await LoginServices.login();
    if (user == null) {
      UiServices()
          .customPopUp(key: "Login failed", success: false, padding: 400.h);

      setLoading(false);
    } else {
      StaticInfo.isGoogleSignIn = true;
      await loginUser(email: user.email, photo: user.photoUrl.toString(), loginWith: "google");
    }
  }

  Future<void> loginUser({required String email, required String photo, required String loginWith}) async {
    setLoading(true);
    ApiResponseModel? apiResponseModel =
        await LoginServices().loginAtServer(email: email, photo: photo, loginPlatform: loginWith);
    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {
        StaticInfo.userModel = UserDataModel.fromJson(apiResponseModel.data);
        SharedPreferencesService().setIsLogin(true);
        var data = jsonEncode(apiResponseModel.data);
        SharedPreferencesService().saveUser(data);
        StaticInfo.isGuest = false;
        Navigator.pop(Get.context!);
      } else {
        print("error");
        UiServices().customPopUp(
            key: apiResponseModel.errorModel!.errors!.first,
            success: false,
            padding: 400.h);
        errorMsg = apiResponseModel.errorModel!.errors!.first;
      }
      setLoading(false);
    } else {
      errorMsg = "We're facing some issues please try again later";
      setLoading(false);
    }
    notifyListeners();
  }

  logout() async {
    await Utils.logout().then((value) => Get.back());
    isGoogleLogin = false;
  }
}
