import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/blocs/permission_checker/permission_checker_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_logo.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionChecker extends StatefulWidget {
  final Widget child;
  const PermissionChecker({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<PermissionChecker> createState() => _PermissionCheckerState();
}

class _PermissionCheckerState extends State<PermissionChecker> {
  PermissionStatus? permissionStatus;


  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return widget.child;
    }
    return BlocProvider<PermissionCheckerCubit>(
      create: (_)=>sl(),
      child: BlocBuilder<PermissionCheckerCubit,PermissionCheckerState>(
        builder: (context, state){
          if(state is PermissionCheckerLoading){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if ((state as PermissionCheckerLoaded).status == PermissionStatus.denied) {
            return PlaceHolderView(onRequest: () => context.read<PermissionCheckerCubit>().request());
          }
          return widget.child;
        },
      ),
    );
  }
}

class PlaceHolderView extends StatelessWidget {
  final VoidCallback onRequest;

  const PlaceHolderView({
    Key? key,
    required this.onRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      appBar: const LogoAppBar(showLogo: false, backgroundColor: AppColors.transparent),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/splash_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.standard32),
              decoration: BoxDecoration(
                  color: AppColors.transparentWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard160))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(showTitle: false),
                  const SizedBox(height: Dimens.standard12),
                  AppText(
                    Strings.welcomeToDeniz,
                    textStyle: AppTextStyle.subTitle3,
                  ),
                  const SizedBox(height: Dimens.standard8),
                  AppText(
                    Strings.permissionDescription,
                    textStyle: AppTextStyle.body4,
                    color: AppColors.nature.shade700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimens.standard24),
                  AppButton(
                    text: Strings.grantPermission,
                    onPressed: onRequest,
                  ),
                  const SizedBox(height: Dimens.standard160),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

