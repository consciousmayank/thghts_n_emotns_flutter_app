import 'package:flutter/material.dart';

class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;

  EnterExitRoute({this.exitPage, this.enterPage})
      : super(
    pageBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,) =>
    enterPage,
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,) =>
        Stack(
          children: <Widget>[
            SizeTransition(
            child: exitPage, sizeFactor: animation,
            ),
            SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: enterPage,
            )
          ],
        ),
  );
}
