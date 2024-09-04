
import 'dart:io';

import 'package:express/screens/login_with/model/user_data_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class StaticInfo {
   static UserDataModel? userModel;
   static bool isGuest=true;
   static GoogleSignIn googleSigIn = GoogleSignIn(clientId: Platform.isIOS ? "622060809531-m22083akkvd1i4269n1mqjjrcv687ttv.apps.googleusercontent.com" : null);
   static bool isGoogleSignIn = false;
   static AuthorizationCredentialAppleID? appleCredentials;

}
