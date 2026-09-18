import 'package:flutter/material.dart';
import 'package:thredo/base/base_stateful_widget_state.dart';
import 'package:thredo/res/color.dart';
import 'package:thredo/widget/common_appbar.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String type;
  const WebViewScreen({super.key,required this.title,required this.type});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends BaseStatefulWidgetState<WebViewScreen> {

  String navUrl = '';
  bool pageLoading = true;

  @override
  bool get extendBodyBehindAppBar => false;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CommonAppBar(title: widget.title);
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      color: backgroundColor,
    );
  }

}
