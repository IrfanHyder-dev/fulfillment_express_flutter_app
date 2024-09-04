import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/utils/asset_images.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/static_info.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewHeaderWidget extends StatelessWidget {
  const ViewHeaderWidget({
    required this.color,
    required this.textColor,
    required this.name,
    this.onLogin,
    this.onAdd,
    required this.showAddButton,
    super.key,
  });

  final Color color;
  final Color textColor;
  final String name;
  final onLogin;
  final onAdd;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetImages.guestUser,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            7.horizontalSpace,
            SizedBox(
              width: 170.w,
              //color: Colors.red,
              child: CustomText(
                ellipsisText: true,
                alignText: TextAlign.left,
                maxLines: 1,
                text: StaticInfo.isGuest ? "Shopping as Guest" : name,
                textStyle: KTextStyles().heading(
                  textColor: color,
                  fontWeight: KTextStyles.normalText,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onAdd,
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
                  text: "Add",
                  textStyle: KTextStyles().medium(textColor: textColor),
                )),
              ),
            ),
            10.horizontalSpace,
            GestureDetector(
              onTap: onLogin,
              child: Container(
                height: 36.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: KColors.primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                    child: StaticInfo.isGuest
                        ? CustomText(
                            text: "Login",
                            textStyle:
                                KTextStyles().medium(textColor: textColor),
                          )
                        : Row(
                            children: [
                              CustomText(
                                text: "Log out",
                                textStyle:
                                    KTextStyles().medium(textColor: textColor),
                              ),
                              10.horizontalSpace,
                              SvgPicture.asset(
                                AssetImages.logout,
                                height: 20.h,
                              ),
                            ],
                          )),
              ),
            ),
          ],
        ),
        Divider(
          color: color,
        ),
      ],
    );
  }
}
