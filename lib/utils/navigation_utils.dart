import 'package:flutter/material.dart';

import '../main.dart';
import 'page_transition_utils.dart';

enum NavigationType { pushAndClearStack, pushReplacement, push, pushForResult, goBack }

void navigate({BuildContext? context, Widget? enterPage, bool shouldUseRootNavigator = false, NavigationType navigationType = NavigationType.push, Function? callback, dynamic popData}) {
  FocusManager.instance.primaryFocus?.unfocus();

  final navContext = context ?? rootNavigatorKey.currentContext;
  if (navContext == null) {
    debugPrint("Navigation Error: Navigator context is null.");
    return;
  }

  switch (navigationType) {
    case NavigationType.pushAndClearStack:
      Navigator.of(navContext, rootNavigator: shouldUseRootNavigator).pushAndRemoveUntil(createRoute(page: enterPage!), (Route<dynamic> route) => false);
      break;
    case NavigationType.pushReplacement:
      Navigator.of(navContext, rootNavigator: shouldUseRootNavigator).pushReplacement(createRoute(page: enterPage!));
      break;
    case NavigationType.pushForResult:
      Navigator.of(navContext, rootNavigator: shouldUseRootNavigator).push(createRoute(page: enterPage!)).then((value) {
        callback?.call(value);
      });
      break;
    case NavigationType.push:
      Navigator.of(navContext, rootNavigator: shouldUseRootNavigator).push(createRoute(page: enterPage!));
      break;
    case NavigationType.goBack:
      FocusScope.of(navContext).unfocus();
      Navigator.pop(navContext, popData);
      break;
  }
}
