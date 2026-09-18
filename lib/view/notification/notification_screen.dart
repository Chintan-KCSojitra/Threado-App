import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/res/color.dart';

import '../../base/base_stateful_widget_state.dart';
import '../../res/image.dart';
import '../../res/style.dart';
import '../../widget/common_appbar.dart';
import '../../widget/text_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends BaseStatefulWidgetState<NotificationScreen> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const CommonAppBar(title: 'Notification');
  }

  @override
  Widget buildBody(BuildContext context) {
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,

      child: ListView.builder(
        itemCount: 14,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: colorWhite,
              border: Border.all(color: colorF2F2F2, width: 1.sp),
              borderRadius: BorderRadius.circular(16.sp),
            ),
            margin: EdgeInsets.symmetric(vertical: 6.h),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.sp),
                  child: Image.asset(PNGImages.imgThread1, width: 74.w, height: 80.h, fit: BoxFit.cover),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Gold Lurex Craft & Sewing Thread Spool',
                        textStyle: BaseTextStyle.text600.copyWith(fontSize: 14.sp, color: color09064A),
                      ),
                      SizedBox(height: 10.h),
                      TextWidget(
                        text: '10:30 AM',
                        textStyle: BaseTextStyle.text400.copyWith(fontSize: 12.sp, color: color79747E),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
