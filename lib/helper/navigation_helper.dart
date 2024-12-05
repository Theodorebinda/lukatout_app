import 'package:flutter/material.dart';

class NavigationHelper {
  static void navigateWithTransition(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(3.0, 0.0); // Transition depuis le bas
          const end = Offset.zero;
          const curve = Curves.decelerate;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }
}

class DynamicPageTransition {
  static PageRouteBuilder<dynamic> createRoute(
      {required Widget page,
      Duration duration = const Duration(milliseconds: 500),
      Offset begin = const Offset(0.0, 0.1),
      Offset end = const Offset(0.0, 0.0),
      Curve curve = Curves.easeInOut}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }
}
