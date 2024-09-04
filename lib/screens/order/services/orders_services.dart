import 'dart:convert';
import 'package:express/common_models/api_response.dart';
import 'package:express/common_models/error_model.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/utils/extensions.dart';
import 'package:express/utils/global_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class OrdersServices {
  Future<ApiResponseModel?> createInvoice({
    required String ordersNo,
    required String phoneNumber,
    required String email,
  }) async {
    try {

      http.Response response = await http.post(
          "${baseUrl}api/v1/send_invoice".toUri(),
          body: phoneNumber.isEmpty ? {
            "order_no": ordersNo,
            "email": email,
          } : email.isEmpty ? {
            "order_no": ordersNo,
            "phone_no": phoneNumber,
          } :{
            "order_no": ordersNo,
            "phone_no": phoneNumber,
            "email": email,
          }
      );

      print(response.statusCode);
      if (successCodes.contains(response.statusCode)) {
        var decodedData = json.decode(response.body);

        print("success");
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: response.statusCode, success: true, data: decodedData);

        return apiResponseModel;
      } else {
        ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
        print("error model ${errorModel.errors}");
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: response.statusCode,
            success: false,
            errorModel: errorModel);
        return apiResponseModel;
      }
    } catch (e) {
      // e.debugPrint();
      print("error");
      UiServices().customPopUp(
          key: "We're facing some error.Please try again later", success: false,padding: 400.h);
      print(e);
      return null;
    }
  }

  Future<ApiResponseModel?> validatePhoneNumber(
      {required String phoneNumber}) async {
    try {
      http.Response response = await http.post(
        "https://he3.co.za/utility/validate/phone/$phoneNumber".toUri(),
      );

      if (successCodes.contains(response.statusCode)) {
        var decodedData = json.decode(response.body);

        print("this is decoded ${response.body}");
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: response.statusCode, success: true, data: decodedData);

        return apiResponseModel;
      } else {
        UiServices().customPopUp(
            key: "Please enter valid phone number", success: false,padding: 400.h);
      }
    } catch (e) {
      // e.debugPrint();
      print("error");
      print(e);
      return null;
    }
  }
}
