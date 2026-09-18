import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/text_widget.dart';

class CompanyReviewTile extends StatelessWidget {
  const CompanyReviewTile({
    super.key,
    required this.review,
    this.compact = false,
  });

  final CompanyReview review;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rating = (review.rating ?? 0).toInt().clamp(0, 5);
    final reviewText = (review.reviewText ?? '').trim();
    final userLabel = review.user?.displayName ?? 'User';
    final createdAt = review.createdAt;
    String dateLabel = '';
    if (createdAt != null && createdAt.isNotEmpty) {
      final parsed = DateTime.tryParse(createdAt);
      if (parsed != null) {
        dateLabel = compact
            ? DateFormat('dd MMM').format(parsed.toLocal())
            : DateFormat('dd MMM yyyy').format(parsed.toLocal());
      }
    }

    return Container(
      padding: EdgeInsets.all(compact ? 12.w : 14.w),
      decoration: BoxDecoration(
        color: colorF7F7F7,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorE7E3DA),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextWidget(
                  text: userLabel,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  textStyle: BaseTextStyle.text600.copyWith(
                    fontSize: compact ? 12.sp : 13.sp,
                    color: color09064A,
                  ),
                ),
              ),
              if (dateLabel.isNotEmpty) ...[
                SizedBox(width: 6.w),
                TextWidget(
                  text: dateLabel,
                  textStyle: BaseTextStyle.text400.copyWith(
                    fontSize: 10.sp,
                    color: color79747E,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: compact ? 4.h : 6.h),
          Row(
            children: List.generate(5, (index) {
              final filled = index < rating;
              return Icon(
                filled ? Icons.star_rounded : Icons.star_outline_rounded,
                size: compact ? 12.sp : 14.sp,
                color: filled ? colorCEAB8D : colorD9D9D9,
              );
            }),
          ),
          if (reviewText.isNotEmpty) ...[
            SizedBox(height: compact ? 6.h : 8.h),
            if (compact)
              Expanded(
                child: TextWidget(
                  text: reviewText,
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                  textStyle: BaseTextStyle.text400.copyWith(
                    fontSize: 12.sp,
                    color: color09064A,
                    height: 1.4,
                  ),
                ),
              )
            else
              TextWidget(
                text: reviewText,
                textStyle: BaseTextStyle.text400.copyWith(
                  fontSize: 13.sp,
                  color: color09064A,
                  height: 1.45,
                ),
              ),
          ] else if (compact)
            const Spacer(),
        ],
      ),
    );
  }
}
