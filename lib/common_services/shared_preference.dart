import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:express/screens/login_with/model/user_data_model.dart';

class SharedPreferencesService {
  static const String userKey = "user";
  static const String userTokenKey = "userToken";
  static const String isUserLogin = "isUserLogin";
  static const String isSplashView = "isSplashView";
  static const String invoiceEmail = "invoiceEmail";
  static const String invoicePhoneNumber = "invoicePhoneNumber";

  static final SharedPreferencesService _instance =
      SharedPreferencesService._();

  final pref = SharedPreferences.getInstance();

  SharedPreferencesService._();

  factory SharedPreferencesService() {
    return _instance;
  }

  late SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveBoolValue(String key, bool value) async {
    _prefs.setBool(key, value);
  }

  getBoolValue(String key) async {
    return _prefs.getBool(key) ?? false;
  }

  getSplashViewed() {
    return _prefs.getBool(isSplashView) ?? false;
  }
  getInvoiceEmail() {
    return _prefs.getString(invoiceEmail) ?? "";
  }
  getInvoicePhoneNumber() {
    return _prefs.getString(invoicePhoneNumber) ?? "";
  }

  ///------------------Get User Object to preference

  UserDataModel? getUser() {
    if (_prefs.getString(userKey) != null) {
      UserDataModel userResponseModel = UserDataModel.fromJson(
          json.decode(_prefs.getString(userKey).toString()));
      return userResponseModel;
    }
    return null;
  }

  String? getUserToken() {
    if (_prefs.getString(userTokenKey) != null) {
      String? token = _prefs.getString(userTokenKey);
      print("token saved $token");
      return token;
    }
    print("no token");
    return null;
  }

  bool? getIsUserLogin() {
    if (_prefs.getBool(isUserLogin) != null) {
      bool? token = _prefs.getBool(isUserLogin);
      // print("log in ? $token");
      return token;
    }
    print("no token");
    return false;
  }

  ///--------------------Save User Object to preference

  void saveUser(String user) {
    _prefs.setString(userKey, user);
  }

  void saveInvoiceEmail(String email) {
    _prefs.setString(invoiceEmail, email);
  }

  void saveInvoicePhoneNo(String phoneNumber) {
    _prefs.setString(invoicePhoneNumber, phoneNumber);
  }

  void setSplashView(bool isSplashViewed) {
    print("setSplash $isSplashViewed");
    _prefs.setBool(isSplashView, isSplashViewed);
  }

  void setIsLogin(bool login) {
    _prefs.setBool(isUserLogin, login);
    print("user is login $login");
  }

  void clearLogin() {
    _prefs.remove(isUserLogin);
  }

  ///--------------------Clear User
  void clearUser() {
    _prefs.remove(userKey);
  }
}
