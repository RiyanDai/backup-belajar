import 'package:flutter/material.dart';

class DialogPage<T> extends Page<T> {
  final Widget child;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;

  const DialogPage({
    required this.child,
    this.barrierColor = const Color(0x99000000),
    this.barrierDismissible = true,
    this.barrierLabel = 'Dismiss',
    super.key,
    super.name,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return RawDialogRoute<T>(
      settings: this,
      barrierColor: barrierColor ?? const Color(0x99000000),
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}

