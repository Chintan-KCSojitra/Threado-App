import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../widget/text_widget.dart';
import '../res/color.dart';
import '../res/strings.dart';
import 'app_loader.dart';
import 'bounce_button.dart';

class CommonButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String? text;
  final String? stringAssetName;
  final GestureTapCallback? onTap;
  final bool showLoading, isShadow, isGradient;
  final Color? progressColor;
  final bool isIcon;
  final bool isTrailingIcon;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? assetHeight;
  final double? assetWidth;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double borderWidth;
  final double? borderRadius;
  final Widget? iconWidget;
  final String? iconName;
  final EdgeInsetsGeometry? buttonMargin, buttonPadding;

  const CommonButton({
    super.key,
    this.width,
    this.height,
    this.text,
    this.onTap,
    this.showLoading = false,
    this.textColor,
    this.progressColor,
    this.verticalPadding,
    this.stringAssetName,
    this.isIcon = false,
    this.assetWidth,
    this.assetHeight,
    this.fontSize,
    this.horizontalPadding,
    this.borderColor,
    this.borderRadius = 15,
    this.backgroundColor,
    this.borderWidth = 1.0,
    this.iconWidget,
    this.iconName,
    this.buttonMargin,
    this.isTrailingIcon = false,
    this.buttonPadding,
    this.isShadow = false,
    this.isGradient = false,
    this.fontWeight = FontWeight.w700,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: onTap,
      widget: Container(
        width: width,
        height: height ?? 54.h,
        padding: buttonPadding,
        decoration: BoxDecoration(
          color: backgroundColor ?? colorE7E3DA,
          borderRadius: BorderRadius.circular(borderRadius?.r ?? 15.r),
          border: Border.all(color: borderColor ?? Colors.transparent),
          boxShadow: isShadow
              ? [
                  BoxShadow(
                    color: shadowColor ?? colorE7E3DA,
                    offset: const Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 0.h,
            horizontal: horizontalPadding ?? 0.0,
          ),
          child: Center(
            child: showLoading
                ? AppLoader.small(
                    accentColor: progressColor ?? Colors.white,
                    trackColor: (progressColor ?? Colors.white)
                        .withValues(alpha: 0.28),
                  )
                : isIcon
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      iconWidget ?? SvgPicture.asset(iconName!),
                      SizedBox(width: 5.w),
                      TextWidget(
                        text: text,
                        fontSize: fontSize ?? 18.sp,
                        fontWeight: fontWeight ?? FontWeight.w800,
                        fontFamily: strFontName,
                        color: textColor ?? color010103,
                      ),
                    ],
                  )
                : TextWidget(
                    text: text,
                    fontSize: fontSize ?? 16.sp,
                    fontWeight: fontWeight ?? FontWeight.w700,
                    fontFamily: strFontName,
                    color: textColor ?? color010103,
                  ),
          ),
        ),
      ),
    );
  }
}
