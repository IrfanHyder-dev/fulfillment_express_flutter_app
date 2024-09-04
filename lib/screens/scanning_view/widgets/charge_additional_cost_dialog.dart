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

class ChargeAdditionalCostDialog extends ConsumerStatefulWidget {
  AutoDisposeChangeNotifierProvider<ScanningNotifier> scanningProvider;
  String? productId;
  bool isEditProduct;


  ChargeAdditionalCostDialog({
    super.key,
    required this.scanningProvider,
    required this.isEditProduct,
    this.productId,
  });

  @override
  ConsumerState<ChargeAdditionalCostDialog> createState() =>
      _AddSkuQtyDialogState();
}

class _AddSkuQtyDialogState extends ConsumerState<ChargeAdditionalCostDialog> {
  String description = "Add Additional Cost";

  @override
  Widget build(BuildContext context) {
    final scannerNotifier = ref.watch(widget.scanningProvider);
    return Center(
      child: Wrap(
        children: [
          Container(
            // height: 165.h,
            child: Material(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: KColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Form(
                  key: scannerNotifier.additionalCostFormKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          maxLines: 1,
                          // text: "Current Stock Will Be Lost\nIf You Confirm",
                          text: description,
                          textStyle: KTextStyles().medium(
                            fontSize: 14.sp,
                            textColor: KColors.blackColor,
                            fontWeight: KTextStyles.mediumText,
                          ),
                        ),
                      ),
                      25.verticalSpace,
                      SizedBox(
                        height: 70.h,
                        width: 250.w,
                        child: InputFieldWidget(
                          label: 'Cost name',
                          showPadding: false,
                          controller: scannerNotifier.costNameController,
                          validator: (value) =>
                              scannerNotifier.additionCostFormValidator(value),
                        ),
                      ),
                      12.verticalSpace,
                      SizedBox(
                        height: 70.h,
                        width: 250.w,
                        child: InputFieldWidget(
                          label: 'Amount',
                          showPadding: true,
                          controller: scannerNotifier.amountController,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              scannerNotifier.additionCostFormValidator(value),
                        ),
                      ),
                      10.verticalSpace,
                      CustomText(
                        maxLines: 1,
                        // text: "Current Stock Will Be Lost\nIf You Confirm",
                        text: 'Tax name',
                        textStyle: KTextStyles().medium(
                            textColor: KColors.staticTextColor,
                            fontWeight: KTextStyles.normalText,
                            fontSize: 12),
                      ),
                      Row(
                        children: [
                          CustomText(
                            maxLines: 1,
                            text: 'Inclusive',
                            textStyle: KTextStyles().medium(
                              fontSize: 14.sp,
                              textColor: KColors.blackColor,
                              fontWeight: KTextStyles.normalText,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: Radio(
                              value: "Inclusive",
                              groupValue: scannerNotifier.taxName,
                              onChanged: (value) {
                                scannerNotifier.onTapRadioButton(value);
                              },
                              activeColor: KColors.primaryColor,
                            ),
                          ),
                          CustomText(
                            maxLines: 1,
                            text: 'Exclusive',
                            textStyle: KTextStyles().medium(
                              fontSize: 14.sp,
                              textColor: KColors.blackColor,
                              fontWeight: KTextStyles.normalText,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: Radio(
                              value: "Exclusive",
                              groupValue: scannerNotifier.taxName,
                              onChanged: (value) {
                                scannerNotifier.onTapRadioButton(value);
                              },
                              activeColor: KColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 36.h,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: KColors.primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                  child: CustomText(
                                text: "Cancel",
                                textStyle: KTextStyles()
                                    .medium(textColor: KColors.blackColor),
                              )),
                            ),
                          ),
                          20.horizontalSpace,
                          GestureDetector(
                            onTap: ()
                            {
                              FocusScope.of(context).unfocus();

                              if(widget.isEditProduct){
                                scannerNotifier.editAdditionalCostCharges(widget.productId!);
                              }
                              else{
                                scannerNotifier
                                    .onTapAdditionalDialogAddButton();
                              }
                            },
                            child: Container(
                              height: 36.h,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: KColors.primaryColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                  child: CustomText(
                                text: widget.isEditProduct? "Update":"Add",
                                textStyle: KTextStyles()
                                    .medium(textColor: KColors.blackColor),
                              )),
                            ),
                          ),
                        ],
                      ),
                      15.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
          ),
        ],
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
        labelText: 'Cost name',
        // label: Text('Mounim'),
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
