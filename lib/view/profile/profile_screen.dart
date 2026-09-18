import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/utils/navigation_utils.dart';
import 'package:thredo/utils/shared_preference_util.dart';
import 'package:thredo/legal/legal_document_type.dart';
import 'package:thredo/view/profile/change_language_screen.dart';
import 'package:thredo/view/profile/legal_document_screen.dart';
import 'package:thredo/view/wishlist/wish_list_screen.dart';
import 'package:thredo/widget/common_appbar.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/view/login/login_screen.dart';
import 'package:thredo/view/profile/cubit/profile_cubit.dart';
import 'package:thredo/view/profile/cubit/profile_state.dart';
import 'package:thredo/widget/app_loader.dart';
import 'package:thredo/widget/profile_image_widget.dart';
import 'package:thredo/widget/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseStatefulWidgetState<ProfileScreen> {
  late ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _profileCubit = ProfileCubit();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const CommonAppBar(
      title: '',
      toolbarHeight: 0,
      statusBarColor: colorPrimary,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    return BlocProvider.value(
      value: _profileCubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is LoadedState) {
            navigate(
              enterPage: const LoginScreen(),
              navigationType: NavigationType.pushAndClearStack,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [colorF9FDFF, colorWhite],
                  ),
                ),
                child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                      height: 310.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colorE7E3DA, colorE7E3DA],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.r),
                          bottomRight: Radius.circular(50.r),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -50.w,
                            top: -50.h,
                            child: Container(
                              width: 200.w,
                              height: 200.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorWhite.withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -80.w,
                            bottom: -30.h,
                            child: Container(
                              width: 180.w,
                              height: 180.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorWhite.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: -0.2, end: 0),
                Positioned(
                      top: topPadding + 10.h,
                      left: 20.w,
                      right: 20.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: l10n.myProfile,
                            textStyle: BaseTextStyle.text600.copyWith(
                              fontSize: 24.sp,
                              color: color09064A,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: color09064A.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: TextWidget(
                              text: l10n.thredoId,
                              textStyle: BaseTextStyle.text600.copyWith(
                                fontSize: 12.sp,
                                color: color09064A,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: -0.2, end: 0),
                Positioned(
                  top: 130.h,
                  left: 0,
                  right: 0,
                  child:
                      Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 110.w,
                                  height: 110.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorWhite,
                                      width: 4.w,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorE7E3DA.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: ProfileImageWidget(
                                      userProfileImage:
                                          PNGImages.imgUserPlaceHolder,
                                      isCircle: true,
                                      fit: BoxFit.cover,
                                      width: 110.w,
                                      height: 110.h,
                                    ),
                                  ),
                                ),
                                heightBox(14.h),
                                TextWidget(
                                  text: '${SharedPreferenceUtil.getUserData()?.phone}',
                                  textStyle: BaseTextStyle.text600.copyWith(
                                    fontSize: 22.sp,
                                    color: color09064A,
                                  ),
                                ),
                                heightBox(6.h),
                                TextWidget(
                                  text: l10n.profileSubtitle,
                                  textStyle: BaseTextStyle.text400.copyWith(
                                    fontSize: 14.sp,
                                    color: color09064A.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate(delay: 180.ms)
                          .fadeIn()
                          .scale(begin: const Offset(0.85, 0.85)),
                ),
              ],
            ),

            heightBox(30.h),

            /*Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      navigate(enterPage: const ChatListScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: colorE7E3DA.withValues(alpha: 0.6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorE7E3DA.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: colorCEAB8D.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_rounded,
                              size: 22.sp,
                              color: colorCEAB8D,
                            ),
                          ),
                          widthBox(16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Messages',
                                  textStyle: BaseTextStyle.text600.copyWith(
                                    fontSize: 16.sp,
                                    color: color09064A,
                                  ),
                                ),
                                heightBox(2.h),
                                TextWidget(
                                  text: 'Chat with suppliers & traders',
                                  textStyle: BaseTextStyle.text400.copyWith(
                                    fontSize: 13.sp,
                                    color: color79747E,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorCEAB8D,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: TextWidget(
                              text: '3',
                              textStyle: BaseTextStyle.text600.copyWith(
                                fontSize: 12.sp,
                                color: colorWhite,
                              ),
                            ),
                          ),
                          widthBox(8.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: colorE7E3DA,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate(delay: 240.ms)
                .fadeIn(duration: 320.ms)
                .slideY(begin: 0.18, end: 0),

            heightBox(16.h),

            Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      navigate(
                        enterPage: const CompanyApprovalRequestsScreen(),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: colorE7E3DA.withValues(alpha: 0.6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorE7E3DA.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: colorCEAB8D.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.approval_outlined,
                              size: 22.sp,
                              color: colorCEAB8D,
                            ),
                          ),
                          widthBox(16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Request Approval',
                                  textStyle: BaseTextStyle.text600.copyWith(
                                    fontSize: 16.sp,
                                    color: color09064A,
                                  ),
                                ),
                                heightBox(2.h),
                                TextWidget(
                                  text:
                                      'Review incoming requests from other companies',
                                  textStyle: BaseTextStyle.text400.copyWith(
                                    fontSize: 13.sp,
                                    color: color79747E,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorCEAB8D,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: TextWidget(
                              text:
                                  '${CompanyApprovalStaticData.initialRequests().length}',
                              textStyle: BaseTextStyle.text600.copyWith(
                                fontSize: 12.sp,
                                color: colorWhite,
                              ),
                            ),
                          ),
                          widthBox(8.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: colorE7E3DA,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate(delay: 280.ms)
                .fadeIn(duration: 320.ms)
                .slideY(begin: 0.18, end: 0),

            heightBox(16.h),*/

            Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      navigate(enterPage: const WishListScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: colorE7E3DA.withValues(alpha: 0.6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorE7E3DA.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF2F2),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              SVGImages.icHeartHome,
                              width: 22.w,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFE56A6A),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          widthBox(16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: l10n.statSaved,
                                  textStyle: BaseTextStyle.text600.copyWith(
                                    fontSize: 16.sp,
                                    color: color09064A,
                                  ),
                                ),
                                heightBox(2.h),
                                TextWidget(
                                  text: 'items in your wishlist',
                                  textStyle: BaseTextStyle.text400.copyWith(
                                    fontSize: 13.sp,
                                    color: color79747E,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: colorE7E3DA,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate(delay: 280.ms)
                .fadeIn(duration: 320.ms)
                .slideY(begin: 0.18, end: 0),

            heightBox(20.h),

            _buildSectionCard(
              child: Column(
                children: [
                  _buildProfileItem(
                    l10n.changeLanguageTitle,
                    SVGImages.icChangeLanguage,
                    index: 0,
                    onTap: () => navigate(enterPage: const ChangeLanguageScreen()),
                  ),
                  _buildProfileItem(
                    l10n.privacyPolicy,
                    SVGImages.icPrivacyPolicy,
                    index: 1,
                    onTap: () => navigate(
                      enterPage: LegalDocumentScreen(
                        title: l10n.privacyPolicy,
                        documentType: LegalDocumentType.privacyPolicy,
                      ),
                    ),
                  ),
                  _buildProfileItem(
                    l10n.termsAndConditions,
                    SVGImages.icTermsConditions,
                    index: 2,
                    onTap: () => navigate(
                      enterPage: LegalDocumentScreen(
                        title: l10n.termsAndConditions,
                        documentType: LegalDocumentType.termsAndConditions,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionCard(
              child: Column(
                children: [
                  _buildProfileItem(
                    l10n.deleteAccount,
                    SVGImages.icDeleteAccount,
                    index: 3,
                    onTap: () => showDeleteAccountDialog(context),
                  ),
                  _buildProfileItem(
                    l10n.logout,
                    SVGImages.icLogout,
                    index: 4,
                    onTap: () => showLogoutDialog(context),
                    isDanger: true,
                  ),
                ],
              ),
            ),

            heightBox(26.h),
          ],
        ),
      ),
              ),
              if (state is LoadingState)
                const AppLoaderOverlay(
                  backgroundColor: Color(0x4D000000),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: colorE7E3DA.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: colorE7E3DA.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildProfileItem(
    String title,
    String icon, {
    GestureTapCallback? onTap,
    required int index,
    bool isDanger = false,
  }) {
    final bool fromLeft = index % 2 == 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child:
          Container(
                margin: EdgeInsets.only(
                  top: 4.h,
                  bottom: 4.h,
                  left: 12.w,
                  right: 12.w,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isDanger
                      ? const Color(0xFFFFF6F6)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: isDanger ? const Color(0xFFFFECEC) : colorF9FDFF,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDanger
                              ? const Color(0xFFFFDCDC)
                              : colorE7E3DA.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Center(child: SvgPicture.asset(icon, width: 20.w)),
                    ),
                    widthBox(16.w),
                    Expanded(
                      child: TextWidget(
                        text: title,
                        textStyle: BaseTextStyle.text600.copyWith(
                          fontSize: 15.sp,
                          color: isDanger
                              ? const Color(0xFFC44848)
                              : color09064A,
                        ),
                      ),
                    ),
                    widthBox(8.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: colorE7E3DA,
                    ),
                  ],
                ),
              )
              .animate(delay: (index * 80).ms)
              .fadeIn(duration: 280.ms)
              .slideX(
                begin: fromLeft ? -0.2 : 0.2,
                end: 0,
                curve: Curves.easeOut,
              ),
    );
  }

  /*void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            color: colorWhite,
            child: Column(
              children: [
                SvgPicture.asset(SVGImages.icCloseDialog),
                SvgPicture.asset(SVGImages.icDialogLogout),
                TextWidget(
                  text: strLogoutTitle,
                  textStyle: BaseTextStyle.text700.copyWith(fontSize: 24.sp, color: color09064A),
                ),
                heightBox(8.h),
                TextWidget(
                  text: strLogoutMessage,
                  textStyle: BaseTextStyle.text500.copyWith(fontSize: 16.sp, color: color79747E),
                ),
                heightBox(34.h),
                Row(
                  children: [
                    CommonButton(text: strCancel.toUpperCase(), backgroundColor: colorF3F3F3),
                    widthBox(16.w),
                    CommonButton(text: strYesLogout.toUpperCase(), backgroundColor: colorPrimary),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }*/

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (dialogContext) {
        final dlgL10n = AppLocalizations.of(dialogContext);
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(dialogContext).size.width * 0.85,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ❌ Close Icon
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: color09064A),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18.sp,
                          color: color09064A,
                        ),
                      ),
                    ),
                  ),

                  heightBox(16.h),

                  /// 🔘 Icon Circle
                  SvgPicture.asset(SVGImages.icDialogLogout),

                  heightBox(20.h),

                  /// Title
                  TextWidget(
                    text: dlgL10n.logoutTitle,
                    textStyle: BaseTextStyle.text700.copyWith(
                      fontSize: 18.sp,
                      color: color09064A,
                    ),
                  ),

                  heightBox(8.h),

                  /// Message
                  TextWidget(
                    text: dlgL10n.logoutMessage,
                    textAlign: TextAlign.center,
                    textStyle: BaseTextStyle.text500.copyWith(
                      fontSize: 16.sp,
                      color: color79747E,
                    ),
                  ),

                  heightBox(28.h),

                  /// Buttons
                  Row(
                    children: [
                      /// CANCEL
                      Expanded(
                        child: CommonButton(
                          text: dlgL10n.cancel.toUpperCase(),
                          backgroundColor: colorF3F3F3,
                          textColor: color79747E,
                          onTap: () => Navigator.pop(dialogContext),
                        ),
                      ),

                      widthBox(16.w),

                      /// YES LOGOUT
                      Expanded(
                        child: CommonButton(
                          text: dlgL10n.yesLogout.toUpperCase(),
                          backgroundColor: const Color(
                            0xFFBFDDE5,
                          ), // image-like blue
                          textColor: colorBlack,
                          onTap: () {
                            Navigator.pop(dialogContext);
                            _profileCubit.logout();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (dialogContext) {
        final dlgL10n = AppLocalizations.of(dialogContext);
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(dialogContext).size.width * 0.85,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ❌ Close Icon
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: color09064A),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18.sp,
                          color: color09064A,
                        ),
                      ),
                    ),
                  ),

                  heightBox(16.h),

                  /// 🔘 Icon Circle
                  SvgPicture.asset(SVGImages.icDialogDeleteAccount),

                  heightBox(20.h),

                  /// Title
                  TextWidget(
                    text: dlgL10n.deleteAccountTitle,
                    textStyle: BaseTextStyle.text700.copyWith(
                      fontSize: 18.sp,
                      color: color09064A,
                    ),
                  ),

                  heightBox(8.h),

                  /// Message
                  TextWidget(
                    text: dlgL10n.deleteAccountMessage,
                    textAlign: TextAlign.center,
                    textStyle: BaseTextStyle.text500.copyWith(
                      fontSize: 16.sp,
                      color: color79747E,
                    ),
                  ),

                  heightBox(28.h),

                  /// Buttons
                  Row(
                    children: [
                      /// CANCEL
                      Expanded(
                        child: CommonButton(
                          text: dlgL10n.cancel.toUpperCase(),
                          backgroundColor: colorF3F3F3,
                          textColor: color79747E,
                          onTap: () => Navigator.pop(dialogContext),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),

                      widthBox(16.w),

                      /// YES LOGOUT
                      Expanded(
                        child: CommonButton(
                          text: dlgL10n.delete.toUpperCase(),
                          backgroundColor: const Color(0xFFCF5353),
                          textColor: colorWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          onTap: () {
                            Navigator.pop(dialogContext);
                            _profileCubit.deleteAccount();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
