import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thredo/utils/shared_preference_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../res/color.dart';
import '../res/strings.dart';
import '../view/login/login_screen.dart';
import '../widget/app_loader.dart';
import 'navigation_utils.dart';

class AppUtils<T> {
  AppUtils._privateConstructor();

  static final AppUtils instance = AppUtils._privateConstructor();

  //static RegExp regExpEmail = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
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

  /*  static String formatToAmPm({required String utcTime}) {
    DateTime dateTime;

    if (utcTime.endsWith("Z")) {
      // Parse as UTC
      dateTime = DateTime.parse(utcTime).toLocal();
    } else {
      // Parse as local
      dateTime = DateTime.parse(utcTime);
    }

    return DateFormat('hh:mm a').format(dateTime);
  }*/

  /*static String formatToAmPm({required String utcTime}) {
    DateTime dateTime = DateTime.parse(utcTime).toUtc().toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }*/

  /*void logout() {
    SharedPreferenceUtil.putValue(isLoginKey, false);
    SharedPreferenceUtil.putValue(tokenKey, '');
    SharedPreferenceUtil.removeUserData();
    navigate(enterPage: const LoginScreen(), navigationType: NavigationType.pushAndClearStack);
  }*/

  Widget commonLoader({double? size, Color? color}) {
    return AppLoader.centered(size: size ?? 50, accentColor: color ?? colorCEAB8D);
  }

  String getErrorMessage(dynamic error) {
    return error is DioException
        ? error.type == DioExceptionType.connectionTimeout
              ? strCouldNotConnectToTheServer
              : error.error is SocketException
              ? strCheckInternetConnection
              : error.response != null && error.response!.data != null
              ? error.response!.data!['message']
              : 'An unknown error occurred'
        : 'An unknown error occurred';
  }

  void launchEmail(String sEmail) async {
    String email = 'mailto:$sEmail';
    Uri emailUrl = Uri.parse(email);
    if (await launchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    } else {
      throw 'Could not launch $email';
    }
  }

  Future<T?> get showLoadingDialog {
    return showDialog(
      context: rootNavigatorKey.currentContext!,
      builder: (_) => PopScope(
        onPopInvokedWithResult: (value, result) {},
        canPop: false,
        child: Dialog(backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, child: commonLoader()),
      ),
    );
  }

  void goBack() {
    Navigator.pop(rootNavigatorKey.currentContext!);
  }

  /*static void openCountryPickerDialog(BuildContext context, void Function(Country) onSelect) {
    FocusScope.of(context).requestFocus(FocusNode());
    showCountryPicker(
      useSafeArea: true,
      context: context,
      showPhoneCode: true,
      onSelect: onSelect,
      moveAlongWithKeyboard: false,
      countryListTheme: CountryListThemeData(
        backgroundColor: ThemeColors.getBackgroundColor(),
        bottomSheetHeight: 600.h,
        textStyle: TextStyle(color: ThemeColors.getPrimaryTextColor()),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        inputDecoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: ThemeColors.getTextFieldBorderColor()),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: ThemeColors.getTextFieldBorderColor()),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: ThemeColors.getTextFieldBorderColor()),
          ),
          labelText: strSearch,
          hintText: strStartTypingToSearch,
          prefixIcon: const Icon(Icons.search),
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: ThemeColors.getTextFieldBorderColor().withValues(alpha: 0.4),
            fontFamily: strFontName,
            fontWeight: FontWeight.w400,
          ),
        ),
        */ /*inputDecoration: InputDecoration(
          labelText: strSearch,
          hintText: strStartTypingToSearch,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderSide: BorderSide(color: ThemeColors.getPrimaryTextColor().withValues(alpha: 0.2))),
        ),*/ /*
        searchTextStyle: TextStyle(color: ThemeColors.getPrimaryTextColor(), fontSize: 18),
      ),
    );
  }*/

  void logout() {
    SharedPreferenceUtil.putValue(kPrefIsLogin, false);
    SharedPreferenceUtil.putValue(kPrefDeviceToken, '');
    SharedPreferenceUtil.removeUserData();
    navigate(enterPage: const LoginScreen(), navigationType: NavigationType.pushAndClearStack);
  }

  /*void showProgressDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: ThemeColors.getBackgroundColor(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: ThemeColors.getButtonBackgroundColor()),
              const SizedBox(height: 20),
              TextWidget(
                text: message ?? 'Please wait...',
                textStyle: BaseTextStyle.text500
                    .copyWith(fontSize: 16.sp, color: ThemeColors.getPrimaryTextColor()),
              )
            ],
          ),
        ),
      ),
    );
  }*/

  void hideProgressDialog(BuildContext context) {
    navigate(navigationType: NavigationType.goBack);
    // Navigator.of(context, rootNavigator: true).pop();
  }

  String formatText(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }
}

/*void showError({String? message, Color? messageColor, double textScaleFactor = 1.0}) => Fluttertoast.showToast(
      msg: message.toString(),
      // backgroundColor: messageColor ?? colorFF0000,
      backgroundColor: Colors.red,
      gravity: ToastGravity.TOP,
      fontSize: 12.0 * textScaleFactor,
    );*/
