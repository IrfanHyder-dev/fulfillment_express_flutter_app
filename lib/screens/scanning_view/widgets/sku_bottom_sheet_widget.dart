import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/screens/scanning_view/notifier/scanning_notifier.dart';
import 'package:express/screens/scanning_view/widgets/charge_additional_cost_dialog.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'add_sku_qty_dialog.dart';

class SkuBottomSheetWidget extends ConsumerStatefulWidget {
  AutoDisposeChangeNotifierProvider<ScanningNotifier> scanningProvider;

  SkuBottomSheetWidget({super.key, required this.scanningProvider});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SkuBottomSheetWidgetState();
}

class _SkuBottomSheetWidgetState extends ConsumerState<SkuBottomSheetWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(widget.scanningProvider).getLooseSkusProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scannerNotifier = ref.watch(widget.scanningProvider);

    return Container(
      height: 0.85.sh,
      child: scannerNotifier.loading
          ? Center(
              child: CircularProgressIndicator(
                color: KColors.primaryColor,
              ),
            )
          :(scannerNotifier.looseSkusProduct == null)?
          Center(child: Text('No sku found  ${scannerNotifier.looseSkusProduct}'))
      :Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: GestureDetector(
                        onTap: (){
                          buildAdditionalCostDialog(context);
                        },
                        child: Container(
                          height: 30.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: KColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                              child: CustomText(
                                text: "Charge Additional Cost",
                                textStyle: KTextStyles().medium(textColor: KColors.blackColor),
                              )),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      // color: Colors.red,
                      child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            color: KColors.redColor,
                          )),
                    ),
                  ],
                ),
                Expanded(
                  child: FadingEdgeScrollView.fromScrollView(
                    child: ListView.separated(
                      controller: scannerNotifier.skuListController,
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      itemCount:
                          scannerNotifier.looseSkusProduct!.looseSkus!.length,
                      itemBuilder: (context, index) {
                        var data =
                            scannerNotifier.looseSkusProduct!.looseSkus![index];
                        return InkWell(
                          onTap: () {
                            if (data.skuQty! > 0) {
                              buildShowGeneralDialog(context, index);
                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  (data.skuImage != null &&
                                          data.skuImage!.isNotEmpty)
                                      ? Image.network(data.skuImage!, width: 60)
                                      : SvgPicture.asset(
                                          "assets/images/image_placeholder_vector.svg",
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                  15.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CustomText(
                                              text: "SKU: ${data.sku ?? ""} ",
                                              textStyle: KTextStyles().medium(
                                                  fontSize: 14.sp,
                                                  textColor:
                                                      KColors.blackColor),
                                            ),
                                            Spacer(),
                                            CustomText(
                                              text: (data.price != null)
                                                  ? 'R${data.price!.toStringAsFixed(2)}'
                                                  : 'null',
                                              ellipsisText: false,
                                              alignText: TextAlign.start,
                                              maxLines: 1,
                                              textStyle: KTextStyles().medium(
                                                fontSize: 14.sp,
                                                fontWeight:
                                                    KTextStyles.mediumText,
                                                textColor: KColors.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        2.verticalSpace,
                                        CustomText(
                                          text:
                                              "Available Qty : ${data.skuQty ?? "0"}",
                                          ellipsisText: false,
                                          alignText: TextAlign.start,
                                          maxLines: 1,
                                          textStyle: KTextStyles().medium(
                                            fontSize: 14.sp,
                                            fontWeight: KTextStyles.normalText,
                                            textColor: KColors.blackColor,
                                          ),
                                        ),
                                        3.verticalSpace,
                                        CustomText(
                                          text: "${data.skuName ?? ""}",
                                          ellipsisText: true,
                                          alignText: TextAlign.start,
                                          maxLines: 1,
                                          textStyle: KTextStyles().medium(
                                            fontSize: 14.sp,
                                            fontWeight: KTextStyles.normalText,
                                            textColor: KColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(height: 5),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<Object?> buildShowGeneralDialog(BuildContext context, int index) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return AddSkuQtyDialog(
          index: index,
          scanningProvider: widget.scanningProvider,
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
  Future<Object?> buildAdditionalCostDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return ChargeAdditionalCostDialog(
          scanningProvider: widget.scanningProvider,
          isEditProduct: false,
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
