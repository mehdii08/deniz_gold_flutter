import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;

  const CircleIcon({
    Key? key,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Opacity(
      opacity: onTap != null ? 1 : 0.2,
      child: Container(
        width: Dimens.standard40,
        height: Dimens.standard40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.nature.shade900,
        ),
        child: Image.asset(
          icon,
          color: AppColors.white,
        ),
      ),
    ),
  );
}