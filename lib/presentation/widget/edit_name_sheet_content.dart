import 'package:deniz_gold/presentation/blocs/account_info/account_info_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditNameSheetContent extends StatefulWidget {
  final String name;
  final VoidCallback onNameEdited;

  const EditNameSheetContent({
    Key? key,
    required this.name,
    required this.onNameEdited,
  }) : super(key: key);

  @override
  State<EditNameSheetContent> createState() => _EditNameSheetContentState();
}

class _EditNameSheetContentState extends State<EditNameSheetContent> {
  late TextEditingController controller;
  late ValueNotifier<bool> nameIsValidNotifier;

  @override
  void initState() {
    controller = TextEditingController(text: widget.name);
    nameIsValidNotifier = ValueNotifier<bool>(nameIsValid(name: widget.name));
    super.initState();
  }

  bool nameIsValid({required String name}) => name.length > 3;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: BlocProvider<AccountInfoCubit>(
      create: (_) => sl(),
      child: BlocConsumer<AccountInfoCubit, AccountInfoState>(
        listener: (context, state) {
          if (state is AccountInfoFailed) {
            showToast(title: state.message, context: context, toastType: ToastType.error);
          } else if (state is AccountInfoLoaded) {
            widget.onNameEdited();
          }
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
          child: Column(
            children: [
              const SizedBox(height: Dimens.standard24),
              AppTextField(
                enabled: state is! AccountInfoLoading,
                controller: controller,
                title: Strings.enterFullName,
                onChange: (text) => nameIsValidNotifier.value = nameIsValid(name: text),
              ),
              const SizedBox(height: Dimens.standard32),
              ValueListenableBuilder<bool>(
                valueListenable: nameIsValidNotifier,
                builder: (context, nameIsValid, _) => AppButton(
                  isLoading: state is AccountInfoLoading,
                  text: Strings.confirmAndSubmitChanges,
                  onPressed:
                  nameIsValid ? () => context.read<AccountInfoCubit>().updateName(name: controller.text) : null,
                ),
              ),
              const SizedBox(height: Dimens.standard24),
            ],
          ),
        ),
      ),
    ),
  );
}