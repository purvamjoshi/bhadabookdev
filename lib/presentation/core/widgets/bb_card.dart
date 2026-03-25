import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';

class BBCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? radius;

  const BBCard({super.key, required this.child, this.padding, this.onTap, this.color, this.radius});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.cardBg,
      borderRadius: radius ?? S.cardR,
      child: InkWell(
        onTap: onTap, borderRadius: radius ?? S.cardR,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius ?? S.cardR,
            border: Border.all(color: AppColors.border),
          ),
          padding: padding ?? S.cardAll,
          child: child,
        ),
      ),
    );
  }
}
