import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';

/// Compact capture tips shown on the Thread Match screen before an image is picked.
class ThreadMatchCaptureTipsBanner extends StatelessWidget {
  const ThreadMatchCaptureTipsBanner({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tips = _captureTips(l10n).take(3).toList();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorE7E3DA.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 18.sp, color: colorCEAB8D),
              widthBox(8.w),
              Expanded(
                child: TextWidget(
                  text: l10n.matchCaptureTipsTitle,
                  textStyle: BaseTextStyle.text600.copyWith(
                    fontSize: 13.sp,
                    color: color09064A,
                  ),
                ),
              ),
            ],
          ),
          heightBox(10.h),
          ...tips.map(
            (tip) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: _CaptureTipRow(icon: tip.icon, text: tip.text),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full capture tips list for bottom sheets.
class ThreadMatchCaptureTipsPanel extends StatelessWidget {
  const ThreadMatchCaptureTipsPanel({
    super.key,
    required this.l10n,
    this.sourceNote,
  });

  final AppLocalizations l10n;
  final String? sourceNote;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: colorE7E3DA.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.photo_camera_outlined, size: 18.sp, color: color09064A),
            ),
            widthBox(10.w),
            Expanded(
              child: TextWidget(
                text: l10n.matchCaptureTipsTitle,
                textStyle: BaseTextStyle.text600.copyWith(
                  fontSize: 15.sp,
                  color: color09064A,
                ),
              ),
            ),
          ],
        ),
        if (sourceNote != null) ...[
          heightBox(8.h),
          TextWidget(
            text: sourceNote!,
            textStyle: BaseTextStyle.text400.copyWith(
              fontSize: 12.sp,
              color: color79747E,
              height: 1.4,
            ),
          ),
        ],
        heightBox(12.h),
        ..._captureTips(l10n).map(
          (tip) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _CaptureTipRow(icon: tip.icon, text: tip.text),
          ),
        ),
      ],
    );
  }
}

class _CaptureTipRow extends StatelessWidget {
  const _CaptureTipRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: colorCEAB8D),
        widthBox(8.w),
        Expanded(
          child: TextWidget(
            text: text,
            textStyle: BaseTextStyle.text400.copyWith(
              fontSize: 12.sp,
              color: color79747E,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _CaptureTip {
  const _CaptureTip({required this.icon, required this.text});

  final IconData icon;
  final String text;
}

List<_CaptureTip> _captureTips(AppLocalizations l10n) => [
      _CaptureTip(icon: Icons.wb_sunny_outlined, text: l10n.matchCaptureTipLighting),
      _CaptureTip(icon: Icons.center_focus_strong_outlined, text: l10n.matchCaptureTipFocus),
      _CaptureTip(icon: Icons.crop_free_rounded, text: l10n.matchCaptureTipFrame),
      _CaptureTip(icon: Icons.block_outlined, text: l10n.matchCaptureTipAvoid),
      _CaptureTip(icon: Icons.looks_one_outlined, text: l10n.matchCaptureTipSingle),
    ];
