import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final String? title;
  final Widget? prefixIcon;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const AppTextField({
    Key? key,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.title,
    this.onChanged,
    this.keyboardType,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.title != null)
            AppText(
              widget.title!,
              textStyle: AppTextStyle.body5,
              color: AppColors.nature.shade600,
            ),
          const SizedBox(height: Dimens.standard8),
          Container(
            height: Dimens.standard48,
            color: AppColors.white,
            child: TextField(
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              textDirection: TextDirection.rtl,
              controller: widget.controller,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.nature.shade900, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.nature.shade200, width: 1.0),
                ),
                hintText: widget.hint,
                suffixIcon: widget.prefixIcon,
                prefix: GestureDetector(
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged?.call("");
                  },
                  child: SvgPicture.asset(
                    'assets/images/close.svg',
                    fit: BoxFit.none,
                    color: AppColors.nature.shade900,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
