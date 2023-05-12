import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/widget/title_app_bar.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deniz_gold/presentation/blocs/reset_password/reset_password_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/check_mobile_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String mobile;
  final String token;

  const ResetPasswordScreen({
    Key? key,
    required this.mobile,
    required this.token,
  }) : super(key: key);

  static final route = GoRoute(
    name: 'ResetPasswordScreen',
    path: '/reset-password',
    builder: (_, state) => ResetPasswordScreen(
      mobile: state.queryParams['mobile']!,
      token: state.queryParams['token']!,
    ), //make mobile nullable and check null for web version, or you can use redirect for handling it
  );

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final errors = ValueNotifier<ResetPasswordErrors>(const ResetPasswordErrors());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppBar(title: Strings.resetPasswordTitle,),
      backgroundColor: AppColors.background,
      body: BlocProvider<ResetPasswordCubit>(
        create: (_) => sl(),
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordLoaded) {
              showToast(title: state.message,context: context, onClose: ()=>context.goNamed(CheckMobileScreen.route.name!));
            } else if (state is ResetPasswordFailed) {
              showToast(title: state.message,context: context,toastType: ToastType.error);
            }
          },
          builder: (context, state) {
            return ValueListenableBuilder<ResetPasswordErrors>(
                valueListenable: errors,
                builder: (context, resetPasswordErrors, _) => SafeArea(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: Dimens.standard32),
                            AppTextField(
                              title: Strings.enterNewPassword,
                              controller: passwordController,
                              obscureText: true,
                              error: resetPasswordErrors.passwordError,
                              info: Strings.atLeast6Chars,
                            ),
                            const SizedBox(height: Dimens.standard40),
                            AppButton(
                              isLoading: state is ResetPasswordLoading,
                              text: Strings.resetPassword,
                              onPressed: () =>
                                  _validateThenSubmit(() => context.read<ResetPasswordCubit>().resetPassword(
                                    token: widget.token,
                                    mobile: widget.mobile,
                                    password: passwordController.text,
                                    passwordConfirmation: passwordController.text,
                                  )),
                            ),
                            const SizedBox(height: Dimens.standardX)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            );
          },
        ),
      ),
    );
  }

  _validateThenSubmit(VoidCallback onSubmit) {
    String? password;

    if (passwordController.text.length < Dimens.passwordLength) {
      password = Strings.passwordError;
    }

    errors.value = ResetPasswordErrors(
      passwordError: password,
    );

    if (password == null) {
      onSubmit();
    }
  }
}

class ResetPasswordErrors {
  final String? passwordError;

  const ResetPasswordErrors({
    this.passwordError,
  });
}
