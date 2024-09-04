import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/common_widgtets/inputfield_widget.dart';
import 'package:express/screens/scanning_view/notifier/scanning_notifier.dart';
import 'package:express/screens/scanning_view/widgets/button_widget.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddSkuQtyDialog extends ConsumerStatefulWidget {
  AutoDisposeChangeNotifierProvider<ScanningNotifier> scanningProvider;
  final int index;

  AddSkuQtyDialog({
    super.key,
    required this.scanningProvider,
    required this.index,
  });

  @override
  ConsumerState<AddSkuQtyDialog> createState() => _AddSkuQtyDialogState();
}

class _AddSkuQtyDialogState extends ConsumerState<AddSkuQtyDialog> {
  String description = "Add Quantity";

  @override
  Widget build(BuildContext context) {
    final scannerNotifier = ref.watch(widget.scanningProvider);
    return Center(
      child: Container(
        height: 165.h,
        child: Material(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: KColors.primaryColor,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                10.verticalSpace,
                CustomText(
                  maxLines: 1,
                  // text: "Current Stock Will Be Lost\nIf You Confirm",
                  text: description,
                  textStyle: KTextStyles().medium(
                    fontSize: 14.sp,
                    textColor: KColors.blackColor,
                    fontWeight: KTextStyles.mediumText,
                  ),
                ),
                25.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      quantityTextField(
                          context, scannerNotifier.quantityController),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          print(
                              '-------------------------------- ${scannerNotifier.quantityController.text}');
                          if (scannerNotifier
                              .quantityController.text.isNotEmpty) {
                            scannerNotifier.setQuantityOfLooseSku(
                                index: widget.index,
                                quantity: int.parse(
                                    scannerNotifier.quantityController.text ??
                                        ''));
                          }
                        },
                        child: Container(
                          child: Center(
                              child: Icon(
                            Icons.check,
                            color: KColors.primaryColor,
                          )),
                        ),
                      ),
                      5.horizontalSpace,
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          child: Center(
                              child: Icon(
                            Icons.close,
                            color: KColors.redColor,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                if (scannerNotifier.showQuantityError)
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                        text:scannerNotifier.dialogErrorMsg,
                            // 'Quantity must be less or equal to ${scannerNotifier.looseSkusProduct?.looseSkus![widget.index].skuQty}',
                        textStyle: KTextStyles().medium(
                          fontSize: 12.sp,
                          textColor: KColors.redColor,
                          fontWeight: KTextStyles.mediumText,
                        )),
                  )
              ],
            ),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}

Widget quantityTextField(
    BuildContext context, TextEditingController quantityController) {
  return Container(
    margin: EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(),
      // color: Colors.pink,
    ),
    alignment: Alignment.center,
    width: 200.w,
    height: 45.h,
    child: TextFormField(
      controller: quantityController,
      expands: true,
      minLines: null,
      maxLines: null,
      maxLength: 5,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: "",
        counterText: "",
        contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
        hintStyle: KTextStyles().medium(
            textColor: KColors.staticTextColor,
            fontWeight: KTextStyles.normalText,
            fontSize: 14),
        labelStyle: KTextStyles().medium(
            textColor: KColors.staticTextColor,
            fontWeight: KTextStyles.normalText,
            fontSize: 14),
        filled: false,
        fillColor: Theme.of(context).primaryColorLight,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        prefixIconConstraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.width * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    ),
  );
}
