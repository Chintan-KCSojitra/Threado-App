import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/utils/header_images_store.dart';
import 'package:thredo/view/otpVerification/cubit/otp_verification_cubit.dart';
import 'package:thredo/view/otpVerification/cubit/otp_verification_state.dart';
import 'package:thredo/widget/app_cached_image.dart';

import '../../res/image.dart';
import '../../res/style.dart';
import '../../utils/navigation_utils.dart';
import '../../widget/common_button.dart';
import '../../widget/common_widgets.dart';
import '../../widget/text_widget.dart';
import '../bottomMenu/bottom_menu_screen.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpVerificationCubit(phoneNumber: phoneNumber),
      child: _OtpVerificationView(phoneNumber: phoneNumber),
    );
  }
}

class _OtpVerificationView extends StatefulWidget {
  const _OtpVerificationView({required this.phoneNumber});

  final String phoneNumber;

  @override
  State<_OtpVerificationView> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends BaseStatefulWidgetState<_OtpVerificationView> with TickerProviderStateMixin {
  late final AnimationController _waveController;
  late final AnimationController _scrollController;
  late final Animation<double> _iconFloatAnimation;

  /// Fallback local assets used when the API hasn't returned data yet.
  static const List<String> _fallbackImages = [
    PNGImages.imgThread1,
    PNGImages.imgThread1,
    PNGImages.imgThread3,
    PNGImages.imgThread4,
    PNGImages.imgThread5,
    PNGImages.imgThread6,
  ];

  List<String> get _headerImages => HeaderImagesStore.hasData ? HeaderImagesStore.urls : _fallbackImages;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _scrollController = AnimationController(vsync: this, duration: const Duration(seconds: 25))..repeat();
    _iconFloatAnimation = Tween<double>(
      begin: -8,
      end: 10,
    ).animate(CurvedAnimation(parent: _waveController, curve: Curves.easeInOutSine));
  }

  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  void dispose() {
    _scrollController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<OtpVerificationCubit>();
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: backgroundColor,
        child: Stack(
          children: [
            /// Header images moving continuously.
            RepaintBoundary(
              child: SizedBox(
                height: 300.h,
                width: screenSize.width,
                child: AnimatedBuilder(
                  animation: _scrollController,
                  child: Row(
                    // pre-built once; cached between frames
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ..._headerImages.map((img) => _buildHeaderImage(img, 120.w, 144.h, 12.w)),
                      ..._headerImages.map((img) => _buildHeaderImage(img, 120.w, 144.h, 12.w)),
                    ],
                  ),
                  builder: (_, cachedRow) {
                    final itemWidth = 120.w;
                    final itemSpacing = 12.w;
                    final singleSetWidth = (itemWidth + itemSpacing) * _headerImages.length;
                    final offsetRTL = -singleSetWidth * _scrollController.value;
                    final offsetLTR = -singleSetWidth * (1.0 - _scrollController.value);

                    return Stack(
                      children: [
                        Positioned(left: offsetRTL, top: 0, child: cachedRow!),
                        Positioned(left: offsetLTR, top: 156.h, child: cachedRow),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 320.h,
              width: screenSize.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorBlack.withValues(alpha: 0.06),
                    colorBlack.withValues(alpha: 0.42),
                    colorWhite.withValues(alpha: 0.95),
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),

            /// Floating verification icon.
            Positioned(
              left: 0,
              right: 0,
              top: 120.h,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (_, child) {
                  return Transform.translate(offset: Offset(0, _iconFloatAnimation.value), child: child);
                },
                child: Container(
                  height: 110.h,
                  width: 110.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorWhite,
                    boxShadow: [BoxShadow(color: colorE7E3DA.withValues(alpha: 0.24), blurRadius: 26, spreadRadius: 4)],
                  ),
                  padding: EdgeInsets.all(24.w),
                  child: SvgPicture.asset(SVGImages.icOtpVerification),
                ).animate().fadeIn(duration: 450.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
              ),
            ),

            /// Content
            Positioned(
              top: 250.h,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightBox(20.h),
                  Align(
                    alignment: Alignment.center,
                    child: TextWidget(
                      text: l10n.otpSecureTitle,
                      textStyle: BaseTextStyle.text600.copyWith(fontSize: 27.sp, color: color09064A),
                    ).animate(delay: 80.ms).fadeIn(duration: 350.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                  ),
                  heightBox(6.h),
                  Align(
                    alignment: Alignment.center,
                    child: TextWidget(
                      textAlign: TextAlign.center,
                      text: l10n.otpSentMessage(widget.phoneNumber),
                      textStyle: BaseTextStyle.text400.copyWith(fontSize: 14.sp, color: color79747E, height: 1.5),
                    ).animate(delay: 150.ms).fadeIn(duration: 350.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 18.h),
                      decoration: BoxDecoration(
                        color: colorWhite.withValues(alpha: 0.93),
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(color: colorE7E3DA.withValues(alpha: 0.72)),
                        boxShadow: [
                          BoxShadow(
                            color: colorE7E3DA.withValues(alpha: 0.12),
                            blurRadius: 24,
                            spreadRadius: 1,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildOtpView()
                              .animate(delay: 220.ms)
                              .fadeIn(duration: 380.ms)
                              .slideY(begin: 0.25, end: 0, curve: Curves.easeOut),
                          heightBox(16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget(
                                text: l10n.otpDidntReceive,
                                textStyle: BaseTextStyle.text400.copyWith(fontSize: 13.sp, color: color79747E),
                              ),
                              BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
                                    builder: (context, state) {
                                      final uiState = state as OtpVerificationStateData;
                                      final canResend = uiState.canResend;
                                      final resendText = canResend
                                          ? l10n.otpResend
                                          : '${l10n.otpResend} (${cubit.resendTimerLabel})';
                                      return GestureDetector(
                                        onTap: canResend ? cubit.resendOtp : null,
                                        child: TextWidget(
                                          text: resendText,
                                          textStyle: BaseTextStyle.text600.copyWith(
                                            fontSize: 13.sp,
                                            color: canResend ? color09064A : color79747E,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  .animate(delay: 280.ms)
                                  .fadeIn(duration: 350.ms)
                                  .then()
                                  .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 500.ms)
                                  .then()
                                  .scale(begin: const Offset(1.05, 1.05), end: const Offset(1, 1), duration: 500.ms),
                            ],
                          ),
                          heightBox(20.h),
                          BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
                                builder: (context, state) {
                                  final uiState = state as OtpVerificationStateData;
                                  return CommonButton(
                                    onTap: uiState.isVerifying
                                        ? null
                                        : () async {
                                            final isVerified = await cubit.verifyOtp();
                                            if (isVerified && context.mounted) {
                                              navigate(
                                                enterPage: const BottomMenuScreen(),
                                                navigationType: NavigationType.pushAndClearStack,
                                              );
                                            }
                                          },
                                    text: uiState.isVerifying ? 'Verifying...' : l10n.confirm,
                                  );
                                },
                              )
                              .animate(delay: 300.ms)
                              .fadeIn(duration: 380.ms)
                              .slideY(begin: 0.25, end: 0, curve: Curves.easeOutBack),
                        ],
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 450.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpView() {
    final cubit = context.read<OtpVerificationCubit>();
    return MaterialPinField(
      length: 6,
      blinkWhenObscuring: true,
      pinController: cubit.otpController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      obscureText: false,
      enableHapticFeedback: true,
      onChanged: (value) {},
      onCompleted: (val) => FocusScope.of(context).unfocus(),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        borderRadius: BorderRadius.circular(13.r),
        borderWidth: 1.0,
        focusedBorderWidth: 1.4,
        cellSize: Size(43.w, 44.h),
        spacing: 8.w,
        textStyle: BaseTextStyle.text600.copyWith(fontSize: 20.sp, color: color09064A),
        cursorColor: colorPrimary,
        entryAnimation: MaterialPinAnimation.scale,
        animationDuration: const Duration(milliseconds: 220),
        disabledFillColor: colorF2F2F2,
        followingBorderColor: colorE6E6E6,
        borderColor: colorE7E3DA,
        focusedBorderColor: colorE7E3DA,
        focusedFillColor: colorFBFBFB,
        fillColor: colorFBFBFB,
        filledFillColor: colorF9FDFF,
      ),
    );
  }

  Widget _buildHeaderImage(String imagePath, double width, double height, double spacing) {
    final isNetwork = imagePath.startsWith('http');
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(right: spacing),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: colorF2F2F2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: isNetwork
            ? AppCachedImage(
                imageUrl: imagePath,
                fit: BoxFit.cover,
                width: width,
                height: height,
                placeholderColor: colorF2F2F2,
                errorWidget: Container(color: colorE6E6E6),
              )
            : Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}
