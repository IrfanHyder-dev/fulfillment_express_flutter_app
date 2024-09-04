// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:io';

import 'package:express/common_services/shared_preference.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/utils/static_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Utils {
  static Future googleLogout() async {
    await StaticInfo.googleSigIn.disconnect();
    // await StaticInfo.appleCredentials.lo;
    await StaticInfo.googleSigIn.signOut().then((value) {
      print("Google sign out successfully");
    }).catchError((e) {
      UiServices().customPopUp(key: "We're facing some issues.Please try again later", success: false,padding: 400.h);
      print("Google sign out error $e");
    });
  }

  static logout() async {
    if (Platform.isAndroid) {
      print('userrrrrrrrrrrrrrrrr ${StaticInfo.isGoogleSignIn}');
      if(StaticInfo.isGoogleSignIn){
        await googleLogout();
      }
      StaticInfo.userModel = null;
      StaticInfo.isGuest = true;
      StaticInfo.isGoogleSignIn = false;
      SharedPreferencesService().clearLogin();
      SharedPreferencesService().clearUser();
    } else if (Platform.isIOS) {
      StaticInfo.appleCredentials = null;
      StaticInfo.userModel = null;
      StaticInfo.isGuest = true;
      SharedPreferencesService().clearLogin();
      SharedPreferencesService().clearUser();
    }
  }

  /// can be used
  // static String formatCurrency(
  //     {required String currency, int decimal = 2, bool symbol = true}) {
  //   String formattedPrice='';
  //   NumberFormat decimalPattern = NumberFormat.decimalPattern();
  //    formattedPrice = decimalPattern.format(double.parse(currency));
  //   if (symbol) {
  //
  //     return "R$formattedPrice";
  //   }
  //   return "$formattedPrice";
  // }

  /// can be reused.....

  static String formatCurrency(
      {required String currency, int decimal = 2, bool symbol = true}) {
    var currencyFormat = NumberFormat.currency(
            locale: "en-US", symbol: "", decimalDigits: decimal)
        .format(
      double.parse(
        currency.toString(),
      ),
    );

    if (symbol) {
      return "R$currencyFormat";
    }
    return "$currencyFormat";
  }
}
