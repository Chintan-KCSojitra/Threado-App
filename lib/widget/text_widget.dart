import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../res/color.dart';
import '../res/strings.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? textHeight;
  final TextStyle? textStyle;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;

  const TextWidget({
    super.key,
    this.text,
    this.color = color010103,
    this.fontSize,
    this.fontFamily = strFontName,
    this.letterSpacing,
    this.textAlign,
    this.onTap,
    this.fontWeight = FontWeight.normal,
    this.textOverflow,
    this.maxLines,
    this.textHeight,
    this.textStyle,
    this.decoration,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        text!,
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: true,
        textScaler: const TextScaler.linear(1),
        overflow: textOverflow,
        style:
            textStyle ??
            TextStyle(
              color: color,
              height: textHeight,
              fontSize: fontSize ?? 14.sp,
              letterSpacing: letterSpacing,
              decoration: decoration,
              fontFamily: fontFamily ?? strFontName,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
            ),
      ),
    );
  }
}
