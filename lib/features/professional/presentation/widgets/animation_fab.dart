import 'package:flutter/material.dart';

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
    : super(
    pageBuilder: (context, firstAnimation, secondAnimation) => page,
    transitionsBuilder: (context, firstAnimation, secondAnimation, child) {
      return FadeTransition(opacity: firstAnimation, child: child);
    },
  );
}