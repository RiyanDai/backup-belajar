import 'package:flutter/material.dart';
import '../../common/styles.dart';

class GradientHeaderBackground extends StatelessWidget {
  final Widget child;

  const GradientHeaderBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryLight,
            AppColors.scaffoldBackground,
          ],
          stops: [0.0, 0.28],
        ),
      ),
      child: child,
    );
  }
}
