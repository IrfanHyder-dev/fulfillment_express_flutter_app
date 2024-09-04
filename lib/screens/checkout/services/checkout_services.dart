import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:express/common_models/api_response.dart';
import 'package:express/common_models/error_model.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/screens/checkout/model/additional_cost_product_model.dart';
import 'package:express/screens/checkout/model/barcode_model.dart';
import 'package:express/screens/checkout/model/sku_product_checkuout.dart';
import 'package:express/utils/extensions.dart';
import 'package:express/utils/global_constant.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class CheckoutServices {
  Future postOrder({
    required List<File> productImages,
    required List<String> productIds,
    required String userId,
    required String amount,
  }) async {
    try {
      String? id = userId;
      print("these are product ids");
      print(productIds);

      var request = http.MultipartRequest(
        "POST",
        '${baseUrl}api/v1/order_items'.toUri(),
      );
      List<http.MultipartFile> images = [];
      for (File id in productImages) {
        var f = await http.MultipartFile.fromPath(
            "payment_photos_attributes[]picture", id.path);
        images.add(f);
      }

      List<http.MultipartFile> ids = [];
      for (String id in productIds) {
        var f = http.MultipartFile.fromString("item_ids[]", id);
        ids.add(f);
      }
      print("The imaged sent are ${images.length}");
      print("The ids sent are ${ids.length}");

      // productIds.forEach((id) async => request.fields["item_ids[]"] = id);
      // request.fields["item_ids[]"] = productIds;
      request.files.addAll(ids);
      request.files.addAll(images);
      request.fields["payment"] = "verified";
      request.fields["payment_method"] = "offline";
      request.fields["user_id"] = id;
      request.fields["amount"] = amount;
      var response = await request.send();
      var responseData =
          await response.stream.toBytes().timeout(Duration(seconds: 10));

      var responseString = String.fromCharCodes(responseData);

      log(jsonEncode(responseString));
      var result = json.decode(responseString);
      if (successCodes.contains(response.statusCode)) {
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: response.statusCode, success: true, data: result);

        return apiResponseModel;
      } else {
        // UiServices()
        //     .customSnackbar(msg: "Order failed", bgColor: KColors.redColor);
        ErrorModel errorModel = ErrorModel.fromJson(result);
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: response.statusCode,
            success: false,
            errorModel: errorModel);
        return apiResponseModel;
      }
    } on TimeoutException catch (e) {
      print("error");
      UiServices().customPopUp(
          key: "Connection timed out.Please try again",
          success: false,
          padding: 20);
      print(e);
      return null;
    } on SocketException catch (e) {
      print("error");
      UiServices().customPopUp(
          key: "We're facing some issues.Please try again later",
          success: false,
          padding: 20);

      print(e);
      return null;
    }
  }

  int count = 0;

  Future generateBarcode({required List<String> ids}) async {
    try {
      http.Response response = await http.post(
        "${baseUrl}api/v1/generate_barcode".toUri(),
        body: {"items[]": ids[0]},
      );

      print("response body");
      print(response.body);
      if (successCodes.contains(response.statusCode)) {
        var decodedData = json.decode(response.body);

        print(decodedData);
        BarcodeModel model = BarcodeModel.fromJson(decodedData["barcode"]);

        ApiResponseModel apiResponseModel = ApiResponseModel(
          statusCode: response.statusCode,
          success: true,
          data: model,
        );

        return apiResponseModel;
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
      print(e);
      return null;
    }
  }

  Future postOrderCheckout({
    required List<File> productImages,
    required List<String> productIds,
    required List<SkuProductCheckOut> skusProductIdsQty,
    required List<AdditionalCostProductModel> additionalProductList,
    required String userId,
    required String amount,
  }) async {
    try {
      String? id = userId;
      print("these are product ids");
      print(productIds);

      var request;
      var result;
      final r = RetryOptions(maxAttempts: 2);

      var retryApi = await r.retry(
        // Make a GET request
        () async {
          request = http.MultipartRequest(
            "POST",
            '${baseUrl}api/v1/order_items'.toUri(),
          );
          List<http.MultipartFile> images = [];
          for (File id in productImages) {
            var f = await http.MultipartFile.fromPath(
                "payment_photos_attributes[]picture", id.path);
            images.add(f);
          }
          for (var image in images) {
            FlutterBugfender.log("images ${image.toString()}");
          }

          List<http.MultipartFile> ids = [];
          for (String id in productIds) {
            var f = http.MultipartFile.fromString("item_ids[]", id);
            ids.add(f);
          }
          List<http.MultipartFile> skuList = [];
          List<String> dummy = [];
          for (SkuProductCheckOut skuPro in skusProductIdsQty) {
            Map<String, dynamic> body = {
              "id": skuPro.id,
              "quantity": skuPro.quantity
            };
            dummy.add(jsonEncode(body));
          }
          for (String data in dummy) {
            var f = http.MultipartFile.fromString('skus[]', data);
            skuList.add(f);
          }
          List<http.MultipartFile> additionalProduct = [];
          List<String> additionalProductString = [];
          for (AdditionalCostProductModel additionalProduct
              in additionalProductList) {
            Map<String, dynamic> body = {
              "name": additionalProduct.costName,
              "amount": additionalProduct.amount,
              "charge_type": additionalProduct.taxName,
            };
            additionalProductString.add(jsonEncode(body));
          }
          for (String data in additionalProductString) {
            var f = http.MultipartFile.fromString('additional_charges[]', data);
            additionalProduct.add(f);
          }
          for (var id in ids) {
            FlutterBugfender.log("ids ${id.toString()}");
          }
          FlutterBugfender.log("userId $id");
          print("The ids sent are ${ids.length}");
          request.files.addAll(ids);
          request.files.addAll(skuList);
          request.files.addAll(additionalProduct);
          request.files.addAll(images);
          request.fields["payment"] = "verified";
          request.fields["payment_method"] = "offline";
          request.fields["user_id"] = id;
          request.fields["amount"] = amount;
          var response = await request.send().timeout(Duration(seconds: 20));
          var responseData = await response.stream.toBytes();

          var responseString = String.fromCharCodes(responseData);
          result = json.decode(responseString);

          log(jsonEncode(responseString));
          return response.statusCode;
        },

        onRetry: (p0) => UiServices().customPopUp(
            key: "Connection timed out.Retrying...",
            success: false,
            padding: 20),
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      if (successCodes.contains(retryApi)) {
        ApiResponseModel apiResponseModel =
            ApiResponseModel(statusCode: retryApi, success: true, data: result);

        return apiResponseModel;
      } else {
        ErrorModel errorModel = ErrorModel.fromJson(result);
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: retryApi, success: false, errorModel: errorModel);
        return apiResponseModel;
      }
    } on TimeoutException catch (e) {
      FlutterBugfender.log("timeout ${e.toString()}");
      print("error");
      UiServices().customPopUp(
          key: "Connection timed out.Please try again",
          success: false,
          padding: 20);
      print(e);
      return null;
    } on SocketException catch (e) {
      FlutterBugfender.log("socket ${e.toString()}");
      print("error");
      UiServices().customPopUp(
          key: "We're facing some issues.Please try again later",
          success: false,
          padding: 20);

      print(e);
      return null;
    } catch (e) {
      FlutterBugfender.log("error ${e.toString()}");
      print("error");
      UiServices().customPopUp(
          key: "We're facing some issues.Please try again later",
          success: false,
          padding: 20);

      print(e);
      return null;
    }
  }

  Future paymentBankDetail() async {
    try {
      http.Response response = await http.get(
        "https://am.co.za/doc/express".toUri(),
      );

      if (successCodes.contains(response.statusCode)) {
        ApiResponseModel apiResponseModel = ApiResponseModel(
          statusCode: response.statusCode,
          success: true,
          data: response.body,
        );

        return apiResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print("error");
      print(e);
      return null;
    }
  }
}
