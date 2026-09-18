import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:thredo/widget/profile_image_widget.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/text_widget.dart';
import '../res/color.dart';
import '../res/strings.dart';
import '../res/style.dart';
import '../utils/navigation_utils.dart';

Widget heightBox(double height) {
  return SizedBox(height: height);
}

Widget widthBox(double width) {
  return SizedBox(width: width);
}

Widget buildBackArrow({String color = 'white'}) {
  return Positioned(
    top: 20,
    left: 20,
    child: GestureDetector(
      onTap: () => navigate(navigationType: NavigationType.goBack),
      child: SvgPicture.asset('ThemeImage.getBackImage()'),
    ),
  );
}

/* error & success*/
showMessage({String? message, String? type = 'error'}) {
  toastification.show(
    title: TextWidget(
      text: message ?? '',
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
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
    closeOnClick: true,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: false,
  );
}

/*---- Redirection ---------------------------------------------------*/
Future<void> redirectToAppStore(String appId) async {
  Uri androidUrl = Uri.parse('market://details?id=$appId');
  Uri iosUrl = Uri.parse('https://apps.apple.com/app/id$appId');
  if (await launchUrl(androidUrl)) {
    await launchUrl(androidUrl);
  } else if (await launchUrl(iosUrl)) {
    await launchUrl(iosUrl);
  } else {}
}

/*void shareAppLink() {
  const String androidAppLink = 'https://play.google.com/store/apps/details?id=com.example.yourapp';
  const String iOSAppLink = 'https://apps.apple.com/app/id123456789';
  const String message = '''

  Check out this awesome app:
  Android: $androidAppLink
  iOS: $iOSAppLink
  Thank you!

  ''';
  Share.share(message);
}*/

Future<void> launchDialer(String phoneNumber) async {
  final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(telUri)) {
    await launchUrl(telUri);
  } else {
    throw 'Could not launch $telUri';
  }
}

/*Widget buildNegativeButton({GestureTapCallback? onTap, String text = strNo}) {
  return CommonButton(
    textColor: AppConfig.appThemeType.name == ThemeType.light.name ? buttonColorLight : buttonColorDark,
    backgroundColor: AppConfig.appThemeType.name == ThemeType.light.name ? colorWhite : buttonColorDark.withAlpha(20),
    borderColor: buttonColorLight,
    text: text,
    progressColor: colorPrimary,
    borderRadius: 15.r,
    isShadow: false,
    onTap: onTap,
  );
}

Widget buildPositiveButton({GestureTapCallback? onTap, String text = strYes, bool showLoading = false}) {
  return CommonButton(
    textColor: ThemeColors.getButtonTextColor(),
    backgroundColor: ThemeColors.getButtonBackgroundColor(),
    text: showLoading ? '' : text,
    progressColor: colorWhite,
    borderRadius: 15.r,
    isShadow: false,
    onTap: onTap,
    showLoading: showLoading,
  );
}*/

/*Widget circleUserListWidget({
  double symmetricHPadding = 10,
  double widthFactor = 0.59,
  double textWidthFactor = 0.55,
  double borderRadius = 20,
  double radius = 17,
  Color textBackgroundColor = colorPrimary,
  double fontSize = 11,
  GestureTapCallback? onTap,
  List<JoinedUser>? joinedUser,
}) {
  List userImages = [];
  var count = 0;
  if (joinedUser != null && joinedUser.isNotEmpty) {
    for (var data in joinedUser) {
      if (userImages.length < 4) userImages.add(data.image);
    }

    if (joinedUser.length > 4) {
      count = joinedUser.length - userImages.length;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: symmetricHPadding.w),
        child: Row(
          children: [
            Row(
              children: [
                for (int i = 0; i < userImages.length; i++)
                  Align(
                    widthFactor: widthFactor,
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 0.4, blurRadius: 10)]),
                      child: CircleAvatar(
                        radius: borderRadius,
                        backgroundColor: Colors.white,
                        child:
                        CircleAvatar(backgroundColor: Colors.white, radius: radius, backgroundImage: CachedNetworkImageProvider(userImages[i])),
                      ),
                    ),
                  )
              ],
            ),
            if (count > 0)
              Align(
                widthFactor: textWidthFactor,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 0.4, blurRadius: 10)]),
                  child: CircleAvatar(
                    backgroundColor: textBackgroundColor,
                    radius: borderRadius,
                    child: Center(
                        child: TextWidget(
                            text: '$count $strPlus',
                            color: Colors.white,
                            fontSize: fontSize.sp,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center)),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
  return SizedBox.shrink();
}*/

/*Widget circleUserListWidget({
  double symmetricHPadding = 10,
  double widthFactor = 0.59,
  double textWidthFactor = 0.55,
  double borderRadius = 20,
  double radius = 17,
  Color textBackgroundColor = colorPrimary,
  double fontSize = 11,
  GestureTapCallback? onTap,
  List<String>? pngImages, // List of PNG image asset paths
}) {
  List<String> userImages = [];
  var count = 0;

  if (pngImages != null && pngImages.isNotEmpty) {
    for (var imagePath in pngImages) {
      if (userImages.length < 4) userImages.add(imagePath);
    }

    if (pngImages.length > 4) {
      count = pngImages.length - userImages.length;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: symmetricHPadding.w),
        child: Row(
          children: [
            Row(
              children: [
                for (int i = 0; i < userImages.length; i++)
                  Align(
                    widthFactor: widthFactor,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 0.4, blurRadius: 10)],
                      ),
                      child: CircleAvatar(
                        radius: borderRadius,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ProfileImageWidget(
                            userProfileImage: userImages[i],
                            height: 44.sp,
                            width: 44.sp,
                            fit: BoxFit.cover,
                            showPadding: false,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (count > 0)
              Align(
                widthFactor: textWidthFactor,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 0.4, blurRadius: 10)]),
                  child: CircleAvatar(
                    backgroundColor: textBackgroundColor,
                    radius: borderRadius,
                    child: Center(
                      child: TextWidget(
                        text: '$count$strPlus',
                        textStyle: BaseTextStyle.text700.copyWith(color: colorWhite, fontSize: 12.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  return SizedBox.shrink();
}*/

// Future<String?> commonDatePicker(BuildContext context, String type, {DateTime? selectedDate, DateTime? startDate}) async {
//   final DateTime? picked = await showDatePicker(
//     context: context,
//     initialEntryMode: DatePickerEntryMode.calendarOnly,
//     initialDate: selectedDate ?? DateTime.now(),
//     firstDate: DateTime(1940),
//     lastDate: DateTime.now(),
//     builder: (context, child) {
//       return Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: const ColorScheme.light(
//             primary: colorE7E3DA,
//             onPrimary: colorWhite,
//             onSurface: colorBlack,
//           ),
//         ),
//         child: child!,
//       );
//     },
//   );
//
//   if (picked != null && picked != selectedDate) {
//     if (type == "end_date" && startDate != null && picked.isBefore(startDate)) {
//       showMessage(message: strDateValidation, type: 'error');
//       return null;
//     }
//     return intl.DateFormat('dd/MM/yyyy').format(picked);
//   }
//   return null;
// }

String formatDate(String dateString) {
  if (dateString.isNotEmpty) {
    final DateTime now = DateTime.now();
    final DateTime date = DateTime.parse(dateString).toLocal();
    final intl.DateFormat timeFormatter = intl.DateFormat('hh:mm a');
    final intl.DateFormat dateFormatter = intl.DateFormat('dd MMM, yyyy');

    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today)) {
      return timeFormatter.format(date);
    } else if (date.isAfter(yesterday) && date.isBefore(today)) {
      return 'Yesterday';
    } else {
      return dateFormatter.format(date);
    }
  } else {
    return dateString;
  }
}

String timeAgo(final String dateTimeString, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
  DateTime dateTime;
  try {
    dateTime = intl.DateFormat(format).parseUtc(dateTimeString).toLocal();
  } catch (e) {
    dateTime = DateTime.parse(dateTimeString).toUtc().toLocal();
  }
  final currentTime = DateTime.now().toLocal();
  final difference = currentTime.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago";
  } else if (difference.inDays == 1) {
    return 'yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    return "${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago";
  } else if (difference.inDays < 365) {
    return "${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago";
  } else {
    return "${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago";
  }
}

Widget circleUserListWidget({
  double symmetricHPadding = 10,
  double widthFactor = 0.59,
  double textWidthFactor = 0.55,
  double borderRadius = 20,
  double radius = 17,
  Color textBackgroundColor = colorPrimary,
  double fontSize = 11,
  GestureTapCallback? onTap,
  List<String>? pngImages, // List of PNG image asset paths
}) {
  List<String> userImages = [];
  var count = 0;

  if (pngImages != null && pngImages.isNotEmpty) {
    for (var imagePath in pngImages) {
      if (userImages.length < 4) userImages.add(imagePath);
    }

    if (pngImages.length > 4) {
      count = pngImages.length - userImages.length;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: symmetricHPadding.w),
        child: Row(
          children: [
            Row(
              children: [
                for (int i = 0; i < userImages.length; i++)
                  Align(
                    widthFactor: widthFactor,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.4),
                            spreadRadius: 0.4,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Container(
                          decoration: const BoxDecoration(color: colorWhite),
                          padding: const EdgeInsets.all(2.0),
                          child: ProfileImageWidget(
                            userProfileImage: userImages[i],
                            height: 26.sp,
                            width: 26.sp,
                            fit: BoxFit.cover,
                            showPadding: false,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (count > 0)
              Align(
                widthFactor: textWidthFactor,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.4),
                        spreadRadius: 0.4,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Container(
                      height: 26.h,
                      width: 26.w,
                      color: colorE7E3DA,
                      child: Center(
                        child: TextWidget(
                          text: '$count$strPlus',
                          textStyle: BaseTextStyle.text600.copyWith(
                            color: colorWhite,
                            fontSize: 8.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  return const SizedBox.shrink();
}
