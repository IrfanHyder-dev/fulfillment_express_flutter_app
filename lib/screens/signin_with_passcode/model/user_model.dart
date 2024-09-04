import 'dart:convert';

UserDataModel userDataModelFromJson(String str) => UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  String? id;
  String? email;
  String? encryptedPassword;
  String? userId;
  String? userPlatform;
  String? userName;
  dynamic userPhoto;
  String? printerBarcode;
  dynamic deviceToken;
  dynamic deviceType;
  String? lastPrinterUsed;
  String? fcmKey;
  String? appVersion;
  String? locationId;
  String? groupId;
  bool? userAllowed;
  String? subAccountPin;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? defaultLocation;
  dynamic latitude;
  dynamic longitude;
  dynamic fixedLocationLocked;
  List<String>? permissions;
  bool? subAccountsPresent;

  UserDataModel({
    this.id,
    this.email,
    this.encryptedPassword,
    this.userId,
    this.userPlatform,
    this.userName,
    this.userPhoto,
    this.printerBarcode,
    this.deviceToken,
    this.deviceType,
    this.lastPrinterUsed,
    this.fcmKey,
    this.appVersion,
    this.locationId,
    this.groupId,
    this.userAllowed,
    this.subAccountPin,
    this.updatedAt,
    this.createdAt,
    this.defaultLocation,
    this.latitude,
    this.longitude,
    this.fixedLocationLocked,
    this.permissions,
    this.subAccountsPresent,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    id: json["_id"]??"",
    email: json["email"]??"",
    encryptedPassword: json["encrypted_password"]??"",
    userId: json["UserID"]??"",
    userPlatform: json["UserPlatform"]??"",
    userName: json["UserName"]??"",
    userPhoto: json["UserPhoto"]??"",
    printerBarcode: json["PrinterBarcode"]??"",
    deviceToken: json["DeviceToken"]??"",
    deviceType: json["DeviceType"]??"",
    lastPrinterUsed: json["lastPrinterUsed"]??"",
    fcmKey: json["fcm_key"]??"",
    appVersion: json["app_version"]??"",
    locationId: json["LocationID"]??"",
    groupId: json["GroupID"]??"",
    userAllowed: json["UserAllowed"]??false,
    subAccountPin: json["sub_account_pin"]??"",
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    defaultLocation: json["default_location"]??"",
    latitude: json["latitude"],
    longitude: json["longitude"],
    fixedLocationLocked: json["fixed_location_locked"],
    permissions: json["permissions"] == null ? [] : List<String>.from(json["permissions"]!.map((x) => x)),
    subAccountsPresent: json["sub_accounts_present"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "encrypted_password": encryptedPassword,
    "UserID": userId,
    "UserPlatform": userPlatform,
    "UserName": userName,
    "UserPhoto": userPhoto,
    "PrinterBarcode": printerBarcode,
    "DeviceToken": deviceToken,
    "DeviceType": deviceType,
    "lastPrinterUsed": lastPrinterUsed,
    "fcm_key": fcmKey,
    "app_version": appVersion,
    "LocationID": locationId,
    "GroupID": groupId,
    "UserAllowed": userAllowed,
    "sub_account_pin": subAccountPin,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "default_location": defaultLocation,
    "latitude": latitude,
    "longitude": longitude,
    "fixed_location_locked": fixedLocationLocked,
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
    "sub_accounts_present": subAccountsPresent,
  };
}
