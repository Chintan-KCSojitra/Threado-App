import 'dart:developer' as dev;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ExtendedString on String {
  //String get capitalized => substring(0, 1).toUpperCase() + substring(1).toLowerCase();

  void get toLog => dev.log(this);

  String get capitalized {
    if (isEmpty) return ""; // ✅ prevent RangeError
    return this[0].toUpperCase() + substring(1);
  }

  String get currencyFormat => NumberFormat.simpleCurrency(locale: 'EN-us').format(double.parse(this));

  /*String get currencyFormat {
    return NumberFormat.simpleCurrency(locale: 'es_ES').format(double.parse(this));
  }*/

  String get currencyFormatWith2Precession => NumberFormat.simpleCurrency(
        locale: 'EN-us',
      ).format(double.parse(this));

  NetworkImage get toNetworkImage => NetworkImage(this);

  AssetImage get toAssetImage => AssetImage(this);

  CachedNetworkImageProvider get toCachedNetworkImage => CachedNetworkImageProvider(this);

  FileImage get toFileImage => FileImage(File(this));

  void get messageLog => dev.log('[Log]:: $this');

  void get infoMessageLog => dev.log('[Info]:: $this');

  void get warningMessageLog => dev.log('[Warning]:: $this', time: DateTime.now());

  void get errorMessageLog => dev.log('[Error]::', error: this, time: DateTime.now());

  void get firebaseSuccessMessageLog => dev.log('[Firebase-Success]:: $this', time: DateTime.now());

  void get firebaseErrorMessageLog => dev.log('[Firebase-Error]::', error: this, time: DateTime.now());
}

extension AudioUrlValidator on String? {
  bool get isValidAudioUrl {
    if (this == null || this!.trim().isEmpty) return false;

    final url = this!.trim();

    // Check if URI is valid
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !(uri.isAbsolute)) {
      return false;
    }

    // Allowed audio extensions (both iOS & Android support mp4 audio as well)
    const allowedExtensions = [
      ".mp3",
      ".wav",
      ".m4a",
      ".aac",
      ".ogg",
      ".flac",
      ".mp4", // some servers give voice intro in mp4 container
    ];

    return allowedExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }
}

extension ExtendedInteger on int {}

extension ExtendedDouble on double {
  SizedBox get toVSB => SizedBox(
        height: this,
      );

  SizedBox get toHSB => SizedBox(
        width: this,
      );

  Radius get toRadius => Radius.circular(this);

  BorderRadius get toAllRadius => BorderRadius.all(
        toRadius,
      );

  BorderRadius get toAllBorderRadius => BorderRadius.circular(
        this,
      );

  EdgeInsets get toPadding => EdgeInsets.all(this);

  EdgeInsets get toSymmetricPaddingHR => EdgeInsets.symmetric(horizontal: this);

  EdgeInsets get toSymmetricPaddingVR => EdgeInsets.symmetric(vertical: this);

  EdgeInsets get toPaddingOnlyBottom => EdgeInsets.only(bottom: this);

  EdgeInsets get toPaddingOnlyLeft => EdgeInsets.only(left: this);

  EdgeInsets get toPaddingOnlyRight => EdgeInsets.only(right: this);

  EdgeInsets get toPaddingOnlyTop => EdgeInsets.only(top: this);
}

extension ExtendedWidget on Widget {
  Center get toCenter => Center(
        child: this,
      );

  Expanded get toExpanded => Expanded(
        child: this,
      );

  Flexible get toFlexible => Flexible(
        child: this,
      );

  Padding toAllPadding(final double value) => Padding(
        padding: value.toPadding,
        child: this,
      );

  Padding toHorizontalPadding(final double value) => Padding(
        padding: value.toSymmetricPaddingHR,
        child: this,
      );

  Padding toVerticalPadding(final double value) => Padding(
        padding: value.toSymmetricPaddingVR,
        child: this,
      );

  Padding toSymmetricPadding({final double? horizontal, final double? vertical}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal ?? 0, vertical: vertical ?? 0),
        child: this,
      );

  Padding toOnlyPadding({final double? left, final double? right, final double? top, final double? bottom}) => Padding(
        padding: EdgeInsets.only(left: left ?? 0.0, right: right ?? 0.0, bottom: bottom ?? 0.0, top: top ?? 0.0),
        child: this,
      );

  Align get centerLeftAlign => Align(
        alignment: Alignment.centerLeft,
        child: this,
      );

  Align get topLeftAlign => Align(
        alignment: Alignment.topLeft,
        child: this,
      );

  Align get bottomLeftAlign => Align(
        alignment: Alignment.bottomLeft,
        child: this,
      );

  Align get centerRightAlign => Align(
        alignment: Alignment.centerRight,
        child: this,
      );

  Align get topRightAlign => Align(
        alignment: Alignment.topRight,
        child: this,
      );

  Align get bottomRightAlign => Align(
        alignment: Alignment.bottomRight,
        child: this,
      );

  Align get centerBottomAlign => Align(
        alignment: Alignment.bottomCenter,
        child: this,
      );

  Align get centerAlign => Align(
        child: this,
      );

  Align get topCenterAlign => Align(
        alignment: Alignment.topCenter,
        child: this,
      );

  FittedBox get toFittedBox => FittedBox(child: this);
}

extension CustomContext on BuildContext {
  double screenHeight([final double percent = 1]) => MediaQuery.of(this).size.height * percent;

  double screenWidth([final double percent = 1]) => MediaQuery.of(this).size.width * percent;
}

extension DateTimeExtension on DateTime {
  String timeAgo({final bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  String formatDate() {
    const dateFormatter = 'MMMM dd, y';
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(final DateTime other) => year == other.year && month == other.month && day == other.day;

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}

extension AgeCalculator on String {
  int calculateAge() {
    try {
      final birthDate = DateTime.parse(this);
      final today = DateTime.now();

      int age = today.year - birthDate.year;

      // Check if birthday has not occurred yet this year
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      return 0; // return 0 if parsing fails
    }
  }
}
