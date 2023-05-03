import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deniz_gold/presentation/blocs/login/login_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/splash_screen.dart';
import 'package:deniz_gold/presentation/widget/app_logo.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: BlocProvider<LoginCubit>(
        create: (_) => sl(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.goNamed(SplashScreen.route.name!);
            } else if (state is LoginFailed) {
              showToast(title: state.message,context: context,toastType: ToastType.error);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AppLogo(),
                      const SizedBox(height: Dimens.standard2X),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
                        // child: AppCard(
                        //   title: Strings.login,
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
                        //     child: SizedBox(
                        //       width: double.infinity,
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Align(
                        //             alignment: Alignment.center,
                        //             child: Text(
                        //               widget.mobile,
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .labelMedium
                        //                   ?.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //           Align(
                        //             alignment: Alignment.center,
                        //             child: GestureDetector(
                        //               onTap: () => Navigator.of(context).pop(),
                        //               child: Text(
                        //                 Strings.editPhoneNumber,
                        //                 style: Theme.of(context).textTheme.caption?.copyWith(
                        //                       color: AppColors.red,
                        //                     ),
                        //               ),
                        //             ),
                        //           ),
                        //           const SizedBox(height: Dimens.standard2X),
                        //           Text(
                        //             Strings.password,
                        //             style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                        //           ),
                        //           const SizedBox(height: Dimens.standardX),
                        //           AppTextField(
                        //             controller: controller,
                        //             obscureText: true,
                        //             onChange: (value) => passwordValidator.value = value.length >= Dimens.passwordLength,
                        //           ),
                        //           const SizedBox(height: Dimens.standardX),
                        //           ValueListenableBuilder<bool>(
                        //             valueListenable: passwordValidator,
                        //             builder: (context, isValid, _) => AppButton(
                        //               enabled: isValid,
                        //               isLoading: state is LoginLoading,
                        //               title: Strings.login,
                        //               onPressed: () {
                        //                 context
                        //                     .read<LoginCubit>()
                        //                     .login(mobile: widget.mobile, password: controller.text);
                        //               },
                        //             ),
                        //           ),
                        //           const SizedBox(height: Dimens.standard2X),
                        //           Align(
                        //             alignment: Alignment.center,
                        //             child: GestureDetector(
                        //               onTap: () => context.pushNamed(ForgetPasswordScreen.route.name!,
                        //                   queryParams: {'mobile': widget.mobile}),
                        //               child: Text(
                        //                 Strings.forgetPassword,
                        //                 style: Theme.of(context)
                        //                     .textTheme
                        //                     .labelMedium
                        //                     ?.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold),
                        //               ),
                        //             ),
                        //           ),
                        //           const SizedBox(height: Dimens.standard2X),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
