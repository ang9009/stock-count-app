import 'package:flutter/material.dart';

// Taken from https://stackoverflow.com/questions/50704515/how-to-slide-to-new-page-on-the-right-instead-of-the-bottom-in-flutter
Route createRouteAndSlideIn(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

void goToRoute({
  bool? pushReplacement,
  required BuildContext context,
  required Widget page,
}) {
  if (pushReplacement ?? false) {
    Navigator.of(context).pushReplacement(
      createRouteAndSlideIn(page),
    );
    return;
  }

  Navigator.of(context).push(
    createRouteAndSlideIn(page),
  );
}
