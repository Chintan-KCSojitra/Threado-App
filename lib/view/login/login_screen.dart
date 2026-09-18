import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/legal/legal_document_type.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/header_images_store.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/view/bottomMenu/bottom_menu_screen.dart';
import 'package:thredo/view/login/cubit/login_cubit.dart';
import 'package:thredo/view/login/cubit/login_state.dart';
import 'package:thredo/view/profile/legal_document_screen.dart';
import 'package:thredo/widget/app_cached_image.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/edit_text_widget.dart';
import 'package:thredo/widget/text_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginCubit(), child: const _LoginView());
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStatefulWidgetState<_LoginView> with TickerProviderStateMixin {
  bool _termsAccepted = false;
  bool _passwordObscured = true;

  late final AnimationController _waveController;
  late final AnimationController _scrollController;
  late final Animation<double> _logoFloatAnimation;

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
    _logoFloatAnimation = Tween<double>(
      begin: -8,
      end: 10,
    ).animate(CurvedAnimation(parent: _waveController, curve: Curves.easeInOutSine));
  }

  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  bool get shouldHaveSafeArea => true;

  @override
  void dispose() {
    _scrollController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final l10n = AppLocalizations.of(context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is SuccessState) {
          navigate(enterPage: const BottomMenuScreen(), navigationType: NavigationType.pushAndClearStack);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportHeight = constraints.maxHeight;
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              width: screenSize.width,
              constraints: BoxConstraints(minHeight: viewportHeight),
              color: backgroundColor,
              child: Stack(
                children: [
                  SizedBox(height: viewportHeight, width: screenSize.width),

                  /// Header images moving continuously.
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 332.h,
                    child: RepaintBoundary(
                      child: SizedBox(
                        width: screenSize.width,
                        child: AnimatedBuilder(
                          animation: _scrollController,
                          child: Row(
                            // pre-built once; shared between both Positioned rows
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ..._headerImages.map((img) => _buildHeaderImage(img, 120.w, 160.h, 12.w)),
                              ..._headerImages.map((img) => _buildHeaderImage(img, 120.w, 160.h, 12.w)),
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
                                Positioned(left: offsetLTR, top: 172.h, child: cachedRow),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 360.h,
                    child: Container(
                      width: screenSize.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colorBlack.withValues(alpha: 0.06),
                            colorBlack.withValues(alpha: 0.5),
                            colorWhite.withValues(alpha: 0.94),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),

                  /// Floating brand badge.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 150.h,
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (_, child) {
                        return Transform.translate(offset: Offset(0, _logoFloatAnimation.value), child: child);
                      },
                      child:
                          Container(
                                height: 112.h,
                                width: 112.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorE7E3DA.withValues(alpha: 0.26),
                                      blurRadius: 24,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(20.w),
                                child: Image.asset(PNGImages.imgTransparentLogo, color: color010103),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                    ),
                  ),

                  /// Main content.
                  Padding(
                    padding: EdgeInsets.only(top: 284.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heightBox(18.h),
                        Align(
                          alignment: Alignment.center,
                          child: TextWidget(
                            text: l10n.welcomeToApp,
                            textStyle: BaseTextStyle.text600.copyWith(fontSize: 28.sp, color: color09064A),
                          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                        ),
                        heightBox(6.h),
                        Align(
                          alignment: Alignment.center,
                          child:
                              TextWidget(
                                    text: l10n.loginTagline,
                                    textAlign: TextAlign.center,
                                    textStyle: BaseTextStyle.text400.copyWith(fontSize: 14.sp, color: color79747E),
                                  )
                                  .animate(delay: 80.ms)
                                  .fadeIn(duration: 400.ms)
                                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                        ),
                        heightBox(18.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _buildTagChip(l10n.tagTrending),
                              _buildTagChip(l10n.tagPremium),
                              _buildTagChip(l10n.tagVerified),
                            ],
                          ).animate(delay: 140.ms).fadeIn(duration: 350.ms).scale(begin: const Offset(0.95, 0.95)),
                        ),
                        heightBox(22.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child:
                              Container(
                                    padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 20.h),
                                    decoration: BoxDecoration(
                                      color: colorWhite.withValues(alpha: 0.92),
                                      borderRadius: BorderRadius.circular(22.r),
                                      border: Border.all(color: colorE7E3DA.withValues(alpha: 0.75)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorE7E3DA.withValues(alpha: 0.14),
                                          blurRadius: 24,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: l10n.mobileNumber,
                                          textStyle: BaseTextStyle.text500.copyWith(
                                            fontSize: 14.sp,
                                            color: color09064A,
                                          ),
                                        ),
                                        heightBox(8.h),
                                        TextEditingWidget(
                                          textInputType: TextInputType.number,
                                          maxLength: 10,
                                          textInputAction: TextInputAction.done,
                                          hint: '987 456 1190',
                                          controller: cubit.mobileNumberController,
                                          prefixIconName: SVGImages.icCall,
                                          inputFormatters: [
                                            TextInputFormatter.withFunction((oldValue, newValue) {
                                              String text = newValue.text;
                                              String stripped = text.replaceAll(RegExp(r'[\s-]'), '');
                                              bool modified = false;
                                              if (stripped.startsWith('+91')) {
                                                stripped = stripped.substring(3);
                                                modified = true;
                                              } else if (stripped.startsWith('91') && stripped.length > 10) {
                                                stripped = stripped.substring(2);
                                                modified = true;
                                              }
                                              if (modified) {
                                                return TextEditingValue(
                                                  text: stripped,
                                                  selection: TextSelection.collapsed(offset: stripped.length),
                                                );
                                              }
                                              return newValue;
                                            }),
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                        ),
                                        heightBox(14.h),
                                        TextWidget(
                                          text: 'Password',
                                          textStyle: BaseTextStyle.text500.copyWith(
                                            fontSize: 14.sp,
                                            color: color09064A,
                                          ),
                                        ),
                                        heightBox(8.h),
                                        TextEditingWidget(
                                          textInputType: TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.done,
                                          hint: '••••••••',
                                          controller: cubit.passwordController,
                                          passwordVisible: _passwordObscured,
                                          suffixIconWidget: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              setState(() {
                                                _passwordObscured = !_passwordObscured;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                                              child: Icon(
                                                _passwordObscured
                                                    ? Icons.visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color: colorBlack.withValues(alpha: 0.4),
                                                size: 20.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        heightBox(14.h),
                                        _buildTermsAcceptanceRow(context, l10n),
                                        heightBox(16.h),
                                        BlocBuilder<LoginCubit, LoginState>(
                                              builder: (context, state) {
                                                return CommonButton(
                                                  onTap: state is LoadingState ? null : () => _handleLogin(cubit),
                                                  text: state is LoadingState ? 'Please wait...' : l10n.login,
                                                );
                                              },
                                            )
                                            .animate(delay: 280.ms)
                                            .fadeIn(duration: 400.ms)
                                            .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack),
                                      ],
                                    ),
                                  )
                                  .animate(delay: 200.ms)
                                  .fadeIn(duration: 450.ms)
                                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleLogin(LoginCubit cubit) {
    if (!_termsAccepted) {
      showMessage(message: AppLocalizations.of(context).loginAcceptTermsRequired);
      return;
    }
    cubit.login();
  }

  void _openLegalDocument(LegalDocumentType type) {
    final l10n = AppLocalizations.of(context);
    final title = type == LegalDocumentType.privacyPolicy ? l10n.privacyPolicy : l10n.termsAndConditions;
    navigate(
      enterPage: LegalDocumentScreen(title: title, documentType: type),
    );
  }

  Widget _buildTermsAcceptanceRow(BuildContext context, AppLocalizations l10n) {
    final linkStyle = BaseTextStyle.text600.copyWith(
      fontSize: 12.sp,
      color: color09064A,
      decoration: TextDecoration.underline,
      decorationColor: colorCEAB8D,
    );
    final bodyStyle = BaseTextStyle.text400.copyWith(fontSize: 12.sp, color: color79747E, height: 1.45);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: _termsAccepted,
            activeColor: colorCEAB8D,
            checkColor: colorWhite,
            side: BorderSide(color: _termsAccepted ? colorCEAB8D : colorD9D9D9, width: 1.5),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onChanged: (value) {
              setState(() => _termsAccepted = value ?? false);
            },
          ),
        ),
        widthBox(8.w),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextWidget(text: l10n.loginAcceptTermsPrefix, textStyle: bodyStyle),
              GestureDetector(
                onTap: () => _openLegalDocument(LegalDocumentType.termsAndConditions),
                child: TextWidget(text: l10n.termsAndConditions, textStyle: linkStyle),
              ),
              TextWidget(text: l10n.loginAcceptTermsAnd, textStyle: bodyStyle),
              GestureDetector(
                onTap: () => _openLegalDocument(LegalDocumentType.privacyPolicy),
                child: TextWidget(text: l10n.privacyPolicy, textStyle: linkStyle),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colorWhite.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: colorE7E3DA.withValues(alpha: 0.45)),
      ),
      child: TextWidget(
        text: label,
        textStyle: BaseTextStyle.text500.copyWith(fontSize: 11.sp, color: color09064A),
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
