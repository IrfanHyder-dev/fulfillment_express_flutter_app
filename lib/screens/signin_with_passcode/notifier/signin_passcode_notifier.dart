import 'dart:convert';

import 'package:express/common_models/api_response.dart';
import 'package:express/common_services/shared_preference.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/screens/scanning_view/view/scanning_view.dart';
import 'package:express/screens/signin_with_passcode/services/signin_passcode_services.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/static_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../login_with/model/user_data_model.dart';

class SignInPasscodeNotifier extends ChangeNotifier{
  bool loading = false;
  String errorMsg = "";
  List<String> numPad = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "remove",
    "0",
    "done",
  ];

  List<String> result = [];

  void buttonOnTap(String value){
    if (value == "remove" && result.isNotEmpty) {
      result.removeLast();
    } else if (value == "done") {
      print(result);
      loginUser();
    } else if (result.length < 8) {
      result.add(value);
    }
    notifyListeners();
  }

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> loginUser() async {
    setLoading(true);
    String code = result.join();
    print('code is ${code}');
    ApiResponseModel? apiResponseModel =
    await SignInPasscodeService().loginAtServer(code: code,);

    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {
        StaticInfo.userModel = UserDataModel.fromJson(apiResponseModel.data);
        // StaticInfo.userModel = UserDataModel.fromJson(apiResponseModel.data);
        SharedPreferencesService().setIsLogin(true);
        var data = jsonEncode(apiResponseModel.data);
        SharedPreferencesService().saveUser(data);
        StaticInfo.isGuest = false;
        Future.delayed(Duration(seconds: 2),(){
          Navigator.pop(Get.context!);
          Navigator.pop(Get.context!);
        });
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
}