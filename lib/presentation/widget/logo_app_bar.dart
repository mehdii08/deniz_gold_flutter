import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/persian_date.dart';
import 'package:deniz_gold/presentation/widget/support_icon.dart';
import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const toolbarHeight = 74.0;

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LogoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<AppConfigCubit, AppConfigState>(
        builder: (context, state) => Container(
          width: double.infinity,
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16, vertical: Dimens.standard6),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  children: const [
                    SupportIcon(),
                    Spacer(),
                    PersianDateWidget(),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: state.appConfig != null
                      ? Image.network(
                          state.appConfig!.logo,
                          width: Dimens.standard80,
                          height: Dimens.standard53,
                          errorBuilder : (context, _, __) => AppText(Strings.appName, textStyle: AppTextStyle.title4,),
                        )
                      : const SizedBox()),
            ],
          ),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);
}
