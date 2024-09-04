import 'package:express/common_widgtets/phone_field.dart';
import 'package:express/common_widgtets/status_bar_widget.dart';
import 'package:express/screens/checkout/view/check_out_widget.dart';
import 'package:express/screens/checkout/view/custom_upload_btn_widget.dart';
import 'package:express/screens/order/model/orders_model.dart';
import 'package:express/screens/order/notifier/order_notifier.dart';
import 'package:express/screens/scanning_view/view/scanning_view.dart';
import 'package:express/screens/scanning_view/widgets/custom_dialog.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/global_constant.dart';
import 'package:express/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../common_widgtets/custom_text.dart';
import '../../../common_widgtets/inputfield_widget.dart';
import '../../../utils/styles.dart';
import 'confirmation_order_no_widget.dart';
import 'order_view_widgets.dart';

class OrderView extends ConsumerStatefulWidget {
  OrderView({
    required this.ordersModel,
    required this.totalPrice,
    super.key,
  });

  final OrderModel ordersModel;
  final double totalPrice;

  @override
  ConsumerState<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends ConsumerState<OrderView> {
  final orderProvider = ChangeNotifierProvider<OrderNotifier>((ref) {
    return OrderNotifier();
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderNotifier = ref.watch(orderProvider);
    return StatusBarWidget(
      child: Scaffold(
        backgroundColor: KColors.whiteColor,
        body: SingleChildScrollView(
          controller: orderNotifier.scrollController,
          child: Container(
            width: ScreenUtil().screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: hMargin,
              vertical: vMargin,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                40.verticalSpace,
                headerImageWidget(),
                40.verticalSpace,
                confirmOrderNoWidget(
                  orderNo:
                      widget.ordersModel.data?.order?.orderNo.toString() ?? "",
                  totalAmount: Utils.formatCurrency(
                    currency: widget.totalPrice.toString(),
                    symbol: false,
                  ),
                ),
                40.verticalSpace,
                CustomText(
                  text: "Do you want an Invoice?",
                  textStyle: KTextStyles().medium(
                    textColor: KColors.blackColor,
                    fontWeight: KTextStyles.mediumText,
                    fontSize: 18.sp,
                  ),
                ),
                customDivider(color: KColors.greySeparatorColor, width: 110.w),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    children: [
                      CustomText(
                        text:
                            "Please Enter Your Email Or WhatsApp Number So We Can Send It To You",
                        maxLines: 3,
                        textStyle: KTextStyles().medium(
                          textColor: KColors.staticTextColor,
                          fontWeight: KTextStyles.normalText,
                          fontSize: 16.sp,
                        ),
                      ),
                      80.verticalSpace,
                      InputFieldWidget(
                        prefixImage: "assets/images/sms.svg",
                        isSvg: true,
                        controller: orderNotifier.emailController,
                        keyboardType: TextInputType.emailAddress,
                        hint: "Enter Email",
                        borderRadius: 3,
                        onChange: (val) => orderNotifier.enableButton(),
                      ),
                      15.verticalSpace,
                      PhoneFieldWidget(
                        initialValue: orderNotifier.initialValue,
                        phoneController: orderNotifier.phoneNumberController,
                        onInputChanged: (val) {
                          orderNotifier.initialValue = val;
                        },
                      ),
                      20.verticalSpace,
                      customUploadBtnWidget(
                          loaderColor: KColors.whiteColor,
                          isLoading: orderNotifier.loading,
                          onTap: () => orderNotifier.onSubmit(
                              orderNumber:
                                  widget.ordersModel.data?.order?.orderNo ??
                                      ""),
                          width: Get.width,
                          text: "Submit"),
                    ],
                  ),
                ),
                20.verticalSpace,
                if (orderNotifier.invoiceShowed)
                  CustomText(
                    ellipsisText: false,
                    maxLines: 3,
                    text: orderNotifier.successMessage.toString() ?? "",
                    textStyle: KTextStyles().heading(
                      textColor: KColors.blackColor,
                    ),
                  ),
                if (orderNotifier.invoiceShowed) 5.verticalSpace,
                if (orderNotifier.invoiceShowed)
                  CustomText(
                    ellipsisText: false,
                    maxLines: 6,
                    text:
                        "You can now close the app if you've finished shopping, or update your email or WhatsApp number if you wish to make changes. Alternatively, you can simply click the Continue Shopping button below to add more items to your cart.",
                    textStyle: KTextStyles().normal(
                      textColor: KColors.blackColor,
                      fontSize: 16.sp,
                    ),
                  ),
                60.verticalSpace,
                customUploadBtnWidget(
                    onTap: () => orderNotifier.invoiceShowed
                        ? Get.offAll(() => BarcodeScanner())
                        : customDialog(
                            description:
                                "Are you sure?\nYou don't want an invoice",
                            context: context,
                            onCancel: () {
                              Get.back();
                            },
                            onConfirm: () {
                              Get.offAll(() => BarcodeScanner());
                            },
                          ),
                    buttonColor: KColors.whiteColor,
                    width: Get.width,
                    text: "Continue Shopping",
                    isFromShopping: true),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
