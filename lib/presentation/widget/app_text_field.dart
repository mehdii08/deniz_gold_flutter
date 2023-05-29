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
  final String? info;
  final String? error;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool obscureText;
  final bool showClearIcon;
  final ValueChanged<String>? onChange;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextAlign textAlign;

  const AppTextField({
    Key? key,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.title,
    this.onChange,
    this.info,
    this.error,
    this.keyboardType,
    this.enabled = true,
    this.obscureText = false,
    this.showClearIcon = true,
    this.textAlign = TextAlign.center,
    this.focusNode,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode focusNode;
  final hasFocusNotifier = ValueNotifier(false);

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(_showClearButton);
    super.initState();
  }

  _showClearButton(){
    hasFocusNotifier.value = focusNode.hasFocus && widget.controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
      ignoring: !widget.enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.standard4),
              child: AppText(
                widget.title!,
                textStyle: AppTextStyle.body5,
                color: AppColors.nature.shade600,
              ),
            ),
          const SizedBox(height: Dimens.standard8),
          Container(
            height: Dimens.standard48,
            color: AppColors.white,
            child: TextField(
              textAlign:widget.textAlign,
              focusNode: focusNode,
              onTap: () {
                if (widget.controller.selection ==
                    TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length - 1))) {
                  setState(() {
                    widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
                  });
                }
              },
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              onChanged: (text) {
                _showClearButton();
                widget.onChange?.call(text);
              },
              textDirection: TextDirection.rtl,
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: widget.textAlign == TextAlign.right ? const EdgeInsets.only(right: Dimens.standard8) : EdgeInsets.zero,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.error != null ? AppColors.red : AppColors.nature.shade900, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.error != null ? AppColors.red : AppColors.nature.shade200, width: 1.0),
                  ),
                  hintText: widget.hint,
                  suffixIcon: widget.prefixIcon,
                  prefixIcon: widget.suffixIcon ?? ValueListenableBuilder<bool>(
                      valueListenable: hasFocusNotifier,
                      builder: (context, hasFocus, _) {
                        return (widget.showClearIcon && hasFocus)
                            ? GestureDetector(
                                onTap: () {
                                  widget.controller.clear();
                                  widget.onChange?.call("");
                                  hasFocusNotifier.value = false;
                                },
                                child: SvgPicture.asset(
                                  'assets/images/close.svg',
                                  fit: BoxFit.none,
                                  color: AppColors.nature.shade900,
                                ),
                              )
                            : const SizedBox();
                      }),
              ),
            ),
          ),
          const SizedBox(height: Dimens.standard8),
          if (widget.info != null)
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    widget.info!,
                    textStyle: AppTextStyle.body5,
                    color: AppColors.nature.shade600,
                  ),
                  const SizedBox(width: Dimens.standard8),
                  //todo check with design
                  SvgPicture.asset('assets/images/info_fill.svg', fit: BoxFit.none),
                ],
              ),
            ),
          if (widget.error != null)
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    widget.error!,
                    textStyle: AppTextStyle.body5,
                    color: AppColors.red,
                  ),
                  const SizedBox(width: Dimens.standard8),
                  //todo check with design
                  SvgPicture.asset('assets/images/info_fill.svg', fit: BoxFit.none),
                ],
              ),
            ),
        ],
      ),
    );
}
