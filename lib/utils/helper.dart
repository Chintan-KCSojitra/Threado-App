import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/color.dart';
import '../res/strings.dart';
import '../res/style.dart';
import '../widget/text_widget.dart';

String getDeviceTypeID() => Platform.isAndroid ? kAndroid : kIos;

String? getErrorMessage(final Object? error) => error is DioException
    ? error.type == DioExceptionType.connectionTimeout
          ? strCouldNotConnectToTheServer
          : error.error is SocketException
          ? strCheckInternetConnection
          : error.response != null && error.response!.data != null
          ? error.response!.data!['message'] as String?
          : strUnKnowError
    : strUnKnowError;

/* == Show Message ================================================ */
final toastification = Toastification();

void showMessage({required final String message, final String? type}) {
  toastification.dismissAll();
  toastification.show(
    title: TextWidget(
      text: message,
      textStyle: BaseTextStyle.text500.copyWith(fontSize: 12.sp),
      maxLines: 3,
    ),
    type: type == 'success' ? ToastificationType.success : ToastificationType.error,
    style: ToastificationStyle.flat,
    autoCloseDuration: const Duration(seconds: 2),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    borderSide: const BorderSide(width: 0),
    animationDuration: const Duration(milliseconds: 400),
    primaryColor: Colors.white,
    backgroundColor: type == 'success' ? Colors.green : Colors.red,
    foregroundColor: Colors.white,
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: false,
  );
}

/* == System UI ================================================ */

void setCustomSystemUIOverlayStyle({
  final Color? statusBarColor, // Background color of the status bar
  final Brightness? statusBarBrightness, // Controls status bar text brightness (iOS)
  final Brightness? statusBarIconBrightness, // Controls status bar icons brightness (Android)
  final Color? systemNavigationBarColor, // Background color of the navigation bar
  final Brightness? systemNavigationBarIconBrightness, // Icons color of the navigation bar
  final Color? systemNavigationBarDividerColor, // Color of the divider line on the navigation bar
  final bool? systemStatusBarContrastEnforced, // Whether to enforce contrast for the status bar
}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? Colors.transparent,
      statusBarBrightness: statusBarBrightness ?? Brightness.light,
      statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
      systemNavigationBarColor: systemNavigationBarColor ?? Colors.white,
      systemNavigationBarIconBrightness: systemNavigationBarIconBrightness ?? Brightness.dark,
      systemNavigationBarDividerColor: systemNavigationBarDividerColor ?? Colors.white,
      systemStatusBarContrastEnforced: systemStatusBarContrastEnforced ?? false,
    ),
  );
}

/* == Log Generator ================================================ */
void logError(final Object error, final StackTrace? stackTrace) {
  final errorMessage = _formatErrorMessage(error, stackTrace);
  debugPrint(errorMessage);
}

String _formatErrorMessage(final Object error, final StackTrace? stackTrace) {
  final stackTraceMessage = stackTrace != null ? stackTrace.toString() : 'No stack trace available';
  return '''
    ========================= ERROR =========================
    Error: $error
    StackTrace: 
    $stackTraceMessage
    ==========================================================
    ''';
}

/*-- Device Utils ------------------------------------*/

class DeviceUtils {
  static bool isAndroid() => Platform.isAndroid;

  static bool isIOS() => Platform.isIOS;

  static bool isLandscape(final BuildContext context) => MediaQuery.of(context).orientation == Orientation.landscape;

  static Size screenSize(final BuildContext context) => MediaQuery.of(context).size;

  static Future<String?> getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      AndroidDeviceInfo androidId = await deviceInfo.androidInfo;

      return Platform.isIOS ? iosDeviceInfo.identifierForVendor : androidId.id;
    } catch (e, stackTrace) {
      logError(e, stackTrace);
      return '-';
    }
  }

  static Future<String> get version async => (await PackageInfo.fromPlatform()).version; //App Version: 1.0.0

  static Future<String> get buildNumber async => (await PackageInfo.fromPlatform()).buildNumber; //Build Number: 1

  Future<Map<String, dynamic>> initPlatformState() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    return await _getDeviceInfo(deviceInfoPlugin);
  }

  Future<Map<String, dynamic>> _getDeviceInfo(final DeviceInfoPlugin deviceInfoPlugin) async {
    if (DeviceUtils.isAndroid()) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return {
        'version.sdkInt': androidInfo.version.sdkInt,
        'version.release': androidInfo.version.release,
        'brand': androidInfo.brand,
        'device': androidInfo.device,
        'id': androidInfo.id,
        'manufacturer': androidInfo.manufacturer,
        'model': androidInfo.model,
      };
    } else if (DeviceUtils.isIOS()) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return {
        'systemVersion': iosInfo.systemVersion,
        'model': iosInfo.model,
        'identifierForVendor': iosInfo.identifierForVendor,
      };
    }
    return {};
  }

  static bool isTablet(final BuildContext context) {
    final data = MediaQuery.of(context);
    return data.size.shortestSide >= 600 && data.devicePixelRatio < 2.5;
  }
}

/*-- Color Utils ------------------------------------*/

class ColorUtils {
  static Color fromHex(final String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/*---- Redirection ---------------------------------------------------*/
Future<void> redirectToAppStore(final String appId) async {
  final androidUrl = Uri.parse('market://details?id=$appId');
  final iosUrl = Uri.parse('https://apps.apple.com/app/id$appId');
  if (await launchUrl(androidUrl)) {
    await launchUrl(androidUrl);
  } else if (await launchUrl(iosUrl)) {
    await launchUrl(iosUrl);
  } else {}
}

String obfuscateEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2 || parts[0].isEmpty) return email;

  final local = parts[0];
  final domain = parts[1];

  String visible = local.length > 1 ? local.substring(0, 1) : '';
  String hidden = '*' * (local.length - 1);

  return '$visible$hidden@$domain';
}

void showSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = colorPrimary,
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
