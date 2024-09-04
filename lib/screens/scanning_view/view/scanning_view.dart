import 'dart:io';
import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/common_widgtets/status_bar_widget.dart';
import 'package:express/common_widgtets/view_header_widget.dart';
import 'package:express/screens/checkout/view/checkout_view.dart';
import 'package:express/screens/scanning_view/notifier/scanning_notifier.dart';
import 'package:express/screens/scanning_view/widgets/button_widget.dart';
import 'package:express/screens/scanning_view/widgets/custom_dialog.dart';
import 'package:express/screens/scanning_view/widgets/products_widget.dart';
import 'package:express/screens/scanning_view/widgets/remove_pop_up.dart';
import 'package:express/screens/scanning_view/widgets/row_text_widget.dart';
import 'package:express/screens/scanning_view/widgets/sku_bottom_sheet_widget.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/static_info.dart';
import 'package:express/utils/styles.dart';
import 'package:express/utils/utils.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BarcodeScanner extends ConsumerStatefulWidget {
  BarcodeScanner({Key? key}) : super(key: key);

  @override
  ConsumerState<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends ConsumerState<BarcodeScanner>
    with WidgetsBindingObserver {
  AutoDisposeChangeNotifierProvider<ScanningNotifier> scanningProvider =
      ChangeNotifierProvider.autoDispose<ScanningNotifier>((ref) {
    return ScanningNotifier();
  });

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(scanningProvider).sdkInit();
      // ref.read(scanningProvider).getLooseSkusProducts();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // Handle app pause (e.g., stop the camera).
      print("_____________________paused called_____________________");
      ref.read(scanningProvider).barcodeReader?.stopScanning();
      ref.read(scanningProvider).cameraEnhancer?.close();
    } else if (state == AppLifecycleState.resumed) {
      print("_____________________resume called_____________________");

      if (backgroundApp) {
        backgroundApp = false;
      } else {
        if (ref.read(scanningProvider).barcodeReader != null) {
          ref.read(scanningProvider).barcodeReader?.startScanning();
          ref.read(scanningProvider).cameraEnhancer?.open();
        }
      }
    }
  }

  @override
  void dispose() {
    print("dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerNotifier = ref.watch(scanningProvider);
    return StatusBarWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Stack(
            children: [
              Container(
                child: scannerNotifier.cameraView,
              ),
              scannerNotifier.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: KColors.primaryColor,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: vMargin,
                        horizontal: hMargin,
                      ),
                      child: Column(
                        children: [
                          ViewHeaderWidget(
                            onLogin: () async {
                              scannerNotifier.onLogin();
                            },
                            onAdd: (){
                              // await scannerNotifier.getLooseSkusProducts();
                              print('------------------------------------------');
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                builder: (context) => SkuBottomSheetWidget(scanningProvider: scanningProvider),
                              );
                            },
                            color: KColors.whiteColor,
                            textColor: KColors.blackColor,
                            showAddButton: true,
                            name: StaticInfo.userModel?.userName ?? "",
                          ),
                          if (scannerNotifier.removeMode) RemoveProductsPopUp(),
                          scannerNotifier.productsList.isEmpty
                              ? Container(
                                  // height: 28.h,
                                  // width: 270.h,
                                  width: 0.7.sw,
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 16.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      ellipsisText: false,
                                      text: "Please Scan Items You Want To Buy",
                                      textStyle: KTextStyles().medium(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                child: FadingEdgeScrollView.fromScrollView(
                                  gradientFractionOnEnd: 0.1,
                                  gradientFractionOnStart: 0.1,
                                  child: ListView.builder(
                                    controller: scannerNotifier.controller,
                                    itemCount:
                                        scannerNotifier.productsList.length,
                                    itemBuilder: (context, index) {
                                      return ProductsWidget(
                                        scanningProvider: scanningProvider,
                                        containerColor: KColors.blackColor
                                            .withOpacity(0.3),
                                        textColor: KColors.whiteColor,
                                        product: scannerNotifier
                                            .productsList[index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                          // 10.verticalSpace,
                          if (scannerNotifier.productsList.isNotEmpty)
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 0.48.sw,

                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 11.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: KColors.blackColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RowTextWidget(
                                      textColor: KColors.whiteColor,
                                      title: "Sub Total : ",
                                      subtitle: Utils.formatCurrency(
                                          currency: scannerNotifier
                                              .subTotalPrice
                                              .toString()),
                                    ),
                                    RowTextWidget(
                                      textColor: KColors.whiteColor,
                                      title: "VAT(15%) : ",
                                      subtitle: Utils.formatCurrency(
                                          currency: scannerNotifier.vatPrice
                                              .toString()),
                                    ),
                                    6.verticalSpace,
                                    Divider(
                                        color: KColors.whiteColor,
                                        height: 0.05),
                                    10.verticalSpace,
                                    RowTextWidget(
                                      textColor: KColors.whiteColor,
                                      title: "Total : ",
                                      subtitle: Utils.formatCurrency(
                                          currency: scannerNotifier.totalPrice
                                              .toString()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          60.verticalSpace,
                        ],
                      ),
                    ),
              if (scannerNotifier.productsList.isNotEmpty)
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      // vertical: vMargin,
                      horizontal: hMargin,
                    ),
                    color: KColors.blackColor.withOpacity(0.5),
                    height: 70.h,
                    width: ScreenUtil().screenWidth,
                    child: scannerNotifier.removeMode
                        ? Center(
                            child: ButtonWidget(
                              onTap: () => scannerNotifier.setRemoveMode(false),
                              text: "Back",
                              color: KColors.redColor,
                              textColor: KColors.whiteColor,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonWidget(
                                onTap: () =>
                                    scannerNotifier.setRemoveMode(true),
                                text: "Remove",
                                color: KColors.redColor,
                                textColor: KColors.whiteColor,
                              ),
                              ButtonWidget(
                                onTap: () => customDialog(
                                  context: context,
                                  onCancel: () {
                                    print("cancel");
                                    Get.back();
                                  },
                                  onConfirm: () {
                                    print("confirm");
                                    scannerNotifier.onRemove();
                                    Get.back();
                                  },
                                ),
                                text: "Start Over",
                                color: KColors.whiteColor,
                                textColor: KColors.blackColor,
                              ),
                              ButtonWidget(
                                onTap: () async {
                                  scannerNotifier.stopScanner();
                                  await Get.to(
                                    () => CheckoutView(
                                      scanningNotifier: scannerNotifier,
                                      scanningProvider: scanningProvider,
                                      productsList:
                                          scannerNotifier.productsList,
                                    ),
                                  );
                                  scannerNotifier.startScanner();
                                },
                                text: "Checkout",
                                color: KColors.primaryColor,
                                textColor: KColors.blackColor,
                              ),
                            ],
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
