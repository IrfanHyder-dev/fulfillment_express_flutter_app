import 'package:express/common_models/error_model.dart';

class ApiResponseModel {
  bool success;
  int statusCode;
  dynamic data;
  String? authToken;
  String? cookie;
  ErrorModel? errorModel;

  ApiResponseModel(
      {this.success = false,
      required this.statusCode,
      this.authToken,
      this.cookie,
      this.data,
      this.errorModel});

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'statusCode': statusCode,
      'data': data,
      'authToken': authToken,
      'errorModel': errorModel,
      'cookie': cookie
    };
  }

  factory ApiResponseModel.fromMap(Map<String, dynamic> map) {
    return ApiResponseModel(
        success: map['success'] as bool,
        statusCode: map['statusCode'] as int,
        data: map['data'] as dynamic,
        authToken: map['authToken'] as String,
        errorModel: map['errorModel'] as ErrorModel,
        cookie: map['cookie']);
  }
}
