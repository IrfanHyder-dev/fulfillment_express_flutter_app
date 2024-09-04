import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/common_widgtets/status_bar_widget.dart';
import 'package:express/common_widgtets/view_header_widget.dart';
import 'package:express/screens/checkout/notifier/checkout_notifier.dart';
import 'package:express/screens/checkout/view/zoom_photo_widget.dart';
import 'package:express/screens/scanning_view/model/common_model.dart';
import 'package:express/screens/scanning_view/notifier/scanning_notifier.dart';
import 'package:express/screens/scanning_view/widgets/custom_dialog.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/static_info.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:qr_bar_code/code/code.dart';
import 'check_out_widget.dart';
import 'custom_upload_btn_widget.dart';
import '../../scanning_view/widgets/products_widget.dart';

class CheckoutView extends ConsumerStatefulWidget {
  final List<CommonProductModel>? productsList;
  final ScanningNotifier scanningNotifier;
  final AutoDisposeChangeNotifierProvider<ScanningNotifier>? scanningProvider;

  CheckoutView(
      {super.key,
      this.productsList,
      required this.scanningNotifier,
      this.scanningProvider});

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  final checkoutProvider = ChangeNotifierProvider<CheckoutNotifier>((ref) {
    return CheckoutNotifier();
  });

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(checkoutProvider).initialize(widget.productsList);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    final checkoutNotifier = ref.watch(checkoutProvider);

    return StatusBarWidget(
      statusBarColor: KColors.primaryColor,
      child: WillPopScope(
        onWillPop: () async {
          checkoutNotifier.imageFile.isEmpty
              ? Get.back()
              : customDialog(
                  fontSize: 14.sp,
                  description:
                      "If you’ve paid, please contact the shopkeeper for a refund or to make another purchase.",
                  context: context,
                  onCancel: () {
                    print("cancel");
                    Get.back();
                  },
                  onConfirm: () {
                    print("confirm");
                    Get.back();
                    Get.back();
                  },
                );
          return false;
        },
        child: Scaffold(
          backgroundColor: KColors.whiteColor,
          body: SingleChildScrollView(
            controller: checkoutNotifier.scrollController,
            child: Container(
              // height: ScreenUtil().screenHeight-21,
              width: ScreenUtil().screenWidth,
              padding: EdgeInsets.symmetric(
                horizontal: hMargin,
                vertical: vMargin,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ViewHeaderWidget(
                    textColor: KColors.blackColor,
                    color: KColors.blackColor,
                    showAddButton: false,
                    onLogin: () {
                      checkoutNotifier.onLogin();
                    },
                    name: StaticInfo.userModel?.userName ?? "",
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 100.h,
                      maxHeight: 288.h,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: widget.productsList!.length,
                      itemBuilder: (context, index) {
                        return ProductsWidget(
                          isCheckout: true,
                          containerColor: KColors.whiteColor,
                          textColor: KColors.blackColor,
                          scanningProvider: widget.scanningProvider,
                          product: widget.productsList![index],
                        );
                      },
                    ),
                  ),
                  productCardsWidget(
                      checkoutNotifier: checkoutNotifier,
                      productList: widget.productsList),

                  40.verticalSpace,
                  totalTextWidget(checkoutNotifier: checkoutNotifier),
                  20.verticalSpace,
                  makeOfflinePayment(checkoutNotifier),
                  30.verticalSpace,
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              checkoutNotifier.getImageFromCamera();
                              backgroundApp = true;
                            },
                            child: customUploadBtnWidget(
                                text: "Take Photo for Proof of Payment",
                                icon: "assets/images/upload.svg")),
                        20.verticalSpace,
                        checkoutNotifier.imageLoading
                            ? Container(
                                padding: EdgeInsets.all(27),
                                width: 90,
                                height: 90,
                                child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      color: KColors.primaryColor,
                                    )),
                              )
                            : checkoutNotifier.imageFile.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      openAndZoomImageWithurl(
                                          context: context,
                                          url: checkoutNotifier
                                              .imageFile[checkoutNotifier
                                                      .imageFile.length -
                                                  1]
                                              .path);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        width: 100,
                                        height: 90,
                                        child: checkoutNotifier
                                                .imageFile.isNotEmpty
                                            ? Image.file(
                                                checkoutNotifier.imageFile[
                                                    checkoutNotifier
                                                            .imageFile.length -
                                                        1],
                                                fit: BoxFit.cover,
                                              )
                                            : Text(
                                                'No image captured'), // Display a message if no image has been captured
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                      ]),
                  20.verticalSpace,
                  // askOperator(),
                  Row(
                    children: [
                      Expanded(
                        child: customUploadBtnWidget(
                          textColor: KColors.whiteColor,
                          buttonColor: KColors.redColor,
                          text: "Back",
                          width: Get.width,
                          onTap: () => checkoutNotifier.imageFile.isEmpty
                              ? Get.back()
                              : customDialog(
                                  fontSize: 14.sp,
                                  description:
                                      "If you’ve paid, please contact the shopkeeper for a refund or to make another purchase.",
                                  context: context,
                                  onCancel: () {
                                    print("cancel");
                                    Get.back();
                                  },
                                  onConfirm: () {
                                    print("confirm");
                                    // scannerNotifier.onRemove();
                                    Get.back();
                                    Get.back();
                                  },
                                ),
                        ),
                      ),
                      if ((checkoutNotifier.guestUserId != null ||
                              !StaticInfo.isGuest) &&
                          checkoutNotifier.imageFile.isNotEmpty)
                        5.horizontalSpace,
                      if ((checkoutNotifier.guestUserId != null ||
                              !StaticInfo.isGuest) &&
                          checkoutNotifier.imageFile.isNotEmpty)
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(2.h),
                            decoration: BoxDecoration(
                              color: KColors.primaryColor,
                            ),
                            child: customUploadBtnWidget(
                              // isEnable: checkoutNotifier.isButtonEnable,
                              stroke: 4,
                              buttonColor: checkoutNotifier.loading
                                  ? KColors.whiteColor
                                  : KColors.primaryColor,
                              isLoading: checkoutNotifier.loading,
                              loaderColor: KColors.primaryColor,
                              text: "Submit",
                              width: Get.width,
                              onTap: () => checkoutNotifier.onCheckout(
                                  scanningNotifier: widget.scanningNotifier),
                            ),
                          ),
                        ),
                    ],
                  ),
                  30.verticalSpace,
                  if (StaticInfo.isGuest &&
                      checkoutNotifier.guestUserId == null &&
                      checkoutNotifier.imageFile.isNotEmpty)
                    CustomText(
                      maxLines: 2,
                      text:
                          "Please ask shopkeeper to scan barcode\nto confirm the order.",
                      textStyle: KTextStyles().medium(
                          textColor: KColors.blackColor,
                          fontWeight: FontWeight.w400),
                    ),
                  10.verticalSpace,
                  if (StaticInfo.isGuest &&
                      checkoutNotifier.guestUserId == null &&
                      checkoutNotifier.imageFile.isNotEmpty)
                    Center(
                      child: checkoutNotifier.barCodeLoading
                          ? Container(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: KColors.primaryColor,
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              height: 80.h,
                              width: 250.w,
                              alignment: Alignment.center,
                              child: Code(
                                drawText: false,
                                data: checkoutNotifier.barcodeModel?.code ?? "",
                                codeType: CodeType.codeBar(),
                              ),
                            ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
