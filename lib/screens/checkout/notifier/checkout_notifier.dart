import 'dart:io';
import 'package:express/common_models/api_response.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/screens/checkout/model/additional_cost_product_model.dart';
import 'package:express/screens/checkout/model/barcode_model.dart';
import 'package:express/screens/checkout/model/sku_product_checkuout.dart';
import 'package:express/screens/checkout/services/checkout_services.dart';
import 'package:express/screens/login_with/view/login_with_view.dart';
import 'package:express/screens/order/model/orders_model.dart';
import 'package:express/screens/order/view/order_view.dart';
import 'package:express/screens/scanning_view/model/common_model.dart';
import 'package:express/screens/scanning_view/notifier/scanning_notifier.dart';
import 'package:express/screens/scanning_view/widgets/custom_dialog.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/static_info.dart';
import 'package:express/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:action_cable/action_cable.dart';

class CheckoutNotifier extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  double vatPrice = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  String errorMsg = "";
  bool loading = false;
  bool barCodeLoading = false;
  bool imageLoading = false;
  List<String> productsIds = [];
  List<SkuProductCheckOut> skuProductIdsQty = [];
  List<AdditionalCostProductModel> additionalProductList = [];
  BarcodeModel? barcodeModel;
  ActionCable? cable;
  bool isButtonEnable = false;
  String? guestUserId;
  var bankAccountHTML;
  bool showHtmlText=false;

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  setImageLoading(bool value) {
    imageLoading = value;
    notifyListeners();
  }

  setBarcodeLoading(bool value) {
    barCodeLoading = value;
    notifyListeners();
  }

  List<File> imageFile = [];
  List<String> productImages = [];
  Map<dynamic, dynamic> socketResponse = {};

  initialize(List<CommonProductModel>? commonProducts) async {
    setBarcodeLoading(true);
    getSubTotal(commonProducts ?? []);
    getProductsIds(commonProducts ?? []);
    await generateBarcode();
    await initPlatformState();
    await getBankDetails();
    setBarcodeLoading(false);
  }

  void getSubTotal(List<CommonProductModel> listOfProducts) {
    subTotal = 0.0;
    double origianlTotalPrice = 0;
    for (var item in listOfProducts) {
      print('================ item name ${item.texName}');
      if (item.texName == 'Inclusive') {
        double calculatedPrice =
            item.amount! - ((vatPercent / 100) * item.amount!);
        subTotal += calculatedPrice;
        origianlTotalPrice += item.price!;
      } else {
        subTotal += item.price!;
        origianlTotalPrice += item.price!;
      }
    }
    vatPrice = (vatPercent / 100) * origianlTotalPrice;
    total = subTotal + vatPrice;
    notifyListeners();
  }

  void getProductsIds(List<CommonProductModel> listOfProducts) {
    listOfProducts.forEach((element) {
      if (element.productType == ProductType.looseSkuProduct) {
        SkuProductCheckOut data =
            SkuProductCheckOut(id: element.id!, quantity: element.quantity!);

        skuProductIdsQty.add(data);
      } else if (element.productType == ProductType.additionalCost) {
        AdditionalCostProductModel additionalCostProductModel =
            AdditionalCostProductModel(
                costName: element.costName!,
                taxName: element.texName!,
                amount: element.amount!);
        additionalProductList.add(additionalCostProductModel);
      } else {
        productsIds.add(element.id!);
      }
    });
    print("these are product ids");
    print(productsIds);
    print(skuProductIdsQty);
  }

  Future<void> generateBarcode() async {
    ApiResponseModel? apiResponseModel =
        await CheckoutServices().generateBarcode(ids: productsIds);
    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {
        print("_____________________notifier________________________");
        barcodeModel = apiResponseModel.data;
        socketConnection();
      } else {
        print("error");
        errorMsg = apiResponseModel.errorModel!.errors!.first;
      }
    } else {
      errorMsg = "We're facing some issues.Please try again later";
    }

    notifyListeners();
  }

  Future<void> getBankDetails() async {
    ApiResponseModel? apiResponseModel =
        await CheckoutServices().paymentBankDetail();
    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {

        bankAccountHTML=apiResponseModel.data;
      } else {
        print("error");
        errorMsg = apiResponseModel.errorModel!.errors!.first;
      }
    } else {
      errorMsg = "We're facing some issues.Please try again later";
    }

    notifyListeners();
  }

  initPlatformState() async {
    try {
      await FlutterBugfender.init("KEzv7x82j5z3CohA9NauoeSNUqZDSbNo",
          enableAndroidLogcatLogging: false);
      await FlutterBugfender.log("Initialized Bugfender");
    } catch (e) {
      print("Error found!!!! $e");
      throw e;
    }
    if (!Get.context!.mounted) return;
  }

  void setShowingOfflinePaymentText(){
    showHtmlText=!showHtmlText;
    notifyListeners();
  }

  Future<void> getImageFromCamera() async {
    setImageLoading(true);
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
      maxWidth: 1080,
      maxHeight: 1920,
    );

    if (image != null) {
      imageFile.add(File(image.path));
      productImages.add(image.path);
      print(image.path);

      enableButton();
    }

    setImageLoading(false);
    Future.delayed(Duration(milliseconds: 500), () async {
      await animateScroll();
    });

    notifyListeners();
  }

  Future checkout(
      {required String userId,
      required ScanningNotifier scanningNotifier}) async {
    setLoading(true);
    ApiResponseModel? apiResponseModel = await CheckoutServices()
        .postOrderCheckout(
            amount: total.toString(),
            productImages: imageFile,
            productIds: productsIds,
            skusProductIdsQty: skuProductIdsQty,
            additionalProductList: additionalProductList,
            userId: userId);

    print('=========================> checkout response $apiResponseModel');
    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {
        if (apiResponseModel.data["success"] == "0") {
          UiServices().customPopUp(
              key: "User has not permission to place order",
              success: false,
              padding: 400.h);
        } else {
          if (apiResponseModel.data["data"] == null) {
            customDialog(
              fontSize: 14.sp,
              showCancelButton: false,
              confirmBtnText: 'Start Over',
              description: "Order already placed with these items",
              context: Get.context!,
              onConfirm: () {
                print("confirm");
                scanningNotifier.onRemove();
                Get.back();
                Get.back();
              },
            );
          } else {
            OrderModel orderModel = OrderModel.fromJson(apiResponseModel.data);
            print("_________________order________________");
            print(orderModel.data?.order?.orderNo);
            Get.offAll(
              () => OrderView(ordersModel: orderModel, totalPrice: total),
            );
          }
        }
        print("order posted");
      } else {
        print("error");
        errorMsg = apiResponseModel.errorModel!.errors!.first;
      }
      setLoading(false);
    } else {
      errorMsg = "We're facing some issues.Please try again later";
      setLoading(false);
    }

    notifyListeners();
  }

  void onCheckout({required ScanningNotifier scanningNotifier}) {
    print("_______________tappped______________");
    if (imageFile.isEmpty) {
      print("________________user id________________");
      print(guestUserId);

      UiServices().customPopUp(
          key: "Please upload images", success: false, padding: 400.h);
    } else if (StaticInfo.isGuest) {
      print("________________user id________________");
      print(guestUserId);
      checkout(
          userId: guestUserId.toString(), scanningNotifier: scanningNotifier);
    } else {
      checkout(
          userId: StaticInfo.userModel!.id.toString(),
          scanningNotifier: scanningNotifier);
    }
  }

  void onLogin() async {
    if (!StaticInfo.isGuest) {
      await Utils.logout();
    } else {
      await Get.to(() => LoginWithView());
    }
    enableButton();
    notifyListeners();
  }

  void enableButton() {
    print("enable button called");
    print("________________________________");

    if (imageFile.isEmpty ||
        (StaticInfo.userModel == null && guestUserId == null)) {
      isButtonEnable = false;
    } else {
      isButtonEnable = true;
    }
    print(isButtonEnable);
  }

  void socketConnection() async {
    print("barcode ${barcodeModel?.code}");
    // cable = ActionCable.Connect("wss://staging.fulfillment.vip/cable",
    cable = ActionCable.Connect(socketUrl, onConnected: () {
      print("connection established");
      cable?.subscribe("Barcodes", // either "Chat" and "ChatChannel" is fine
          channelParams: {"code": barcodeModel?.code}, onSubscribed: () {
        print("subscribed to barcode");
      }, // `confirm_subscription` received
          onDisconnected: () {
        print("disconnected");
      }, // `disconnect` received
          onMessage: (Map message) {
        print("Message received");

        if (message != null) {
          socketResponse = message;
          UiServices().customPopUp(
              key: socketResponse["message"], success: true, padding: 400.h);

          guestUserId = socketResponse["data"]["user_id"];
          enableButton();
          notifyListeners();
        }
      } // any other message received
          );
    }, onConnectionLost: () {
      print("connection lost");
      socketConnection();
    }, onCannotConnect: () {
      print("cannot connect");
    });
  }

  Future animateScroll() async {
    if (scrollController.hasClients) {
      print("animation called");
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(
          milliseconds: 500,
        ),
        curve: Curves.easeOut,
      );
    }
  }
}
