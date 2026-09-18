import 'dart:io';

import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        FloatingActionButtonLocation,
        FocusNode,
        FocusScope,
        GestureDetector,
        GlobalKey,
        MediaQuery,
        PreferredSizeWidget,
        SafeArea,
        Scaffold,
        ScaffoldState,
        Size,
        SizedBox,
        State,
        StatefulWidget,
        Theme,
        ThemeData,
        Widget,
        AnnotatedRegion,
        protected,
        Colors;

import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../res/color.dart';

abstract class BaseStatefulWidgetState<StateMVC extends StatefulWidget>
    extends State<StateMVC> {
  late ThemeData baseTheme;
  bool shouldShowProgress = false;
  bool shouldHaveSafeArea = Platform.isIOS ? false : true;
  bool resizeToAvoidBottomInset = false;
  final rootScaffoldKey = GlobalKey<ScaffoldState>();
  late Size screenSize;
  bool isBackgroundImage = false;
  bool extendBodyBehindAppBar = false;
  Color? scaffoldBgColor;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  final FocusNode _dismissFocusNode = FocusNode();

  SystemUiOverlayStyle get systemUiOverlayStyle =>
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent);

  @override
  void didChangeDependencies() {
    baseTheme = Theme.of(context);
    screenSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dismissFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = buildBody(context);
    if (shouldHaveSafeArea) {
      bodyContent = SafeArea(
        bottom: true,
        child: !isBackgroundImage
            ? bodyContent
            : SizedBox(
                width: screenSize.width,
                height: screenSize.height,
                child: bodyContent,
              ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: GestureDetector(
        onTap: () => FocusScope.of(
          rootScaffoldKey.currentContext!,
        ).requestFocus(_dismissFocusNode),
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          key: rootScaffoldKey,
          extendBody: false,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          backgroundColor: scaffoldBgColor ?? colorWhite,
          appBar: buildAppBar(context),
          body: bodyContent,
          bottomNavigationBar: buildBottomNavigationBar(context),
          floatingActionButton: buildFloating(context),
          floatingActionButtonLocation: floatingActionButtonLocation,
        ),
      ),
    );
  }

  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  Widget buildBody(BuildContext context) {
    return widget;
  }

  Widget? buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  Widget? buildFloating(BuildContext context) {
    return null;
  }
}
