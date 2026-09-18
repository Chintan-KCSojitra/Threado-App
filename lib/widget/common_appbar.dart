import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/strings.dart';
import '../../widget/text_widget.dart';
import '../res/color.dart';
import '../res/image.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title, leadingIc;
  final SvgPicture? iconImage;
  final String? prefixIconName, prefixIcon;
  final bool? shouldShowBackButton;
  final PreferredSizeWidget? bottom;
  final bool? isPrefixIcon;
  final Widget? leading;
  final Widget? prefixWidget;
  final bool automaticallyImplyLeading;
  final GestureTapCallback? onTapPrefix;
  final GestureTapCallback? onPressBack;
  final Color? statusBarColor, backgroundColor, textColor, navigationBarColor;
  final GestureTapCallback? onTapAction;
  final double? toolbarHeight, titleSpacing;
  final Brightness? statusBarIconBrightness;
  final Brightness? statusBarBrightness;
  final bool? centerTitle;
  final Widget? flexibleSpace;
  final Widget? titleWidget;

  const CommonAppBar({
    super.key,
    required this.title,
    this.shouldShowBackButton = true,
    this.bottom,
    this.isPrefixIcon,
    this.prefixIcon,
    this.prefixIconName,
    this.toolbarHeight,
    this.onTapPrefix,
    this.iconImage,
    this.onPressBack,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.statusBarColor,
    this.prefixWidget,
    this.backgroundColor,
    this.textColor,
    this.onTapAction,
    this.statusBarBrightness,
    this.centerTitle = true,
    this.flexibleSpace,
    this.titleSpacing,
    this.statusBarIconBrightness,
    this.titleWidget,
    this.leadingIc,
    this.navigationBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: colorWhite,
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarDividerColor: Colors.transparent,
          statusBarBrightness: statusBarBrightness ?? Brightness.light,
          statusBarColor: statusBarColor ?? Colors.transparent,
          statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
          systemNavigationBarColor: navigationBarColor ?? colorWhite,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: backgroundColor ?? Colors.white,
        shadowColor: colorBlack.withValues(alpha: 0.1),
        automaticallyImplyLeading: automaticallyImplyLeading,
        toolbarHeight: toolbarHeight ?? 55.h,
        title: Padding(
          padding: const EdgeInsets.only(top: 11),
          child: titleWidget ??
              TextWidget(
                  text: title,
                  color: textColor ?? colorBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  fontFamily: strFontName),
        ),
        titleSpacing: titleSpacing ?? 0,
        centerTitle: centerTitle,
        leading: (shouldShowBackButton ?? true)
            ? leading ??
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPressBack ??
                      () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
              child: Container(
                margin: const EdgeInsets.only(left: 16,top: 11),
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SvgPicture.asset(leadingIc ?? SVGImages.icArrowBack)),
              ),
            )
            : const Offstage(),
        leadingWidth: 50,
        actions: [
          prefixIconName != null
              ? Container(
            margin: EdgeInsets.only(right: 15.w),
            padding: const EdgeInsets.only(right: 5, left: 5, top: 25),
            child: TextWidget(
                text: prefixIconName, color: colorWhite, fontSize: 14.sp, onTap: onTapAction),
          )
              : prefixIcon != null
              ? GestureDetector(
            onTap: onTapAction,
            child: Container(
                margin: const EdgeInsets.only(right: 16),
                child: SvgPicture.asset(prefixIcon!)),
          )
              : prefixWidget ?? const SizedBox.shrink(),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Divider(
              height: 1,
              thickness: 1,
              color: colorE6E6E6,
            ),
          ),
        ),
        flexibleSpace: flexibleSpace,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 50.h);
}
