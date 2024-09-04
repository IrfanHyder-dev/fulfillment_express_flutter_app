import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final TextAlign alignText;
  final int maxLines;
  final double? minFontSize;
  final bool ellipsisText;

  const CustomText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.alignText = TextAlign.center,
    this.maxLines = 1,
    this.ellipsisText = true,
    this.minFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignText,
      maxLines: maxLines,
      overflow: ellipsisText ? TextOverflow.ellipsis : null,
      style: textStyle,
    );
  }
}

enum FocusPosition { start, end }


