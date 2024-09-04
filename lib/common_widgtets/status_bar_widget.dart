import 'dart:io';
import 'package:express/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarWidget extends StatelessWidget {
  final Widget child;
  final Color statusBarColor;

  const StatusBarWidget(
      {Key? key, required this.child, this.statusBarColor = KColors.primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
      color: KColors.primaryColor,
      child: SafeArea(child: child,),
    )
        : AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: KColors.primaryColor,
        ),
        child: SafeArea(child: child));
  }
}