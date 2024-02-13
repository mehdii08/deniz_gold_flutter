import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/blocs/check_mobile/check_mobile_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/login_screen.dart';
import 'package:deniz_gold/presentation/pages/verify_mobile_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_logo.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/get_mobile_widget.dart';
import 'package:deniz_gold/presentation/widget/support_icon.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckMobileScreen extends StatefulWidget {
  static final route = GoRoute(
    name: 'CheckMobileScreen',
    path: '/check-mobile',
    builder: (_, __) => const CheckMobileScreen(),
  );

  const CheckMobileScreen({Key? key}) : super(key: key);

  @override
  State<CheckMobileScreen> createState() => _CheckMobileScreenState();
}

class _CheckMobileScreenState extends State<CheckMobileScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider<CheckMobileCubit>(
        create: (_) => sl(),
        child: BlocConsumer<CheckMobileCubit, CheckMobileState>(
            listener: (context, state) {
          if (state is CheckMobileLoaded) {
            context.pushNamed(
                state.exists ? LoginScreen.route.name! : VerifyMobileScreen.route.name!,
                queryParams: {'mobile' : state.mobile, 'isRegister' : 'true', 'smsOtpCodeExpirationTime' : state.smsOtpCodeExpirationTime.toString()});
          } else if (state is CheckMobileFailed) {
            showToast(
                title: state.message,
                context: context,
                toastType: ToastType.error);
          }
        }, builder: (context, state) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Dimens.standard16,
                        Dimens.standard12,
                        Dimens.standard16,
                        Dimens.standard24),
                    child: Column(
                      children: const [
                        Align(
                            alignment: Alignment.topLeft, child: SupportIcon()),
                        AppLogo(logoWidth: Dimens.standard120),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimens.standard16),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Dimens.standard16)),
                      ),
                      child: GetMobileWidget(
                        showRules: true,
                        controller: controller,
                        isLoading: state is CheckMobileLoading,
                        title: Strings.loginRegister,
                        onPressed: (String mobile) => context
                            .read<CheckMobileCubit>()
                            .checkMobileExists(mobile),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
