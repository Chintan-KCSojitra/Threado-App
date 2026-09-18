import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/localization/app_language_option.dart';
import 'package:thredo/localization/locale_cubit.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/text_widget.dart';

import '../../utils/navigation_utils.dart';
import '../login/login_screen.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends BaseStatefulWidgetState<ChooseLanguageScreen> {
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
    return CommonAppBar(title: AppLocalizations.of(context).chooseLanguageTitle);
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
              final option = kAppLanguageOptions[index];
              setState(() => _selectedLanguageIndex = index);
              await cubit.setLocale(option.locale);
              await LocaleCubit.setLanguageOnboardingComplete();
              if (!mounted) return;
              navigate(enterPage: const LoginScreen());
            },
            child: _buildLanguageItem(context, index)
                .animate(onPlay: (c) => c.forward(from: 0))
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 180.ms),
          );
        },
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, int index) {
    final bool isSelected = _selectedLanguageIndex == index;
    final option = kAppLanguageOptions[index];

    return Container(
      margin: EdgeInsets.only(right: 20.w, left: 20.w, top: 16.h),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? colorPrimary : colorF8F8F8,
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            SvgPicture.asset(
              isSelected ? SVGImages.icFlagSelected : SVGImages.icFlagUnselected,
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
              isSelected ? SVGImages.icCheckboxSelected : SVGImages.icCheckboxUnSelected,
              width: 24.w,
              height: 24.w,
            ),
          ],
        ),
      ),
    )
        .animate(delay: (index * 80).ms)
        .fadeIn(duration: 350.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          curve: Curves.easeOut,
        );
  }
}
