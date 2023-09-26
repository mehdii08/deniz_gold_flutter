import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/blocs/app_config/app_config_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/title_app_bar.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  static final route = GoRoute(
    name: 'AccountInfoScreen',
    path: '/account_info',
    builder: (_, __) => const AccountInfoScreen(),
  );

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            context.goNamed(HomeScreen.route.name!);
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar:  TitleAppBar(title: Strings.accountInfo),
            body: BlocBuilder<AppConfigCubit, AppConfigState>(
                builder: (context, state) {
                  if (state is AppConfigLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.standard2X,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: Dimens.standard32),
                          AccountInfoItem(
                            title: Strings.fullName,
                            value: state.appConfig?.user.name ?? "",
                            onEditClicked: () => showNameEditBottomSheet(
                                context: context,
                                name: state.appConfig?.user.name ?? "",
                                onNameEdited: () {
                                  context.pop();
                                  context.read<AppConfigCubit>().getConfig();
                                }),
                          ),
                          AccountInfoItem(
                            title: Strings.nationalCode,
                            value: state.appConfig?.user.nationalCode ?? "",
                          ),
                          AccountInfoItem(
                            title: Strings.mobile,
                            value: state.appConfig?.user.mobile ?? "",
                          )
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
          ),
        ),
      );
}

class AccountInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onEditClicked;

  const AccountInfoItem({
    Key? key,
    required this.title,
    required this.value,
    this.onEditClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: Dimens.standard12),
          AppText(
            title,
            textStyle: AppTextStyle.body5,
            color: AppColors.nature.shade600,
          ),
          const SizedBox(height: Dimens.standard4),
          Row(
            children: [
              if (onEditClicked != null)
                GestureDetector(
                  onTap: onEditClicked,
                  child: AppText(
                    Strings.edit,
                    textStyle: AppTextStyle.button4,
                    color: AppColors.green.shade800,
                  ),
                ),
              const Spacer(),
              AppText(
                value,
                textStyle: AppTextStyle.button3,
              ),
            ],
          ),
          const SizedBox(height: Dimens.standard12),
          Divider(color: AppColors.nature.shade100)
        ],
      );
}
