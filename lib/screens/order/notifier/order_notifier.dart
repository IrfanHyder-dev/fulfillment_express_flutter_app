import 'package:express/common_models/api_response.dart';
import 'package:express/common_services/shared_preference.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/screens/order/services/orders_services.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/static_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderNotifier extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  TextEditingController emailController = TextEditingController(
      text: StaticInfo.isGuest
          ? SharedPreferencesService().getInvoiceEmail()
          : "");
  TextEditingController phoneNumberController = TextEditingController(
      text: StaticInfo.isGuest
          ? SharedPreferencesService().getInvoicePhoneNumber()
          : "");

  String? successMessage;
  bool invoiceShowed = false;
  PhoneNumber initialValue =
      PhoneNumber(dialCode: "+27", isoCode: "ZA", phoneNumber: "");

  RegExp pattern = RegExp(r'^(?:\+92|\+27)(?![0-9]*\+.*\+.*$)');
  bool loading = false;
  bool isButtonEnable = false;
  String errorMsg = "";

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> getInvoice({
    required String orderNumber,
    required String phoneNumber,
    required String email,
  }) async {
    setLoading(true);

    ApiResponseModel? apiResponseModel = await OrdersServices().createInvoice(
        ordersNo: orderNumber,
        email: emailController.text,
        phoneNumber: phoneNumber);

    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {
        print(apiResponseModel.data["message"]);
        if (apiResponseModel.data["success"] == 0) {
          print("failed");
          UiServices().customPopUp(
              key: apiResponseModel.data["message"],
              success: false,
              padding: 0);
        } else {
          animateScroll();
          invoiceShowed = true;
          successMessage = apiResponseModel.data["message"];
          UiServices().customPopUp(
              key: "Submitted",
              success: true,
              padding: 0,
              horizontalPadding: 150.w);
          if (StaticInfo.isGuest) {
            SharedPreferencesService().saveInvoiceEmail(emailController.text);
            SharedPreferencesService()
                .saveInvoicePhoneNo(phoneNumberController.text);
          }
        }
      } else {
        print("error");
        errorMsg = apiResponseModel.errorModel!.errors!.first;
      }
      setLoading(false);
    } else {
      errorMsg = "We're facing some issue.Please try again later";
      setLoading(false);
    }
  }

  Future<void> validatePhoneNumber({required String orderNumber}) async {
    setLoading(true);

    ApiResponseModel? apiResponseModel = await OrdersServices()
        .validatePhoneNumber(phoneNumber: phoneNumberController.text);

    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {
        if (apiResponseModel.data["Valid"] == false) {
          UiServices().customPopUp(
              key: "Please enter valid phone number",
              success: false,
              padding: 0);
        } else {
          await getInvoice(
            orderNumber: orderNumber,
            email: emailController.text,
            phoneNumber: initialValue.phoneNumber.toString(),
          );
        }
      } else {
        errorMsg = apiResponseModel.errorModel!.errors!.first;
        print("error msg $errorMsg");
      }
      setLoading(false);
    } else {
      errorMsg = "We're facing some issue.Please try again later";
      setLoading(false);
    }
  }

  void enableButton() {
    if (emailController.text.isEmpty || phoneNumberController.text.isEmpty) {
      isButtonEnable = false;
    } else {
      isButtonEnable = true;
    }
    notifyListeners();
  }

  void onSubmit({required String orderNumber}) {
    if (emailController.text.isEmpty && phoneNumberController.text.isEmpty) {
      UiServices().customPopUp(
          key: "Please fill one of the field", success: false, padding: 0);
    } else if (emailController.text.isNotEmpty &&
        !GetUtils.isEmail(emailController.text)) {
      UiServices().customPopUp(
          key: "Please enter valid email", success: false, padding: 0);
    } else {
      if (phoneNumberController.text.isEmpty) {
        getInvoice(
            orderNumber: orderNumber,
            phoneNumber: "",
            email: emailController.text);
      } else {
        validatePhoneNumber(orderNumber: orderNumber);
      }
    }
  }
  void animateScroll() {
    if(scrollController.hasClients)
    {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500,),
        curve: Curves.easeOut,
      );
    }
  }
}
