import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/validators.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GetMobileWidget extends StatefulWidget {
  final String title;
  final bool isLoading;
  final Function(String) onPressed;
  final TextEditingController controller;
  final bool showRules;

  const GetMobileWidget({
    Key? key,
    required this.controller,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.showRules = false,
  }) : super(key: key);

  @override
  State<GetMobileWidget> createState() => _GetMobileWidgetState();
}

class _GetMobileWidgetState extends State<GetMobileWidget> {
  final mobileIsValid = ValueNotifier<bool>(false);

  @override
  void initState() {
    mobileIsValid.value = isMobile(widget.controller.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          Strings.loginRegister,
          textStyle: AppTextStyle.subTitle3,
        ),
        const SizedBox(height: Dimens.standard24),
        AppTextField(
            keyboardType: TextInputType.phone,
            controller: widget.controller,
            title: Strings.enterMobile,
            prefixIcon: SvgPicture.asset(
              'assets/images/mobile.svg',
              fit: BoxFit.none,
              color: AppColors.nature,
            ),
            enabled: !widget.isLoading,
            onChange: (text) {
              mobileIsValid.value = isMobile(text);
            }),
        const SizedBox(height: Dimens.standard32),
        ValueListenableBuilder<bool>(
            valueListenable: mobileIsValid,
            builder: (context, isValid, _) => AppButton(
                  onPressed: isValid
                      ? () => widget.onPressed(widget.controller.text)
                      : null,
                  text: Strings.confirm,
                  isLoading: widget.isLoading,
                )),

        const SizedBox(height: Dimens.standard32),
        GestureDetector(
          onTap: () async {
            await launchUrlString('https://golddeniz.ir/privacy',
            mode: LaunchMode.externalApplication);
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'ورود شما به معنای پذیرش',
                  style: AppTextStyle.body4,
                ),
                TextSpan(
                    text: ' قوانین ',
                    style: AppTextStyle.body3.copyWith(color: AppColors.blue),
                ),
                TextSpan(
                  text: 'آبشده فروشی دنیز است',
                  style: AppTextStyle.body4,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
