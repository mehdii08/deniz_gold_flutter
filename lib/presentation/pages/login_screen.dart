import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/pages/forget_password_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/title_app_bar.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deniz_gold/presentation/blocs/login/login_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/splash_screen.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';

class LoginScreen extends StatefulWidget {
  final String mobile;

  const LoginScreen({
    Key? key,
    required this.mobile,
  }) : super(key: key);

  static final route = GoRoute(
    name: 'LoginScreen',
    path: '/login',
    builder: (_, state) => LoginScreen(
      mobile: state.queryParams['mobile']!,
    ), //make mobile nullable and check null for web version, or you can use redirect for handling it
  );

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = TextEditingController();
  final passwordValidator = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      appBar: const TitleAppBar(title: Strings.loginTitle),
      backgroundColor: AppColors.background,
      body: BlocProvider<LoginCubit>(
        create: (_) => sl(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.read<AppConfigCubit>().getConfig();
              context.pushNamed(SplashScreen.route.name!);
            } else if (state is LoginFailed) {
              showToast(title: state.message,context: context,toastType: ToastType.error);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimens.standard32),
                    AppTextField(
                      title: Strings.enterPassword,
                      controller: controller,
                      obscureText: true,
                      onChange: (value) => passwordValidator.value = value.length >= Dimens.passwordLength,
                    ),
                    const SizedBox(height: Dimens.standard12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => context.pushNamed(ForgetPasswordScreen.route.name!,
                            queryParams: {'mobile': widget.mobile}),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            Strings.forgetPassword,
                            style: AppTextStyle.button4.copyWith(color: AppColors.blue),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimens.standard32),
                    ValueListenableBuilder<bool>(
                      valueListenable: passwordValidator,
                      builder: (context, isValid, _) => AppButton(
                        isLoading: state is LoginLoading,
                        text: Strings.login,
                        onPressed: isValid ? () {
                          context
                              .read<LoginCubit>()
                              .login(mobile: widget.mobile, password: controller.text);
                        } : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
