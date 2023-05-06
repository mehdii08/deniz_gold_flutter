import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/widget/persian_date.dart';
import 'package:deniz_gold/presentation/widget/support_icon.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const toolbarHeight = 74.0;

class FlatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FlatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<AppConfigCubit, AppConfigState>(
        builder: (context, state) => Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16, vertical: Dimens.standard6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SupportIcon(),
              Expanded(child: state.appConfig != null ? Image.network(state.appConfig!.logo, width: Dimens.standard80, height: Dimens.standard53,) : const SizedBox()),
              const SizedBox(width: Dimens.standard20),
              const PersianDateWidget(),
            ],
          ),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);
}
