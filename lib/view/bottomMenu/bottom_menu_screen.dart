import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/l10n/app_localizations.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/res/image.dart';
import 'package:thredo/res/style.dart';
import 'package:thredo/view/category/category_screen.dart';
import 'package:thredo/view/company/company_screen.dart';
import 'package:thredo/view/home/home_screen.dart';
import 'package:thredo/view/profile/profile_screen.dart';
import 'package:thredo/view/threadMatch/thread_match_screen.dart';
import 'package:thredo/widget/common_button.dart';
import 'package:thredo/widget/common_widgets.dart';
import 'package:thredo/widget/text_widget.dart';

class BottomMenuScreen extends StatefulWidget {
  const BottomMenuScreen({super.key});

  @override
  State<BottomMenuScreen> createState() => _BottomMenuScreenState();
}

class _BottomMenuScreenState extends BaseStatefulWidgetState<BottomMenuScreen> {
  static const int _homeTabIndex = 0;
  static const int _tabCount = 5;

  int _selectedIndex = _homeTabIndex;

  /// Lazily built tabs — only visited screens are initialised (saves startup APIs).
  final List<Widget?> _tabs = List<Widget?>.filled(_tabCount, null);

  @override
  void initState() {
    super.initState();
    floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked;
    _tabs[_homeTabIndex] = HomeScreen(onTabChanged: _onItemTapped);
  }

  Widget _tabAt(int index) {
    return _tabs[index] ??= _createTab(index);
  }

  Widget _createTab(int index) {
    switch (index) {
      case 0:
        return HomeScreen(onTabChanged: _onItemTapped);
      case 1:
        return const CategoryScreen();
      case 2:
        return const ThreadMatchScreen();
      case 3:
        return const CompanyScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _handleBackNavigation(context);
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            key: rootScaffoldKey,
            extendBody: true,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            backgroundColor: scaffoldBgColor ?? colorWhite,
            appBar: buildAppBar(context),
            body: buildBody(context),
            bottomNavigationBar: buildBottomNavigationBar(context),
            floatingActionButton: buildFloating(context),
            floatingActionButtonLocation: floatingActionButtonLocation,
          ),
        ),
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    if (_selectedIndex != _homeTabIndex) {
      setState(() => _selectedIndex = _homeTabIndex);
      return;
    }
    _showExitDialog(context);
  }

  void _showExitDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: colorBlack.withValues(alpha: 0.4),
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext);
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.sizeOf(dialogContext).width * 0.85,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(color: colorBlack.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        child: Icon(Icons.close, size: 18.sp, color: color09064A),
                      ),
                    ),
                  ),
                  heightBox(16.h),
                  Icon(Icons.exit_to_app_rounded, size: 48.sp, color: color09064A),
                  heightBox(20.h),
                  TextWidget(
                    text: l10n.exitAppTitle,
                    textStyle: BaseTextStyle.text700.copyWith(fontSize: 18.sp, color: color09064A),
                  ),
                  heightBox(8.h),
                  TextWidget(
                    text: l10n.exitAppMessage,
                    textAlign: TextAlign.center,
                    textStyle: BaseTextStyle.text500.copyWith(fontSize: 16.sp, color: color79747E),
                  ),
                  heightBox(28.h),
                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          text: l10n.cancel.toUpperCase(),
                          backgroundColor: colorF3F3F3,
                          textColor: color79747E,
                          onTap: () => Navigator.pop(dialogContext),
                        ),
                      ),
                      widthBox(16.w),
                      Expanded(
                        child: CommonButton(
                          text: l10n.yesExit.toUpperCase(),
                          backgroundColor: const Color(0xFFBFDDE5),
                          textColor: colorBlack,
                          onTap: () {
                            Navigator.pop(dialogContext);
                            SystemNavigator.pop();
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

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  bool get resizeToAvoidBottomInset => false;

  @override
  bool get shouldHaveSafeArea => false;

  @override
  Widget buildBody(BuildContext context) {
    _tabAt(_selectedIndex);
    return IndexedStack(
      index: _selectedIndex,
      sizing: StackFit.expand,
      children: List.generate(_tabCount, (i) => _tabs[i] ?? const SizedBox.shrink()),
    );
  }

  @override
  Widget? buildFloating(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _onItemTapped(2),
      backgroundColor: selectedIconColor,
      elevation: 4,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        SVGImages.icMatchProduct,
        width: 40.w,
        height: 40.w,
        colorFilter: const ColorFilter.mode(colorWhite, BlendMode.srcIn),
      ),
    );
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomAppBar(
      padding: EdgeInsets.zero,
      height: 60.h,
      color: colorWhite,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.w,
      child: Row(
        children: [
          _buildTabItem(svgPath: SVGImages.icHomeBottom, label: l10n.navHome, index: 0),
          _buildTabItem(svgPath: SVGImages.icCategoryBottom, label: l10n.screenCategory, index: 1),
          _buildMiddleSpace(l10n.navMatch),
          _buildTabItem(svgPath: SVGImages.icCompanyBottom, label: l10n.navCompany, index: 3),
          _buildTabItem(svgPath: SVGImages.icProfileBottom, label: l10n.navProfile, index: 4),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String svgPath, required String label, required int index}) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? selectedIconColor : unselectedIconColor;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath, width: 24.w, height: 24.w, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
            TextWidget(
              text: label,
              textStyle: BaseTextStyle.text600.copyWith(fontSize: 10.sp, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleSpace(String label) {
    final isSelected = _selectedIndex == 2;
    final color = isSelected ? selectedIconColor : unselectedIconColor;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24.h), // Offset to put label below FAB notch
          TextWidget(
            text: label,
            textStyle: BaseTextStyle.text600.copyWith(fontSize: 10.sp, color: color),
          ),
        ],
      ),
    );
  }
}

class _MatchIcon extends StatelessWidget {
  const _MatchIcon({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: active ? selectedIconColor : colorE7E3DA.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: active
            ? [BoxShadow(color: selectedIconColor.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 2))]
            : null,
      ),
      child: Center(
        child: SvgPicture.asset(
          SVGImages.icMatchProduct,
          width: 16.w,
          height: 16.w,
          colorFilter: ColorFilter.mode(active ? colorWhite : color09064A, BlendMode.srcIn),
        ),
      ),
    );
  }
}
