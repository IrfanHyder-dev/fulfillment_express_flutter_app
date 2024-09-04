import 'package:express/common_services/shared_preference.dart';
import 'package:express/screens/login_with/model/user_data_model.dart';
import 'package:express/utils/static_info.dart';
import 'package:flutter/cupertino.dart';


class LoginCheckNotifier extends ChangeNotifier
{
  bool isSplash=false;
  void isSplashViewed()
  {
    print("login splash ${SharedPreferencesService().getSplashViewed()}");
    if(SharedPreferencesService().getSplashViewed())
      {
        isSplash= true;
      }
    else
      {
        isSplash= false;
      }
    notifyListeners();
  }

  checkLogin() async {
    bool? isUserLogin=SharedPreferencesService().getIsUserLogin();

    if(isUserLogin!)
      {
        UserDataModel? data =SharedPreferencesService().getUser();
        print("____________________user data_______________");
        print(data);
        StaticInfo.userModel=data;
        StaticInfo.isGuest=false;
        notifyListeners();
        // Get.offAll(()=>BarcodeScanner());
      }
    // else
    //   {
    //     Get.offAll(()=>SplashView());
    //   }
  }






}