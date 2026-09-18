import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/localization/app_language_option.dart';
import 'package:thredo/localization/locale_cubit.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/common_appbar.dart';

import '../../widget/text_widget.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends BaseStatefulWidgetState<ChangeLanguageScreen> {
  int _selectedLanguageIndex = 0;
  bool _syncedInitialSelection = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_syncedInitialSelection) {
      _syncedInitialSelection = true;
      final locale = context.read<LocaleCubit>().state;
      _selectedLanguageIndex = indexForLocale(locale);
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CommonAppBar(
      title: AppLocalizations.of(context).changeLanguageTitle,
      leadingIc: SVGImages.icArrowBack,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      color: backgroundColor,
      child: ListView.builder(
        itemCount: kAppLanguageOptions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              final cubit = context.read<LocaleCubit>();
              final nav = Navigator.of(context);
              setState(() => _selectedLanguageIndex = index);
              await cubit.setLocale(kAppLanguageOptions[index].locale);
              if (!mounted) return;
              nav.pop();
            },
            child: _buildLanguageItem(index),
          );
        },
      ),
    );
  }

  Widget _buildLanguageItem(int index) {
    final option = kAppLanguageOptions[index];
    final selected = _selectedLanguageIndex == index;

    return Container(
      margin: EdgeInsets.only(right: 20.w, left: 20.w, top: 16.h),
      width: screenSize.width,
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: selected ? colorPrimary : colorF8F8F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            SvgPicture.asset(
              selected ? SVGImages.icFlagSelected : SVGImages.icFlagUnselected,
              width: 40.w,
              height: 40.h,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    text: option.labelNative,
                    textStyle: BaseTextStyle.text600.copyWith(
                      fontSize: 18.sp,
                      color: colorBlack,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextWidget(
                    text: option.labelEnglish,
                    textStyle: BaseTextStyle.text400.copyWith(
                      fontSize: 13.sp,
                      color: color79747E,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              selected ? SVGImages.icCheckboxSelected : SVGImages.icCheckboxUnSelected,
              width: 24.w,
              height: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}
