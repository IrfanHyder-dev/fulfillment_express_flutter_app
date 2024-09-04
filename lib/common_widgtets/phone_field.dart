import 'dart:io';

import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneFieldWidget extends StatefulWidget {
  final TextEditingController? phoneController;
  final Function(PhoneNumber number)? onInputChanged;
  final Function(bool value)? onInputValidated;
  final PhoneNumber? initialValue;
  final bool enable;
  final Color fillColor;

  const PhoneFieldWidget(
      {Key? key,
      this.phoneController,
      this.onInputChanged,
      this.onInputValidated,
      this.initialValue,
      this.fillColor = KColors.whiteColor,
      this.enable = true})
      : super(key: key);

  @override
  State<PhoneFieldWidget> createState() => _PhoneFieldWidgetState();
}

class _PhoneFieldWidgetState extends State<PhoneFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: widget.onInputChanged,
      onInputValidated: widget.onInputValidated,
      textAlignVertical: TextAlignVertical.center,
      // spaceBetweenSelectorAndTextField: 0,

      cursorColor: KColors.staticTextColor,
      textStyle: KTextStyles().medium(
          textColor: KColors.staticTextColor,
          fontWeight: KTextStyles.normalText,
          fontSize: 14),
      searchBoxDecoration: InputDecoration(
        hintText: "Search Country",
        hintStyle: KTextStyles().medium(
            textColor: KColors.staticTextColor,
            fontWeight: KTextStyles.normalText,
            fontSize: 14),
        contentPadding: EdgeInsets.all(0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: KColors.staticTextColor),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: KColors.staticTextColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: KColors.primaryColor),
        ),
      ),
      inputDecoration: InputDecoration(
        hintText: "Enter Whatsapp Number",
        isCollapsed: true,
        prefixIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: KColors.staticTextColor,
        ),
        contentPadding: EdgeInsetsDirectional.symmetric(vertical: 24.h),
        hintStyle: KTextStyles().medium(
            textColor: KColors.staticTextColor,
            fontWeight: KTextStyles.normalText,
            fontSize: 14),
        prefixStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: KColors.staticTextColor,
            ),
        fillColor: widget.fillColor,
        filled: true,
        border: buildInputBorder(),
        enabledBorder: buildInputBorder(),
        errorBorder: buildInputBorder(),
        focusedBorder: buildInputBorder(showGradient: true),
        disabledBorder: buildInputBorder(),
      ),
      keyboardType: Platform.isIOS
          ? const TextInputType.numberWithOptions(signed: true, decimal: false)
          : TextInputType.number,
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        trailingSpace: false,
        leadingPadding: 20,
        setSelectorButtonAsPrefixIcon: true,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      initialValue: widget.initialValue,
      textFieldController: widget.phoneController,
      formatInput: false,
      inputBorder: InputBorder.none,
      textAlign: TextAlign.start,
      isEnabled: widget.enable,
      onSaved: (number) {},
    );
  }

  InputBorder buildInputBorder({bool showGradient = false}) {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: KColors.staticTextColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }
}
