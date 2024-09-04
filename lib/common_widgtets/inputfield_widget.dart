import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputFieldWidget extends StatefulWidget {
  final String? hint;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(String value)? onChange;
  final IconData? prefixIcon;
  final String? prefixImage;
  final TextEditingController? controller;
  final int? maxLines;
  final TextInputType keyboardType;
  final bool obscure;
  final bool enable;
  final bool textAlignCenter;
  final bool isSvg;
  final bool showPadding;
  final bool showPaddingForSearch;
  final String? label;
  final bool showDropArrow;
  final bool showBorder;
  final bool isFill;
  final bool showUnderLineBorder;
  final Widget? suffixWidget;
  final bool showObscureByText;
  final int? maxLength;
  final bool isCoupon;
  final FormFieldValidator<String?>? validator; // add this line
  final List<TextInputFormatter>? inputFormatter;
  final Widget? prefixWidget;
  final Color? borderColor;
  final String? buttonText;
  final double borderRadius;
  final void Function(String value)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const InputFieldWidget(
      {Key? key,
      this.focusNode,
      this.hint,
      this.prefixIcon,
      this.prefixImage,
      this.controller,
      this.maxLines = 1,
      this.isCoupon = false,
      this.onTap,
      this.buttonText = '',
      this.keyboardType = TextInputType.text,
      this.obscure = false,
      this.enable = true,
      this.textAlignCenter = false,
      this.onChange,
      this.isSvg = false,
      this.showPaddingForSearch = false,
      this.showPadding = false,
      this.label,
      this.showDropArrow = false,
      this.showBorder = true,
      this.isFill = false,
      this.showUnderLineBorder = false,
      this.suffixWidget,
      this.showObscureByText = false,
      this.validator,
      this.inputFormatter,
      this.maxLength,
      this.prefixWidget,
      this.borderColor,
      this.onFieldSubmitted,
      this.textInputAction,
      this.borderRadius = 4})
      : super(key: key);

  @override
  _InputFieldWidgetState createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      focusNode: widget.focusNode,
      cursorColor: KColors.staticTextColor,
      style: KTextStyles().medium(
          textColor: KColors.staticTextColor,
          fontWeight: KTextStyles.normalText,
          fontSize: 14),
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onChanged: widget.onChange,
      validator: widget.validator,
      enabled: widget.enable,
      controller: widget.controller,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      textAlign:
          widget.textAlignCenter == true ? TextAlign.center : TextAlign.start,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatter??null,

          // : widget.inputFormatter,
      textAlignVertical: TextAlignVertical.center,
      obscureText: widget.obscure ? obscure : widget.obscure,
      decoration: InputDecoration(
        hintText: widget.hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,

        counter: Offstage(),
        labelText: widget.label,
        contentPadding: widget.showPadding
            ? const EdgeInsets.symmetric(horizontal: 22, vertical: 18)
            : widget.showPaddingForSearch
                ? EdgeInsets.only(right: 42, left: 20)
                : null,
        hintStyle: KTextStyles().medium(
            textColor: KColors.staticTextColor,
            fontWeight: KTextStyles.normalText,
            fontSize: 14),
        labelStyle: KTextStyles().medium(
            textColor: KColors.staticTextColor,
            fontWeight: KTextStyles.normalText,
            fontSize: 14),
        filled: widget.isFill,
        fillColor: Theme.of(context).primaryColorLight,
        border: buildUnderlineInputBorder(),
        enabledBorder: buildUnderlineInputBorder(),
        errorBorder: buildUnderlineInputBorder(),
        focusedBorder: buildUnderlineInputBorder(),
        disabledBorder: buildUnderlineInputBorder(),
        focusedErrorBorder: buildUnderlineInputBorder(),
        prefixIconConstraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.width * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        prefixIcon: widget.prefixWidget != null
            ? widget.prefixWidget
            : widget.prefixIcon != null
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      widget.prefixIcon,
                      color: KColors.staticTextColor,
                    ),
                  )
                : widget.prefixImage != null
                    ? Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(left: 15, right: 10),
                        child: widget.isSvg
                            ? SvgPicture.asset(
                                widget.prefixImage!,
                                colorFilter: ColorFilter.mode(KColors.staticTextColor, BlendMode.srcIn),

                                width: 20,
                              )
                            : Image.asset(
                                widget.prefixImage!,
                                color: KColors.staticTextColor,
                              ))
                    : null,
        // suffix: widget.suffixWidget,
        suffixIcon: widget.showObscureByText
            ? widget.isCoupon == true
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 1,
                        height: 15,
                        color: Color(0xffc1c1c1),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: widget.onTap,
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              color: KColors.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Color(0xffc1c1c1))),
                          child: Text(widget.buttonText!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.white,
                                  )),
                        ),
                      ),
                    ],
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 1,
                          height: 15,
                          color: Color(0xffc1c1c1),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(obscure ? "Show" : "Hide",
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Color(0xffc1c1c1),
                                    )),
                      ],
                    ))
            : widget.suffixWidget ??
                (widget.showDropArrow
                    ? const Icon(
                        Icons.arrow_drop_down_outlined,
                        // color: BaseTheme.lightThemeIconColor,
                      )
                    : !widget.obscure
                        ? null
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            child: Icon(
                              obscure ? Icons.visibility : Icons.visibility_off,
                              // color: BaseTheme.lightThemeIconColor,
                              size: 23,
                            ),
                          )),
      ),
    );
  }

  InputBorder buildUnderlineInputBorder() {
    return OutlineInputBorder(
                borderSide: BorderSide(
                  color: KColors.staticTextColor,
                  // color: isDarkMode() ? dBorderColor : lBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              );
  }
}
