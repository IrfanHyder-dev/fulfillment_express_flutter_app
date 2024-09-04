import 'package:express/screens/checkout/notifier/checkout_notifier.dart';
import 'package:express/screens/checkout/view/custom_upload_btn_widget.dart';
import 'package:express/screens/scanning_view/model/common_model.dart';
import 'package:express/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../common_widgtets/custom_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';
import '../../scanning_view/widgets/row_text_widget.dart';

Widget totalTextWidget({checkoutNotifier}) {
  return CustomText(
      text:
          "ZAR ${Utils.formatCurrency(currency: checkoutNotifier.total.toString(), symbol: false)}",
      textStyle: KTextStyles().medium(
          textColor: KColors.blackColor,
          fontWeight: KTextStyles.mediumText,
          fontSize: 36.sp));
}

Widget askOperator({checkoutNotifier}) {
  return CustomText(
    text:
        "Please Ask Your Operator To Scan This Barcode \nTo Finalize This Purchases",
    maxLines: 2,
    textStyle: KTextStyles().medium(
      textColor: KColors.staticTextColor,
      fontWeight: KTextStyles.normalText,
      fontSize: 16.sp,
    ),
  );
}

Widget makeOfflinePayment(CheckoutNotifier checkoutNotifier) {
  return Column(
    children: [
      GestureDetector(
          onTap: () {
            checkoutNotifier.setShowingOfflinePaymentText();
          },
          child: customUploadBtnWidget(
              text: "Offline Payment instructions",
              icon: checkoutNotifier.showHtmlText
                  ?"assets/images/dropdown.svg":"assets/images/dropup.svg")),


      20.verticalSpace,
      if (checkoutNotifier.showHtmlText) htmlText(checkoutNotifier),
      CustomText(
        text: "Please Take Photo For Your Offline \n Proof Of Payment",
        maxLines: 2,
        textStyle: KTextStyles().medium(
          textColor: KColors.staticTextColor,
          fontWeight: KTextStyles.normalText,
          fontSize: 18.sp,
        ),
      ),
    ],
  );
}

Widget htmlText(CheckoutNotifier checkoutNotifier) {
  return checkoutNotifier.bankAccountHTML != null
      ? Container(
          margin: EdgeInsets.symmetric(vertical: 20.h),
          child: HtmlWidget('''
             ${checkoutNotifier.bankAccountHTML}
              '''),
        )
      : CustomText(
          maxLines: 2,
          text: "https://am.co.za/doc/express",
          textStyle: KTextStyles().medium(
            decoration: TextDecoration.underline,
            textColor: KColors.blackColor,
            fontWeight: FontWeight.w400,
          ),
        );
}

Widget customDivider(
    {Color color = KColors.primaryColor, double width = double.infinity}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20.h),
    height: 1,
    width: width,
    color: color,
  );
}

Widget productCardsWidget(
    {checkoutNotifier, List<CommonProductModel>? productList}) {
  return Column(
    children: [
      20.verticalSpace,
      Align(
        alignment: Alignment.topRight,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: KColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.transparent, // Top shadow (transparent)
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                // Bottom shadow color
                offset: Offset(0, 2),
                // Offset of the bottom shadow
                blurRadius: 4, // Spread of the bottom shadow
              ),
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().screenWidth,
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: 11.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: KColors.primaryColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RowTextWidget(
                  textColor: KColors.blackColor,
                  title: "Sub Total",
                  subtitle: Utils.formatCurrency(
                      currency: checkoutNotifier.subTotal.toString()),
                ),
                6.verticalSpace,
                RowTextWidget(
                  textColor: KColors.blackColor,
                  title: "VAT(15%)",
                  subtitle:
                      "${Utils.formatCurrency(currency: checkoutNotifier.vatPrice.toString())}",
                ),
                8.verticalSpace,
                Divider(color: KColors.greySeparatorColor, height: 0.05),
                10.verticalSpace,
                RowTextWidget(
                  textColor: KColors.blackColor,
                  textStyle: KTextStyles().medium(
                      textColor: KColors.blackColor,
                      fontWeight: KTextStyles.mediumText),
                  title: "Total",
                  subtitle: Utils.formatCurrency(
                      currency: checkoutNotifier.total.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
