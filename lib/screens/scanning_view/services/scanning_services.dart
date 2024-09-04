import 'dart:convert';
import 'dart:io';
import 'package:express/common_models/api_response.dart';
import 'package:express/common_models/error_model.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/screens/scanning_view/model/loose_skus_prouduct_model.dart';
import 'package:express/screens/scanning_view/model/products_model.dart';
import 'package:express/utils/extensions.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/static_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ScanningServices {
  Future getLooseSkusProduct()async{
    // try{
      http.Response response = await http.get("${baseUrl}api/v1/get_loose_skus".toUri());

      if(successCodes.contains(response.statusCode)){
        var data = jsonDecode(response.body);
        if(data["success"] == 1){
          if(data["loose_skus"] != null){
            LooseSkusProductModel looseSkusProductModel = LooseSkusProductModel.fromJson(data);
            ApiResponseModel apiResponseModel = ApiResponseModel(statusCode: response.statusCode,data: looseSkusProductModel,success: true);
            return apiResponseModel;
          }
        }
      }else{
        ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: response.statusCode,
            success: false,
            errorModel: errorModel);
        return apiResponseModel;
      }
    // }catch(e){
    //   print("error");
    //   print(e);
    //   return null;
    // }
  }

  Future getProductsData({required String barcode,}) async {

    try {
      print("_______barcode______$barcode");
      print(barcode);

      http.Response response = await http.post(
        "${baseUrl}api/v1/scan_item".toUri(),
        body: StaticInfo.isGuest
            ? {
                "code": barcode,
                "device_info": Platform.isAndroid ? "android" : "ios"
              }
            : {
                "code": barcode,
                "user_id": StaticInfo.userModel?.id,
                "device_info": Platform.isAndroid ? "android" : "ios"
              },
      );

      if (successCodes.contains(response.statusCode)) {
        print(response.statusCode);
        var data = json.decode(response.body);
        print("---------------data-------------------");
        print(response.body);
        if (data["success"] == 0) {
          UiServices().customPopUp(key: data["message"], success: false,padding: 400.h);
        } else {
          if (data["data"] != null) {
            print("_____________services__________");
            print(response.body);
            ProductsModel productsList =
                ProductsModel.fromJson(json.decode(response.body));

            ApiResponseModel apiResponseModel = ApiResponseModel(
                statusCode: response.statusCode,
                success: true,
                data: productsList);

            return apiResponseModel;
          }
        }

        // return null;
      } else {
        ErrorModel errorModel = ErrorModel.fromJson(json.decode(response.body));
        ApiResponseModel apiResponseModel = ApiResponseModel(
            statusCode: response.statusCode,
            success: false,
            errorModel: errorModel);
        return apiResponseModel;
      }
    } catch (e) {
      // e.debugPrint();
      print("error");
      print(e);
      return null;
    }
  }
}
