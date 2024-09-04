import 'dart:convert';
import 'dart:io';

import 'package:express/common_models/api_response.dart';
import 'package:express/common_services/ui_services.dart';
import 'package:express/screens/login_with/view/login_with_view.dart';
import 'package:express/screens/scanning_view/model/common_model.dart';
import 'package:express/screens/scanning_view/model/loose_skus_prouduct_model.dart';
import 'package:express/screens/scanning_view/model/products_model.dart';
import 'package:express/screens/scanning_view/services/scanning_services.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/static_info.dart';
import 'package:express/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';

class ScanningNotifier extends ChangeNotifier {
  TextEditingController quantityController = TextEditingController(text: '1');
  TextEditingController costNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final additionalCostFormKey = GlobalKey<FormState>();
  ScrollController skuListController = ScrollController();
  String taxName = 'Inclusive';
  DCVCameraEnhancer? cameraEnhancer;
  DCVBarcodeReader? barcodeReader;
  final DCVCameraView cameraView = DCVCameraView();
  ScrollController controller = ScrollController();
  String errorMsg = "";
  String dialogErrorMsg = '';
  ProductsModel? productsModel;

  // List<ProductsModel> productsList = [];
  List<CommonProductModel> productsList = [];
  List<String> barcodesList = [];
  List<LooseSkus> looseSkusProductList = [];
  LooseSkusProductModel? looseSkusProduct;
  double subTotalPrice = 0.0;
  double totalPrice = 0.0;
  double vatPrice = 0.0;
  bool showQuantityError = false;
  bool productExist = false;

  List<BarcodeResult> decodeRes = [];
  String? resultText;
  String? base64ResultText;
  bool faceLens = false;
  bool loading = false;
  bool removeMode = false;
  bool scanning = true;

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  setRemoveMode(bool value) {
    removeMode = value;
    notifyListeners();
  }

  Future<void> getLooseSkusProducts() async {
    print('loose product sku model ');
    setLoading(true);
    ApiResponseModel? apiResponseModel =
        await ScanningServices().getLooseSkusProduct();
    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {
        looseSkusProduct = apiResponseModel.data;
        notifyListeners();
      } else {
        print("error");
        errorMsg = apiResponseModel.errorModel!.errors!.first;
      }
      setLoading(false);
    } else {
      errorMsg = "We're facing some issues.Please try again later";
      setLoading(false);
    }
  }

  Future<void> getProductInfo({required String barcode}) async {
    setLoading(true);
    ApiResponseModel? apiResponseModel =
        await ScanningServices().getProductsData(barcode: barcode);
    if (apiResponseModel != null) {
      if (successCodes.contains(apiResponseModel.statusCode)) {
        productsModel = apiResponseModel.data;

        if (!barcodesList.contains(barcode)) {
          if (productsModel != null) {
            var data = productsModel?.data?.item;
            CommonProductModel productModel = CommonProductModel(
             productType: ProductType.barcodeProduct,
                id: data?.id,
                barcodeIds: data?.barcode,
                price: data?.price,
                skuId: data?.skuId,
                skuImage: data?.itemSku.skuImage,
                skuImageChange: data?.itemSku.skuImageChange,
                skuQty: data?.itemSku.skuQty,
                sku: data?.itemSku.sku);
            // productsList.add(productsModel!);
            productsList.add(productModel);
            barcodesList.add(barcode);
          }
        }
        calculateTotalPrice();
        notifyListeners();
      } else {
        print("error");
        errorMsg = apiResponseModel.errorModel!.errors!.first;
      }
      setLoading(false);
      // animateScroll();
    } else {
      errorMsg = "We're facing some issues.Please try again later";
      setLoading(false);
    }

    // animateScroll();
    await Future.delayed(
      Duration(milliseconds: 100),
    );
    barcodeReader?.startScanning();
    notifyListeners();
  }

  void sdkInit() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      print("denied");
      var result = await Permission.camera.request();
      if (result.isGranted) {
        // Get.offAll(() => BarcodeScanner());
        // ref.read(scanningProvider).sdkInit();
      } else if (result.isDenied) {
        print("again denied");
        // Platform.isAndroid?
        SystemNavigator.pop();
        //     :
        // exit(0);
      }
    }
    // Create a barcode reader instance.
    barcodeReader = await DCVBarcodeReader.createInstance();
    cameraEnhancer = await DCVCameraEnhancer.createInstance();

    /// Get the current runtime settings of the barcode reader.
    DBRRuntimeSettings? currentSettings =
        await barcodeReader?.getRuntimeSettings();

    /// Set the barcode format to read.
    currentSettings?.barcodeFormatIds = EnumBarcodeFormat.BF_ONED |
        EnumBarcodeFormat.BF_QR_CODE |
        EnumBarcodeFormat.BF_PDF417 |
        EnumBarcodeFormat.BF_DATAMATRIX;

    // currentSettings.minResultConfidence = 70;
    // currentSettings.minBarcodeTextLength = 50;

    /// Set the expected barcode count to 0 when you are not sure how many barcodes you are scanning.
    /// Set the expected barcode count to 1 can maximize the barcode decoding speed.
    currentSettings?.expectedBarcodeCount = 0;

    /// Apply the new runtime settings to the barcode reader.
    await barcodeReader
        ?.updateRuntimeSettingsFromTemplate(EnumDBRPresetTemplate.DEFAULT);
    if (currentSettings != null) {
      await barcodeReader?.updateRuntimeSettings(currentSettings);
    }

    // Enable barcode overlay visiblity.
    cameraView.overlayVisible = true;

    cameraView.torchButton = TorchButton(
      visible: false,
    );

    await barcodeReader?.enableResultVerification(true);

    // print(barcodeReader)
    /// Stream listener to handle callback when barcode result is returned.
    barcodeReader
        ?.receiveResultStream()
        .listen((List<BarcodeResult>? res) async {
      if (res?.length != null && res!.length == 1) {
        vibrateWithBeep();
        barcodeReader?.stopScanning();
        if (removeMode) {
          setLoading(true);
          // productsList.removeWhere(
          //     (element) => element.data?.item.barcode == res[0].barcodeText);
          productsList.removeWhere(
              (element) => element.barcodeIds == res[0].barcodeText);
          barcodesList.removeWhere((element) => element == res[0].barcodeText);
          calculateTotalPrice();
          if (productsList.isEmpty) {
            setRemoveMode(false);
            notifyListeners();
          }

          Future.delayed(
            Duration(
              seconds: 2,
            ),
          );
          setLoading(false);
          Future.delayed(
              Duration(seconds: 3), () => barcodeReader?.startScanning());
        } else {
          if (!(barcodesList.contains(res[0].barcodeText))) {
            await getProductInfo(barcode: res[0].barcodeText);
            animateScroll();
            await Future.delayed(Duration(seconds: 3));
            barcodeReader?.startScanning();
          } else {
            UiServices().customPopUp(
                key: "Product already Added", success: false, padding: 400.h);

            await Future.delayed(Duration(seconds: 3));
            barcodeReader?.startScanning();
          }
        }
      }
    });

    await cameraEnhancer?.open();

    // Enable video barcode scanning.
    // If the camera is opened, the barcode reader will start the barcode decoding thread when you triggered the startScanning.
    // The barcode reader will scan the barcodes continuously before you trigger stopScanning.
    await barcodeReader?.startScanning();
    notifyListeners();
  }

  /// Remove loose sku products
  void removeSkusProduct(String id) {
    productsList.removeWhere((element) => element.id == id);
    calculateTotalPrice();
    if (productsList.isEmpty) {
      setRemoveMode(false);
      notifyListeners();
    }
    notifyListeners();
  }

  Future updateRuntimeSettings() async {
    // Get the current runtime settings of the barcode reader.
    DBRRuntimeSettings? currentSettings =
        await barcodeReader?.getRuntimeSettings();
    // Set the barcode format to read.
    currentSettings?.barcodeFormatIds = EnumBarcodeFormat.BF_ONED |
        EnumBarcodeFormat.BF_QR_CODE |
        EnumBarcodeFormat.BF_PDF417 |
        EnumBarcodeFormat.BF_DATAMATRIX;

    // currentSettings.minResultConfidence = 70;
    // currentSettings.minBarcodeTextLength = 50;

    // Set a higher expected barcode count can improve the read rate of the library.
    currentSettings?.expectedBarcodeCount = 512;
    // Apply the new runtime settings to the barcode reader.
    if (currentSettings != null) {
      await barcodeReader?.updateRuntimeSettings(currentSettings);
    }
    await barcodeReader?.updateRuntimeSettingsFromTemplate(
        EnumDBRPresetTemplate.IMAGE_READ_RATE_FIRST);
    await barcodeReader?.enableResultVerification(true);
  }

  void vibrateWithBeep() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate();
    }
    FlutterBeep.beep();
  }

  void onRemove() {
    productsList.clear();
    barcodesList.clear();
    calculateTotalPrice();
    notifyListeners();
  }

  void calculateTotalPrice() {
    double total = 0;
    double origianlTotalPrice = 0;
    for (var item in productsList) {
      print('================ item name ${item.texName}');
      if(item.texName == 'Inclusive'){
        double calculatedPrice = item.amount! - ((vatPercent / 100) * item.amount!);
        total += calculatedPrice;
        origianlTotalPrice += item.price!;
      }else{
        total += item.price!;
        origianlTotalPrice += item.price!;
      }
    }
    subTotalPrice = total;
    vatPrice = (vatPercent / 100) * origianlTotalPrice;
    totalPrice = subTotalPrice + vatPrice;
    notifyListeners();
  }

  void setQuantityOfLooseSku({required int index, required int quantity}) {
    var data = looseSkusProduct?.looseSkus![index];
    for (var item in productsList) {
      productExist = item.id == data?.id;
    }
    if (quantity > looseSkusProduct!.looseSkus![index].skuQty! &&
        !productExist) {
      dialogErrorMsg = "Quantity must be less or equal to ${data?.skuQty}";
      showQuantityError = true;
      notifyListeners();
    } else {
      var price;
      looseSkusProduct = looseSkusProduct;
      int indexOfExistingProduct =
          productsList.indexWhere((element) => element.id == data?.id);
      int totalQuantity = (productExist)
          ? quantity + productsList[indexOfExistingProduct].quantity!
          : quantity;
      print(
          '---------------------------------------- $totalQuantity     $quantity    ${quantity + data!.skuQty!}   ${data.skuQty!}');
      if (totalQuantity > data.skuQty!) {
        var remaining =
            data.skuQty! - productsList[indexOfExistingProduct].quantity!;
        if (remaining == 0) {
          Get.back();
          UiServices().customPopUp(
              key: "Product already Added", success: false, padding: 400.h);
        } else {
          dialogErrorMsg = "Quantity must be less or equal to $remaining";
          totalQuantity = 0;
          showQuantityError = true;
          notifyListeners();
        }
      } else {
        price = totalQuantity * looseSkusProduct!.looseSkus![index].price!;
        looseSkusProduct?.looseSkus![index].skuQty = totalQuantity;
        var data = looseSkusProduct?.looseSkus![index];
        looseSkusProduct = looseSkusProduct;
        showQuantityError = false;
        productsList.contains(data?.id);

        if (!productExist) {
          CommonProductModel productModel = CommonProductModel(
            productType: ProductType.looseSkuProduct,
            quantity: quantity,
            id: data?.id,
            price: price,
            unitPrice: data?.price,
            sku: data?.sku,
            skuImage: data?.skuImage,
            skuImageChange: data?.skuImageChange,
            skuQty: data?.skuQty,
            skuName: data?.skuName,
          );
          productsList.add(productModel);
          calculateTotalPrice();

          Get.back();
          Get.back();
        } else {
          productsList[indexOfExistingProduct].quantity = totalQuantity;
          productsList[indexOfExistingProduct].price = price;
          calculateTotalPrice();
          Get.back();
          Get.back();
        }
      }
      notifyListeners();
      quantityController.text = '1';
    }
  }

  void onTapAdditionalDialogAddButton() {
    if (additionalCostFormKey.currentState!.validate()) {
      print('==================> Additional cost  ${taxName}     ${costNameController.text.trim()}    ${double.parse(amountController.text.trim())}');
      CommonProductModel commonProductModel = CommonProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        texName: taxName,
        costName: costNameController.text.trim(),
        price: double.parse(amountController.text.trim()),
        amount: double.parse(amountController.text.trim()),
        productType: ProductType.additionalCost
      );

      productsList.add(commonProductModel);
      calculateTotalPrice();
      Get.back();
      Get.back();
      costNameController.text = '';
      amountController.text = '';
      notifyListeners();
    }
  }

  String? additionCostFormValidator(String? value) {
    if (value.toString().isEmpty) {
      return 'Field required';
    }
  }

  void startScanner() {
    barcodeReader?.startScanning();
    cameraEnhancer?.open();
    notifyListeners();
  }

  void stopScanner() {
    barcodeReader?.stopScanning();
    cameraEnhancer?.close();
  }

  void onLogin() async {
    if (!StaticInfo.isGuest) {
      await Utils.logout();
      notifyListeners();
    } else {
      stopScanner();
      await Get.to(() => LoginWithView());
      startScanner();
    }
    notifyListeners();
  }

  void onTapRadioButton(String? value) {
    taxName = value.toString();
    notifyListeners();
  }

  void editAdditionalCostCharges(String productId){
    print('============================> edit additional');
    int index = productsList.indexWhere((element) => element.id == productId);
    productsList[index].texName = taxName;
    productsList[index].costName = costNameController.text.trim();
    productsList[index].amount = double.parse(amountController.text.trim());
    productsList[index].price = double.parse(amountController.text.trim());

    calculateTotalPrice();
    Get.back();
    costNameController.text = '';
    amountController.text = '';
    notifyListeners();
  }

  void animateScroll() {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: Duration(
          microseconds: 100,
        ),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cameraEnhancer?.close();
    barcodeReader?.stopScanning();
    quantityController.dispose();
    skuListController.dispose();
    super.dispose();
  }
}
