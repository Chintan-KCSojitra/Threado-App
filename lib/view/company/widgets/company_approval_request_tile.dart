import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/view/company/models/company_approval_request.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';

class CompanyApprovalRequestTile extends StatelessWidget {
  const CompanyApprovalRequestTile({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  final CompanyApprovalRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  String get _dateLabel => DateFormat('d MMM yyyy, h:mm a').format(
        request.requestedAt,
      );

  @override
  Widget build(BuildContext context) {
    final isPending = request.status == CompanyApprovalStatus.pending;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorE7E3DA.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AppCachedImage(
                  imageUrl: request.companyLogoUrl,
                  width: 52.w,
                  height: 52.w,
                  fit: BoxFit.cover,
                ),
              ),
              widthBox(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: request.companyName,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      textStyle: BaseTextStyle.text600.copyWith(
                        fontSize: 15.sp,
                        color: color09064A,
                      ),
                    ),
                    if ((request.subtitle ?? '').trim().isNotEmpty) ...[
                      heightBox(4.h),
                      TextWidget(
                        text: request.subtitle!,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        textStyle: BaseTextStyle.text400.copyWith(
                          fontSize: 13.sp,
                          color: color79747E,
                        ),
                      ),
                    ],
                    heightBox(6.h),
                    TextWidget(
                      text: _dateLabel,
                      textStyle: BaseTextStyle.text400.copyWith(
                        fontSize: 12.sp,
                        color: color79747E,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: request.status),
            ],
          ),
          if (isPending) ...[
            heightBox(14.h),
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    text: 'Reject',
                    height: 42.h,
                    borderRadius: 10,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    backgroundColor: colorWhite,
                    textColor: color09064A,
                    borderColor: colorE7E3DA,
                    onTap: onReject,
                  ),
                ),
                widthBox(10.w),
                Expanded(
                  child: CommonButton(
                    text: 'Accept',
                    height: 42.h,
                    borderRadius: 10,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    onTap: onAccept,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final CompanyApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      CompanyApprovalStatus.pending => ('Pending', colorCEAB8D.withValues(alpha: 0.18), colorCEAB8D),
      CompanyApprovalStatus.accepted => ('Accepted', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
      CompanyApprovalStatus.rejected => ('Rejected', const Color(0xFFFFEBEE), const Color(0xFFC62828)),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: TextWidget(
        text: label,
        textStyle: BaseTextStyle.text600.copyWith(
          fontSize: 11.sp,
          color: fg,
        ),
      ),
    );
  }
}
