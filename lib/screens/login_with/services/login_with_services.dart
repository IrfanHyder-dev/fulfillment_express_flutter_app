import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:express/common_models/api_response.dart';
import 'package:express/common_models/error_model.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/utils/extensions.dart';
import 'package:express/utils/static_info.dart';
import 'package:express/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:express/utils/global_constant.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginServices {
  static Future<GoogleSignInAccount?> login() =>
      StaticInfo.googleSigIn.signIn();

  static Future<AuthorizationCredentialAppleID?> appleSignIn() async =>
      StaticInfo.appleCredentials =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

  static Future<AuthorizationCredentialAppleID?> appleSignOut() async {

  }

  Future loginAtServer({required String email, required String photo, required String loginPlatform}) async {
    try {
      http.Response response = await http.post(
        "${baseUrl}api/v1/social_login".toUri(),
        body: {
          "login_type": "1",
          "email": email,
          "photo": photo,
          "login_platform": loginPlatform
        },
      );

      if (successCodes.contains(response.statusCode)) {
        print(response.body);

        var decodedData = json.decode(response.body);
        if (decodedData["success"] == 0) {
          UiServices().customPopUp(
              key: decodedData["message"], success: false, padding: 400.h);
          Utils.logout();
        } else {
          ApiResponseModel apiResponseModel = ApiResponseModel(
              statusCode: response.statusCode,
              success: true,
              data: decodedData["user"]);
          UiServices().customPopUp(
              key: decodedData["message"], success: true, padding: 400.h);

          return apiResponseModel;
        }
      } else {
        ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: response.statusCode,
            success: false,
            errorModel: errorModel);
        return apiResponseModel;
      }
    } catch (e) {
      print("error");
      UiServices().customPopUp(
          key: "We're facing some issues.Please try again later",
          success: false,
          padding: 400.h);
      print(e);
      return null;
    }
  }
}
