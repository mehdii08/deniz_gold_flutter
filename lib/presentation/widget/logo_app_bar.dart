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
  final Color backgroundColor;
  final bool showLogo;

  const LogoAppBar({
    Key? key,
    this.backgroundColor = AppColors.white,
    this.showLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<AppConfigCubit, AppConfigState>(
        builder: (context, state) {
          return Container(
          width: double.infinity,
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16, vertical: Dimens.standard6),
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    SupportIcon(),
                    Spacer(),
                    PersianDateWidget(),
                  ],
                ),
              ),
              if (showLogo)
                Align(
                    alignment: Alignment.center,
                    child: state.appConfig != null
                        ? Image.network(
                            "https://golddeniz.ir/uploads/logo/inactive-202306071686161200logo.png",
                            width: Dimens.standard80,
                            height: Dimens.standard53,
                            errorBuilder: (context, _, __) => AppText(
                              Strings.appName,
                              textStyle: AppTextStyle.title4,
                            ),
                          )
                        : const SizedBox()),
            ],
          ),
        );
        },
      );

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);
}
