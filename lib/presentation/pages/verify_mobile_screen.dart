import 'dart:async';

import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/blocs/verify_mobile/verify_mobile_cubit.dart';
import 'package:deniz_gold/presentation/pages/register_screen.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/flat_app_bar.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';

class VerifyMobileScreen extends StatefulWidget {
  final String mobile;
  final bool isRegister;

  const VerifyMobileScreen({
    Key? key,
    required this.mobile,
    this.isRegister = true,
  }) : super(key: key);

  static final route = GoRoute(
    name: 'VerifyMobileScreen',
    path: '/verify-mobile',
    builder: (_, state) => VerifyMobileScreen(
      mobile: state.queryParams['mobile']!,
    ), //make mobile nullable and check null for web version, or you can use redirect for handling it
  );

  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  final controller = TextEditingController();
  final codeIsValid = ValueNotifier<bool>(false);

  late Timer _timer;
  int _time = 120;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_time == 0) {
          setState(() {
            //todo show resend button
            timer.cancel();
          });
        } else {
          setState(() {
            _time--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: const AuthAppBar(),
          backgroundColor: AppColors.background,
          body: BlocProvider<VerifyMobileCubit>(
            create: (_) => sl(),
            child: BlocConsumer<VerifyMobileCubit, VerifyMobileState>(
              listener: (context, state) {
                if (state is VerifyMobileSuccess) {
                  context.goNamed(RegisterScreen.route.name!, queryParams: {'token': state.token});
                } else if (state is VerifyMobileFailed) {
                  showToast(title: state.message, context: context, toastType: ToastType.error);
                }
              },
              builder: (context, state) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimens.standard16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(
                        getDescription(widget.mobile),
                        textStyle: AppTextStyle.body4,
                        color: AppColors.nature.shade900,
                      ),
                      const SizedBox(height: Dimens.standard8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: Dimens.standard8, vertical: Dimens.standard4),
                            child: AppText(
                              Strings.editPhoneNumber,
                              textStyle: AppTextStyle.button4,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimens.standard32),
                      AppTextField(
                          controller: controller,
                          keyboardType: TextInputType.phone,
                          enabled: state is! VerifyMobileLoading,
                          onChanged: (text) {
                            codeIsValid.value = text.length == 6;
                          }),
                      const SizedBox(height: Dimens.standard12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.standard8, vertical: Dimens.standard4),
                        child: AppText(
                          getCountDownText(),
                          textStyle: AppTextStyle.body5,
                          color: AppColors.nature.shade600,
                        ),
                      ),
                      const SizedBox(height: Dimens.standard24),
                      ValueListenableBuilder<bool>(
                          valueListenable: codeIsValid,
                          builder: (context, isValid, _) => AppButton(
                                onPressed: isValid
                                    // ? () => context.read<VerifyMobileCubit>().verify(mobile: widget.mobile, code: controller.text)
                                    ? () => context.goNamed(RegisterScreen.route.name!,
                                        queryParams: {'token': 'state.token'}) //todo remove me
                                    : null,
                                text: Strings.confirm,
                                isLoading: state is VerifyMobileLoading,
                              ))
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

  String getDescription(String mobile) =>
      "کد ۴ رقمی به شماره $mobile ارسال شد. لطفا پس از دریافت، کد را در کادر پایین وارد کنید.";

  String getCountDownText() => "$_time ثانیه تا ارسال مجدد";
}
