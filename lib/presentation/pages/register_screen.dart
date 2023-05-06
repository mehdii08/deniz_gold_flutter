import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/widget/auth_app_bar.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/blocs/register/register_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';

class RegisterScreen extends StatefulWidget {
  final String mobile;

  const RegisterScreen({
    Key? key,
    required this.mobile,
  }) : super(key: key);

  static final route = GoRoute(
    name: 'RegisterScreen',
    path: '/register',
    builder: (_, state) => RegisterScreen(
      mobile: state.queryParams['token']!,
    ), //make mobile nullable and check null for web version, or you can use redirect for handling it
  );

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class RegisterErrors {
  final String? codeError;
  final String? nameError;
  final String? nationalCodeError;
  final String? passwordError;
  final String? passwordConfirmationError;

  const RegisterErrors({
    this.codeError,
    this.nameError,
    this.nationalCodeError,
    this.passwordError,
    this.passwordConfirmationError,
  });
}

class _RegisterScreenState extends State<RegisterScreen> {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final nationalCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final errors = ValueNotifier<RegisterErrors>(const RegisterErrors());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(title: Strings.registerTitle),
      backgroundColor: AppColors.background,
      body: BlocProvider<RegisterCubit>(
        create: (_) => sl(),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoaded) {
              context.read<AuthenticationCubit>().saveToken(state.token);
            } else if (state is RegisterFailed) {
              showToast(title: state.message, context: context, toastType: ToastType.error);
            }
          },
          builder: (context, state) {
            return ValueListenableBuilder<RegisterErrors>(
              valueListenable: errors,
              builder: (context, registerErrors, _) => SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: Dimens.standard24),
                        AppTextField(
                            controller: nameController, title: Strings.fullName, error: registerErrors.nameError),
                        const SizedBox(height: Dimens.standard20),
                        AppTextField(
                            controller: nationalCodeController,
                            keyboardType: TextInputType.number,
                            title: Strings.nationalCode,
                            error: registerErrors.nationalCodeError),
                        const SizedBox(height: Dimens.standard20),
                        AppTextField(
                            controller: passwordController,
                            title: Strings.password,
                            obscureText: true,
                            info: Strings.atLeast6Chars,
                            error: registerErrors.passwordError),
                        const SizedBox(height: Dimens.standard40),
                        AppButton(
                          isLoading: state is RegisterLoading,
                          text: Strings.signUp,
                          onPressed: () => _validateThenSubmit(() => context.read<RegisterCubit>().register(
                                code: codeController.text,
                                mobile: widget.mobile,
                                name: nameController.text,
                                nationalCode: nationalCodeController.text,
                                password: passwordController.text,
                                passwordConfirmation: passwordConfirmationController.text,
                              )),
                        ),
                        const SizedBox(height: Dimens.standardX)
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _validateThenSubmit(VoidCallback onSubmit) {
    String? code;
    String? name;
    String? nationalCode;
    String? password;
    String? passwordConfirmation;

    if (codeController.text.length < 6) {
      code = Strings.codeError;
    }
    if (nameController.text.length < 3) {
      name = Strings.nameError;
    }
    if (nationalCodeController.text.length < 10) {
      nationalCode = Strings.nationalCodeError;
    }
    if (passwordController.text.length < Dimens.passwordLength) {
      password = Strings.passwordError;
    }
    if (passwordConfirmationController.text.length < Dimens.passwordLength ||
        passwordController.text != passwordConfirmationController.text) {
      passwordConfirmation = Strings.passwordConfirmationError;
    }

    errors.value = RegisterErrors(
      codeError: code,
      nameError: name,
      nationalCodeError: nationalCode,
      passwordError: password,
      passwordConfirmationError: passwordConfirmation,
    );

    if (code == null && name == null && nationalCode == null && password == null && passwordConfirmation == null) {
      onSubmit();
    }
  }
}
