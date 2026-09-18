import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/edit_text_widget.dart';
import 'package:thredo/widget/text_widget.dart';

class CompanyReviewDialog extends StatefulWidget {
  const CompanyReviewDialog({
    super.key,
    required this.companyName,
    required this.onSubmit,
  });

  final String companyName;
  final Future<bool> Function(int rating, String reviewText) onSubmit;

  static void show(
    BuildContext context, {
    required String companyName,
    required Future<bool> Function(int rating, String reviewText) onSubmit,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset = MediaQuery.viewInsetsOf(ctx).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SafeArea(
            top: false,
            child: CompanyReviewDialog(
              companyName: companyName,
              onSubmit: onSubmit,
            ),
          ),
        );
      },
    );
  }

  @override
  State<CompanyReviewDialog> createState() => _CompanyReviewDialogState();
}

class _CompanyReviewDialogState extends State<CompanyReviewDialog> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_isLoading) return;
    
    final l10n = AppLocalizations.of(context);
    if (_rating < 1) {
      showMessage(message: l10n.selectStarRating, type: 'error');
      return;
    }
    
    setState(() => _isLoading = true);
    final success = await widget.onSubmit(_rating, _reviewController.text.trim());
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop();
      showMessage(message: l10n.reviewThanks, type: 'success');
    } else {
      showMessage(message: 'Failed to submit review', type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      constraints: BoxConstraints(maxHeight: 0.78.sh),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: colorD9D9D9,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              heightBox(16.h),
              TextWidget(
                text: l10n.addReview,
                textStyle: BaseTextStyle.text600.copyWith(
                  fontSize: 18.sp,
                  color: color09064A,
                ),
              ),
              heightBox(6.h),
              TextWidget(
                text: widget.companyName,
                textStyle: BaseTextStyle.text500.copyWith(
                  fontSize: 14.sp,
                  color: color79747E,
                ),
              ),
              heightBox(20.h),
              TextWidget(
                text: l10n.rateCompany,
                textStyle: BaseTextStyle.text500.copyWith(
                  fontSize: 14.sp,
                  color: color09064A,
                ),
              ),
              heightBox(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final filled = starIndex <= _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = starIndex),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Icon(
                        filled ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 38.sp,
                        color: filled ? colorCEAB8D : colorD9D9D9,
                      ),
                    ),
                  );
                }),
              ),
              heightBox(22.h),
              TextWidget(
                text: l10n.yourReview,
                textStyle: BaseTextStyle.text500.copyWith(
                  fontSize: 14.sp,
                  color: color09064A,
                ),
              ),
              heightBox(8.h),
              TextEditingWidget(
                controller: _reviewController,
                hint: l10n.reviewHint,
                maxLines: 5,
                minLines: 3,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                borderRadius: 12,
                isShadowEnable: false,
              ),
              heightBox(24.h),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      text: l10n.cancel.toUpperCase(),
                      backgroundColor: colorF3F3F3,
                      textColor: color09064A,
                      fontSize: 14.sp,
                      height: 48.h,
                      borderRadius: 12,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  widthBox(12.w),
                  Expanded(
                    child: CommonButton(
                      text: _isLoading ? 'SUBMITTING...' : l10n.submitReview.toUpperCase(),
                      backgroundColor: colorPrimary,
                      textColor: colorBlack,
                      fontSize: 14.sp,
                      height: 48.h,
                      borderRadius: 12,
                      onTap: _isLoading ? () {} : _onSubmit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
