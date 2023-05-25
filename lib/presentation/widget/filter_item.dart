import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterItem<T> extends StatefulWidget {
  final String title;
  final String? svgIcon;
  final Map<String, T> selectableItems;
  final Function(String?) onChange;

  const FilterItem({
    Key? key,
    required this.title,
    required this.selectableItems,
    required this.onChange,
    this.svgIcon,
  }) : super(key: key);

  @override
  State<FilterItem<T>> createState() => _FilterItemState<T>();
}

class _FilterItemState<T> extends State<FilterItem<T>> {
  final selectedKeyNotifier = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String?>(
        valueListenable: selectedKeyNotifier,
        builder: (context, selectedKey, _) => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.standard16,
            vertical: Dimens.standard6,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard8)),
            border: Border.all(color: AppColors.nature.shade50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (selectedKey != null) ...[
                GestureDetector(
                  onTap: (){
                    selectedKeyNotifier.value = null;
                    widget.onChange.call(null);
                  },
                  child: SvgPicture.asset(
                    'assets/images/close.svg',
                    width: Dimens.standard20,
                    fit: BoxFit.fitWidth,
                    color: AppColors.nature.shade600,
                  ),
                ),
                const SizedBox(width: Dimens.standard12),
                Container(
                  width: Dimens.standard1,
                  height: Dimens.standard15,
                  color: AppColors.nature.shade100,
                ),
                const SizedBox(width: Dimens.standard12),
              ],
              GestureDetector(
                onTap: () {
                  showSingleSelectBottomSheet<T>(
                    context: context,
                    title: Strings.selectDate,
                    selectableItems: widget.selectableItems,
                    selectedKey: selectedKey,
                    onChange: (key) {
                      selectedKeyNotifier.value = key;
                      widget.onChange.call(key);
                    },
                  );
                },
                child: AppText(
                  selectedKey ?? widget.title,
                  textStyle: AppTextStyle.button4,
                  color: AppColors.nature.shade600,
                ),
              ),
              if (widget.svgIcon != null) ...[
                const SizedBox(width: Dimens.standard12),
                SvgPicture.asset(
                  widget.svgIcon!,
                  width: Dimens.standard20,
                  fit: BoxFit.fitWidth,
                  color: AppColors.nature.shade600,
                )
              ]
            ],
          ),
        ),
      );
}
