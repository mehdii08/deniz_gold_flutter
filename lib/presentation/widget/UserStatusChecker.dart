import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/strings.dart';

class UserStatusChecker extends StatefulWidget {
  final Widget child;
  final bool updateUser;
  final bool checkTrade;
  final Widget? placeHolder;

  const UserStatusChecker({
    Key? key,
    required this.child,
    this.updateUser = false,
    this.checkTrade = false,
    this.placeHolder,
  }) : super(key: key);

  @override
  State<UserStatusChecker> createState() => _UserStatusCheckerState();
}

class _UserStatusCheckerState extends State<UserStatusChecker> {
  @override
  Widget build(BuildContext context) {
    if(widget.updateUser){
      context.read<AppConfigCubit>().getConfig();
    }
    return BlocConsumer<AppConfigCubit, AppConfigState>(
      listener: (context, state){
        if(state.appConfig == null && context.read<AuthenticationCubit>().isAuthenticated){
          context.read<AppConfigCubit>().getConfig();
        }
      },
      builder: (context, state){
        if(state.appConfig == null){
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if(state.appConfig?.user.statusCode == 0){
          return widget.placeHolder ?? Center(
            child: Text(Strings.activationWarning,textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge,),
          );
        }else if(widget.checkTrade && state.appConfig?.botStatus == "0"){
          return widget.placeHolder ?? Center(
            child: Text(Strings.tradeDisabledWarning,textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge,),
          );
        }
        return widget.child;
      },
    );
  }
}