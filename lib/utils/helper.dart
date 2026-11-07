import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import '../res/strings.dart';
import '../res/style.dart';
import '../widget/text_widget.dart';

String getDeviceTypeID() => Platform.isAndroid ? kAndroid : kIos;

String? getErrorMessage(final Object? error) {
  if (error == null) return strUnKnowError;
  if (error is DioException) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return strCouldNotConnectToTheServer;
    }
    if (error.error is SocketException) {
      return strCheckInternetConnection;
    }
    if (error.response != null && error.response!.data is Map) {
      final map = error.response!.data as Map;
      final msg = map['detail']?.toString() ?? map['message']?.toString();
      if (msg != null && msg.trim().isNotEmpty) return msg;
    }
    return strUnKnowError;
  }
  if (error is Exception) {
    final msg = error.toString().replaceAll('Exception: ', '').trim();
    if (msg.isNotEmpty) return msg;
  }
  final str = error.toString().trim();
  return str.isNotEmpty ? str : strUnKnowError;
}

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
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: false,
  );
}

/* == System UI ================================================ */
