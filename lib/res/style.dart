import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/res/strings.dart';

import 'color.dart';

class BaseDecoration {}

class BaseTextStyle {
  static TextStyle get text700 => TextStyle(
    fontSize: 21.sp,
    color: color010103,
    fontWeight: FontWeight.w700,
    fontFamily: strFontName,
  );

  static TextStyle get text600 => TextStyle(
    fontSize: 15.sp,
    color: color010103,
    fontWeight: FontWeight.w600,
    fontFamily: strFontName,
  );

  static TextStyle get text500 => TextStyle(
    fontSize: 15.sp,
    color: color010103,
    fontWeight: FontWeight.w500,
    fontFamily: strFontName,
  );

  static TextStyle get text400 => TextStyle(
    fontSize: 15.sp,
    color: color010103,
    fontWeight: FontWeight.w400,
    fontFamily: strFontName,
  );

  static TextStyle get text300 => TextStyle(
    fontSize: 15.sp,
    color: color010103,
    fontWeight: FontWeight.w300,
    fontFamily: strFontName,
  );
}
