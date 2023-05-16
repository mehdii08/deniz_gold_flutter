import 'package:deniz_gold/core/utils/validators.dart';
import 'package:deniz_gold/presentation/blocs/account_info/account_info_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditPasswordSheetContent extends StatefulWidget {

  const EditPasswordSheetContent({Key? key,}) : super(key: key);

  @override
  State<EditPasswordSheetContent> createState() => _EditPasswordSheetContentState();
}

class _EditPasswordSheetContentState extends State<EditPasswordSheetContent> {
  final firstStepPassedNotifier = ValueNotifier<bool>(false);
  String _currentPassword = "";
  String _newPassword = "";

  @override
  Widget build(BuildContext context) => SafeArea(
        child: BlocProvider<AccountInfoCubit>(
          create: (_) => sl(),
          child: BlocConsumer<AccountInfoCubit, AccountInfoState>(
            listener: (context, state) {
              if (state is AccountInfoFailed) {
                showToast(title: state.message, context: context, toastType: ToastType.error);
              } else if (state is AccountInfoLoaded) {
                context.pop();
                showToast(title: state.message, context: context, toastType: ToastType.success);
              }
            },
            builder: (context, state) => ValueListenableBuilder<bool>(
                valueListenable: firstStepPassedNotifier,
                builder: (context, firstStepPassed, _) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: firstStepPassed
                          ? EditPasswordSheetSecondStep(
                              isLoading: state is AccountInfoLoading,
                              onPasswordConfirmed: (password) {
                                _newPassword = password;
                                context.read<AccountInfoCubit>().updatePassword(
                                      currentPassword: _currentPassword,
                                      newPassword: _newPassword,
                                    );
                              },
                            )
                          : EditPasswordSheetFirstStep(
                              onPasswordConfirmed: (currentPassword) {
                                _currentPassword = currentPassword;
                                firstStepPassedNotifier.value = true;
                              },
                            ),
                    )),
          ),
        ),
      );
}

class EditPasswordSheetFirstStep extends StatefulWidget {
  final Function(String) onPasswordConfirmed;

  const EditPasswordSheetFirstStep({
    Key? key,
    required this.onPasswordConfirmed,
  }) : super(key: key);

  @override
  State<EditPasswordSheetFirstStep> createState() => _EditPasswordSheetFirstStepState();
}

class _EditPasswordSheetFirstStepState extends State<EditPasswordSheetFirstStep> {
  final controller = TextEditingController();
  final passwordIsValidNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
        child: Column(
          children: [
            const SizedBox(height: Dimens.standard24),
            AppTextField(
              controller: controller,
              title: Strings.enterYourCurrentPassword,
              onChange: (text) => passwordIsValidNotifier.value = passwordIsValid(password: text),
            ),
            const SizedBox(height: Dimens.standard32),
            ValueListenableBuilder<bool>(
              valueListenable: passwordIsValidNotifier,
              builder: (context, passwordIsValid, _) => AppButton(
                  text: Strings.confirm,
                  onPressed: passwordIsValid ? () => widget.onPasswordConfirmed(controller.text) : null,
                ),
            ),
            const SizedBox(height: Dimens.standard24),
          ],
        ),
      );
}

class EditPasswordSheetSecondStep extends StatefulWidget {
  final Function(String) onPasswordConfirmed;
  final bool isLoading;

  const EditPasswordSheetSecondStep({
    Key? key,
    required this.onPasswordConfirmed,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<EditPasswordSheetSecondStep> createState() => _EditPasswordSheetSecondStepState();
}

class _EditPasswordSheetSecondStepState extends State<EditPasswordSheetSecondStep> {
  final controller = TextEditingController();
  final passwordIsValidNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
        child: Column(
          children: [
            const SizedBox(height: Dimens.standard24),
            AppTextField(
              controller: controller,
              title: Strings.enterYourNewPassword,
              info: Strings.atLeast6Chars,
              onChange: (text) => passwordIsValidNotifier.value = passwordIsValid(password: text),
            ),
            const SizedBox(height: Dimens.standard32),
            ValueListenableBuilder<bool>(
              valueListenable: passwordIsValidNotifier,
              builder: (context, passwordIsValid, _) => AppButton(
                  isLoading: widget.isLoading,
                  text: Strings.editPassword,
                  onPressed: passwordIsValid ? () => widget.onPasswordConfirmed(controller.text) : null),
            ),
            const SizedBox(height: Dimens.standard24),
          ],
        ),
      );
}
