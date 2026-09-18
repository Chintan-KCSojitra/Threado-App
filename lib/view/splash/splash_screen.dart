import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/strings.dart';
import 'package:thredo/utils/shared_preference_util.dart';
import 'package:thredo/view/bottomMenu/bottom_menu_screen.dart';
import 'package:thredo/view/splash/cubit/splash_cubit.dart';
import 'package:thredo/view/splash/cubit/splash_state.dart';

import '../../localization/locale_cubit.dart';
import '../../utils/navigation_utils.dart';
import '../chooseLanguage/choose_language_screen.dart';
import '../login/login_screen.dart';

// ── BLoC wrapper ──────────────────────────────────────────────────────────────

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..getImageList(),
      child: const _SplashView(),
    );
  }
}

// ── View ──────────────────────────────────────────────────────────────────────

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseStatefulWidgetState<_SplashView> {
  bool _gifFinished = false;

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  bool get resizeToAvoidBottomInset => false;

  @override
  bool get shouldHaveSafeArea => false;

  void _navigateToNext() async {
    await SharedPreferenceUtil.getInstance();
    if (!mounted) return;

    final isLoggedIn = SharedPreferenceUtil.getBool(kPrefIsLogin);
    if (isLoggedIn) {
      navigate(
        context: context,
        enterPage: const BottomMenuScreen(),
        navigationType: NavigationType.pushAndClearStack,
      );
    } else if (LocaleCubit.isLanguageOnboardingComplete()) {
      navigate(
        context: context,
        enterPage: const LoginScreen(),
        navigationType: NavigationType.pushAndClearStack,
      );
    } else {
      navigate(
        context: context,
        enterPage: const ChooseLanguageScreen(),
        navigationType: NavigationType.pushAndClearStack,
      );
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        // Images loaded (or failed) — if GIF already finished, navigate now.
        if (_gifFinished && mounted) _navigateToNext();
      },
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            Container(color: colorE7E3DA),
            // Logo + app name
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GifView(
                    image: const AssetImage(
                      GifAnimation.gifLogoAnimationFullyTransparent,
                    ),
                    width: 300.w,
                    height: 300.h,
                    autoPlay: true,
                    frameRate: 15,
                    fit: BoxFit.contain,
                    color: color010103,
                    loop: false,
                    onFinish: () {
                      setState(() => _gifFinished = true);
                      if (mounted) _navigateToNext();
                    },
                  ),
                  Transform.translate(
                    offset: Offset(5, -78.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: strAppName
                          .split('')
                          .map(
                            (char) => Text(
                              char,
                              style: TextStyle(
                                fontFamily: strFontName,
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.6,
                                color: color010103,
                                shadows: [
                                  Shadow(
                                    color: colorBlack.withValues(alpha: 0.18),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList()
                          .animate(interval: 100.ms, delay: 400.ms)
                          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 400.ms,
                            curve: Curves.easeOutBack,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
