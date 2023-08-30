import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAccountingChecker extends StatefulWidget {
  final Widget child;
  final bool updateUser;
  final Widget? placeHolder;
  final String message;

  const UserAccountingChecker({
    Key? key,
    required this.child,
    this.updateUser = false,
    this.placeHolder,
    this.message = Strings.actionDeactivatedWarning,
  }) : super(key: key);

  @override
  State<UserAccountingChecker> createState() => _UserAccountingCheckerState();
}

class _UserAccountingCheckerState extends State<UserAccountingChecker> {
  @override
  void initState() {
    if (widget.updateUser) {
      context.read<AppConfigCubit>().getConfig();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppConfigCubit, AppConfigState>(
      listener: (context, state) {
        if (state.appConfig == null && context.read<AuthenticationCubit>().isAuthenticated) {
          context.read<AppConfigCubit>().getConfig();
        }
      },
      builder: (context, state) {
        if (state.appConfig == null) {
          return const SizedBox();
        } else if (!state.appConfig!.user.accountingStatus) {
          return widget.placeHolder ??
              Center(
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.nature),
                ),
              );
        }
        return widget.child;
      },
    );
  }
}
