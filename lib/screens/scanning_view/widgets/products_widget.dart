import 'package:cached_network_image/cached_network_image.dart';
import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/screens/scanning_view/model/common_model.dart';
import 'package:express/screens/scanning_view/notifier/scanning_notifier.dart';
import 'package:express/screens/scanning_view/widgets/charge_additional_cost_dialog.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/styles.dart';
import 'package:express/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductsWidget extends ConsumerWidget {
  ProductsWidget(
      {required this.containerColor,
      required this.textColor,
      required this.product,
      this.isCheckout = false,
      this.scanningProvider,
      super.key});

  final CommonProductModel product;

  // final ProductsModel product;
  final bool isCheckout;
  final containerColor;
  final textColor;
  AutoDisposeChangeNotifierProvider<ScanningNotifier>? scanningProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannerNotifier = ref.watch(scanningProvider!);
    return GestureDetector(
      onTap: (){
        if(product.productType == ProductType.additionalCost){
          print('==================================> tap on card');
          scannerNotifier.amountController.text = product.amount.toString();
          scannerNotifier.costNameController.text = product.costName ?? '';
          scannerNotifier.taxName = product.texName ?? '';

          buildAdditionalCostDialog(context: context,productID: product.id!);

        }
      },
      child: Container(
        alignment: Alignment.center,
        // height: 75,
        margin: EdgeInsetsDirectional.only(
            bottom: (scannerNotifier.removeMode) ? 20.h : 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: containerColor,
          boxShadow: [
            BoxShadow(
              color: Colors.transparent, // Top shadow (transparent)
            ),
            BoxShadow(
              color: isCheckout
                  ? Colors.grey.withOpacity(0.6)
                  : Colors.transparent, // Bottom shadow color
              offset: Offset(0, 2), // Offset of the bottom shadow
              blurRadius: 4, // Spread of the bottom shadow
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 70,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      child: product.skuImage != null
                          ? CachedNetworkImage(
                              imageUrl: product.skuImage ?? "",
                              // product.data?.item.itemSku.skuImage!=null?CachedNetworkImage(
                              //   imageUrl: product.data?.item.itemSku.skuImage ?? "",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/images/image_placeholder_vector.svg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/images/image_placeholder_vector.svg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/image_placeholder_vector.svg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                (product.productType == ProductType.additionalCost)
                    ? Expanded(
                        flex: 8,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Cost Name: ${product.costName ?? ""} ",
                                textStyle: KTextStyles().medium(
                                    textColor: textColor, fontSize: 14.sp),
                              ),
                              2.verticalSpace,
                              CustomText(
                                text: "Amount: ${product.amount ?? ""} ",
                                textStyle: KTextStyles().medium(
                                    textColor: textColor, fontSize: 14.sp),
                              ),
                              2.verticalSpace,
                              CustomText(
                                text: "Tax Name: ${product.texName ?? ""} ",
                                textStyle: KTextStyles().medium(
                                    textColor: textColor, fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ))
                    : Expanded(
                        flex: 8,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "SKU: ${product.sku ?? ""} ",
                                    textStyle: KTextStyles().medium(
                                        textColor: textColor, fontSize: 14.sp),
                                  ),
                                  CustomText(
                                    text: Utils.formatCurrency(
                                        currency: product.price.toString() ?? ""),
                                    ellipsisText: false,
                                    alignText: TextAlign.start,
                                    maxLines: 1,
                                    textStyle: KTextStyles().medium(
                                      fontSize: 14.sp,
                                      fontWeight: KTextStyles.mediumText,
                                      textColor: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              2.verticalSpace,
                              (product.productType == ProductType.looseSkuProduct)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text:
                                              "Unit Price: ${Utils.formatCurrency(currency: product.unitPrice.toString() ?? "")} ",
                                          textStyle: KTextStyles().medium(
                                              textColor: textColor,
                                              fontSize: 14.sp),
                                        ),
                                        CustomText(
                                          text: 'x ${product.quantity}',
                                          ellipsisText: false,
                                          alignText: TextAlign.start,
                                          maxLines: 1,
                                          textStyle: KTextStyles().medium(
                                            fontSize: 14.sp,
                                            fontWeight: KTextStyles.mediumText,
                                            textColor: textColor,
                                          ),
                                        ),
                                      ],
                                    )
                                  : CustomText(
                                      text:
                                          "Barcode : ${product.barcodeIds.toString()}",
                                      ellipsisText: false,
                                      alignText: TextAlign.start,
                                      maxLines: 1,
                                      textStyle: KTextStyles().medium(
                                        fontSize: 14.sp,
                                        fontWeight: KTextStyles.normalText,
                                        textColor: textColor,
                                      ),
                                    ),
                              3.verticalSpace,
                              Container(
                                child: CustomText(
                                  alignText: TextAlign.left,
                                  text: (product.skuName != null)
                                      ? product.skuName.toString()
                                      : "Loose SKU product",
                                  // text: product.data?.item.itemSku.skuName.toString() ?? "",
                                  maxLines: 2,
                                  ellipsisText: true,
                                  textStyle: KTextStyles().medium(
                                    fontSize: 14.sp,
                                    fontWeight: KTextStyles.normalText,
                                    textColor: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
            if (scannerNotifier.removeMode &&
                (product.productType == ProductType.looseSkuProduct ||
                    product.productType == ProductType.additionalCost))
              Positioned(
                  top: -10,
                  left: -10,
                  child: GestureDetector(
                    onTap: () {
                      scannerNotifier.removeSkusProduct(product.id!);
                    },
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 25.h,
                        width: 25.w,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: KColors.staticTextColor, width: 1),
                            shape: BoxShape.circle,
                            color: KColors.redColor,
                          ),
                          child: Center(
                              child: Icon(
                            Icons.close,
                            color: KColors.primaryColor,
                            size: 15,
                          )),
                        ),
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }

  Future<Object?> buildAdditionalCostDialog({required BuildContext context, required String productID}) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return ChargeAdditionalCostDialog(
          scanningProvider:scanningProvider!,
          isEditProduct: true,
          productId: productID,
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
