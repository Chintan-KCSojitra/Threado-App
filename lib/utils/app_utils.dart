import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thredo/main.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/strings.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/utils/shared_preference_util.dart';
import 'package:thredo/view/login/login_screen.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/text_widget.dart';

class AppUtils {
  AppUtils._privateConstructor();

  static final AppUtils instance = AppUtils._privateConstructor();

  static RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      SharedPreferenceUtil.putValue(deviceIdKey, iosDeviceInfo.identifierForVendor);
      return iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidId = await deviceInfo.androidInfo;
      return androidId.id;
    }
  }

  static String formatToAmPm({required String utcTime}) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parseUtc(utcTime).toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }

  bool _isShowingSessionExpiredDialog = false;

  void handleUnauthenticatedSession({String? message}) {
    if (_isShowingSessionExpiredDialog) return;

    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      logout();
      return;
    }

    _isShowingSessionExpiredDialog = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: colorBlack.withValues(alpha: 0.5),
      builder: (dialogContext) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.sizeOf(dialogContext).width * 0.85,
              padding: EdgeInsets.all(22.0.w),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(20.0.r),
                boxShadow: [
                  BoxShadow(color: colorBlack.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 54.0.w,
                    height: 54.0.w,
                    decoration: const BoxDecoration(color: Color(0xFFFFF3CD), shape: BoxShape.circle),
                    child: Icon(Icons.lock_outline_rounded, size: 28.0.sp, color: const Color(0xFF856404)),
                  ),
                  SizedBox(height: 16.0.h),
                  TextWidget(
                    text: 'Session Expired',
                    textAlign: TextAlign.center,
                    textStyle: BaseTextStyle.text700.copyWith(fontSize: 18.0.sp, color: color09064A),
                  ),
                  SizedBox(height: 8.0.h),
                  TextWidget(
                    text: message ?? 'Your session has expired. Please log in again to continue.',
                    textAlign: TextAlign.center,
                    textStyle: BaseTextStyle.text400.copyWith(fontSize: 13.0.sp, color: color79747E),
                  ),
                  SizedBox(height: 22.0.h),
                  SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      text: 'OK',
                      backgroundColor: const Color(0xFF09064A),
                      textColor: colorWhite,
                      onTap: () {
                        _isShowingSessionExpiredDialog = false;
                        Navigator.of(dialogContext, rootNavigator: true).pop();
                        logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isShowingSessionExpiredDialog = false;
    });
  }

  void logout() {
    _isShowingSessionExpiredDialog = false;
    SharedPreferenceUtil.putValue(kPrefIsLogin, false);
    SharedPreferenceUtil.putValue(kPrefDeviceToken, '');
    SharedPreferenceUtil.removeUserData();
    navigate(enterPage: const LoginScreen(), navigationType: NavigationType.pushAndClearStack);
  }

  void hideProgressDialog(BuildContext context) {
    navigate(navigationType: NavigationType.goBack);
  }

  String formatText(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }
}
