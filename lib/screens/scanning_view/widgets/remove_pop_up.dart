import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemoveProductsPopUp extends StatelessWidget {
  const RemoveProductsPopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 7.h,horizontal: 10.w),
          width: 377.w,
          decoration: BoxDecoration(
            color: KColors.redColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Remove Is Permanent\t',
                    textStyle: KTextStyles().normal(
                      fontWeight: KTextStyles.semiBoldText,
                    ),
                  ),
                  CustomText(
                    text: 'You Cannot Undo',
                    textStyle: KTextStyles().normal(),
                  ),
                ],
              ),
              CustomText(
                ellipsisText: false,
                maxLines: 10,
                text:

                'If You Want To Take These Product Again You Have To Add Again.',
                textStyle: KTextStyles().normal(),
              ),
              CustomText(
                ellipsisText: false,
                maxLines: 10,
                text:

                'Please scan the item again to remove it.',
                textStyle: KTextStyles().normal(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        10.verticalSpace,
      ],
    );
  }
}
