import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 240),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.fastOutSlowIn;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

Route<dynamic> createRoute({required Widget page}) {
  if (Theme.of(rootNavigatorKey.currentContext!).platform == TargetPlatform.iOS) {
    return CupertinoPageRoute(builder: (_) => page);
  } else {
    return SlideLeftRoute(page: page);
  }
}
