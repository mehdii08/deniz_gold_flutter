import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/validators.dart';
import 'package:deniz_gold/presentation/pages/verify_mobile_screen.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/flat_app_bar.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deniz_gold/presentation/blocs/forgetPassword/forget_password_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final String? mobile;

  const ForgetPasswordScreen({Key? key, this.mobile}) : super(key: key);

  static final route = GoRoute(
    name: 'ForgetPassword',
    path: '/forget-password',
    builder: (_, state) {
      return ForgetPasswordScreen(mobile: state.queryParams['mobile']);
    },
  );

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final controller = TextEditingController();
  final mobileIsValid = ValueNotifier<bool>(false);

  @override
  void initState() {
    if (widget.mobile != null) {
      controller.text = widget.mobile!;
      mobileIsValid.value = isMobile(controller.text);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(title: Strings.forgetPasswordTitle),
      backgroundColor: AppColors.background,
      body: BlocProvider<ForgetPasswordCubit>(
        create: (_) => sl(),
        child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(listener: (context, state) {
          if (state is ForgetPasswordLoaded) {
            context.pushNamed(
                VerifyMobileScreen.route.name!,
                queryParams: {'mobile' : state.mobile, 'isRegister' : 'false'});
          } else if (state is ForgetPasswordFailed) {
            showToast(title: state.message, context: context, toastType: ToastType.error);
          }
        }, builder: (context, state) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimens.standard16),
                    Align(
                        alignment: Alignment.topRight,
                        child: AppText(
                          Strings.forgetPasswordDescription,
                          textStyle: AppTextStyle.body4,
                        )),
                    const SizedBox(height: Dimens.standard32),
                    AppTextField(
                      controller: controller,
                      title: Strings.mobile,
                      onChange: (text){
                        mobileIsValid.value = isMobile(text);
                      },
                    ),
                    const SizedBox(height: Dimens.standard32),
                    ValueListenableBuilder<bool>(
                        valueListenable: mobileIsValid,
                        builder: (context, isValid, _) {
                          return AppButton(
                            text: Strings.checkPhoneNumber,
                            onPressed: isValid ? () => context.read<ForgetPasswordCubit>().sendOTPCode(controller.text) : null,
                            isLoading: state is ForgetPasswordLoading,
                          );
                        }),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
