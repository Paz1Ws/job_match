import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransitionPageWithFade extends CustomTransitionPage {

  TransitionPageWithFade({
    required super.child,
    required GoRouterState state,
    super.opaque,
    super.barrierDismissible,
    super.barrierColor
  }) : super(
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
    key: state.pageKey
  );
}