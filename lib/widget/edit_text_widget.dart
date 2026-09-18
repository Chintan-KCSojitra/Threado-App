
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../res/color.dart';
import '../res/strings.dart';

class TextEditingWidget extends StatelessWidget {
  final String? hint, initialValue, fontFamilyText, fontFamilyHint, counterText, prefixIconName;
  final Widget? prefixIcon;
  final Color? color, textColor;
  final Color? hintColor, prefixIcColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? readOnly;
  final TextAlign? textAlign;
  // final Widget? suffixIcon;
  final TextInputType? textInputType;
  final int? maxLines;
  final int? minLines;
  final bool? isDense, isFocusBorder;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapSuffixIcon;
  final double? height;
  final double? width;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool isShadowEnable;
  final bool enabled;
  final bool isBorderEnable;
  final FontWeight? fontWeightText;
  final FontWeight? fontWeightHint;
  final String? suffixIconName;
  final Widget? suffixIconWidget;
  final double? suffixIconHeight, suffixIconWidth;
  final bool passwordVisible;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool autoFocus;
  final bool expands;
  final double? fontSize, hintSize, borderRadius, contentPaddingHorizontal, contentPaddingVertical, textHeight;
  final BoxConstraints? prefixIconConstraints;
  final TextCapitalization textCapitalization;
  final TextStyle? counterStyle;
  final Color? focusedBorderColor, borderColor, suffixIconColor, cursorColor;

  const TextEditingWidget({
    super.key,
    this.hint,
    this.hintSize,
    this.enabled = true,
    this.expands = false,
    this.autoFocus = false,
    this.prefixIconConstraints,
    this.prefixIconName,
    this.prefixIcon,
    this.color,
    this.controller,
    this.focusNode,
    this.isFocusBorder,
    this.initialValue,
    this.readOnly,
    this.textAlign,
    // this.suffixIcon,
    this.textInputType,
    this.maxLines = 1,
    this.minLines,
    this.isDense,
    this.onTap,
    this.height,
    this.onFieldSubmitted,
    this.validator,
    this.maxLength,
    this.textInputAction,
    this.inputFormatters,
    this.width,
    this.hintColor,
    this.isBorderEnable = true,
    this.isShadowEnable = true,
    this.fontFamilyText,
    this.fontFamilyHint,
    this.fontWeightHint,
    this.fontWeightText,
    this.suffixIconName,
    this.suffixIconHeight,
    this.suffixIconWidth,
    this.onTapSuffixIcon,
    this.passwordVisible = false,
    this.suffixIconWidget,
    this.onChanged,
    this.onEditingComplete,
    this.counterText,
    this.borderRadius,
    this.fontSize,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.textCapitalization = TextCapitalization.words, //textCapitalization: TextCapitalization.words,
    this.prefixIcColor,
    this.textColor,
    this.cursorColor,
    this.counterStyle,
    this.focusedBorderColor,
    this.borderColor,
    this.suffixIconColor,
    this.textHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height /* ?? 56.h */,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius ?? 17.r)),
      child: Center(
        child: TextFormField(
          cursorColor: cursorColor ?? colorPrimary,
          autofocus: autoFocus,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          validator: validator,
          onTap: onTap,
          obscureText: passwordVisible,
          maxLength: maxLength,
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          initialValue: initialValue,
          readOnly: readOnly ?? false,
          maxLines: maxLines,
          minLines: minLines,
          textAlign: textAlign ?? TextAlign.left,
          keyboardType: textInputType,
          expands: expands,
          autocorrect: true,
          autovalidateMode: AutovalidateMode.always,
          showCursor: true,
          style: TextStyle(
            fontSize: fontSize ?? 16.sp,
            color: textColor ?? colorBlack,
            fontFamily: fontFamilyText ?? strFontName,
            fontWeight: fontWeightText ?? FontWeight.w400,
          ),
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            enabled: enabled,
            counterText: counterText ?? "",
            counterStyle: counterStyle,
            isDense: isDense ?? isDense,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: focusedBorderColor ?? colorPrimary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: borderColor ?? colorF2F2F2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: borderColor ?? colorF2F2F2),
            ),
            prefixIcon:
            prefixIconName != null
                ? Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 30.w,
                height: 30.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(10)),
                child: SvgPicture.asset(
                  prefixIconName!,
                  height: 17.h,
                  width: 17.w,
                  colorFilter: ColorFilter.mode(prefixIcColor ?? Colors.black, BlendMode.srcIn),
                ),
              ),
            )
                : prefixIcon,
            suffixIcon:
            suffixIconWidget ??
                (suffixIconName != null
                    ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTapSuffixIcon,
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: SvgPicture.asset(
                      suffixIconName!,
                      width: suffixIconWidth,
                      height: suffixIconHeight,
                      colorFilter: ColorFilter.mode(suffixIconColor ?? colorF2F2F2, BlendMode.srcIn),
                    ),
                  ),
                )
                    : null),

            hintText: hint,
            errorMaxLines: 2,
            contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingHorizontal ?? 18, vertical: contentPaddingVertical ?? 15),
            hintStyle: TextStyle(
              fontSize: hintSize ?? 15.sp,
              color: hintColor ?? colorBlack.withValues(alpha: 0.4),
              fontFamily: fontFamilyHint ?? strFontName,
              fontWeight: fontWeightHint ?? FontWeight.w400,
            ),
            filled: true,
            prefixIconConstraints: prefixIconConstraints,
            fillColor: color ?? colorFBFBFB,
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
