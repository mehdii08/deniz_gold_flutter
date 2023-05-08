import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/data/dtos/app_config_dto.dart';
import 'package:deniz_gold/presentation/blocs/auth/authentication_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportIcon extends StatelessWidget {
  const SupportIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSupportBottomSheet(context),
      child: Container(
        width: Dimens.standard40,
        height: Dimens.standard40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.standard100),
            border: Border.all(width: Dimens.standard1, color: AppColors.nature.shade100)),
        child: SvgPicture.asset(
          'assets/images/support.svg',
          fit: BoxFit.none,
        ),
      ),
    );
  }
}

showSupportBottomSheet(BuildContext context) {
  final appConfig = context.read<AuthenticationCubit>().getLocalAppConfig();
  if (appConfig != null) {
    showModalBottomSheet(
      context: context,
      // enableDrag: true,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.standard16))),
      builder: (context) => BottomSheetHeader(
        title: Strings.callToSupport,
        child: SupportContent(appConfig: appConfig),
      ),
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final Widget child;

  const BottomSheetHeader({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimens.standard20),
            Row(
              children: [
                const SizedBox(width: Dimens.standard16),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: SvgPicture.asset(
                    'assets/images/close.svg',
                    width: Dimens.standard32,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const Spacer(),
                AppText(
                  title,
                  textStyle: AppTextStyle.subTitle3,
                ),
                const SizedBox(width: Dimens.standard16),
              ],
            ),
            const SizedBox(height: Dimens.standard20),
            Divider(color: AppColors.nature.shade50),
            child
          ],
        ),
      );
}

class SupportContent extends StatefulWidget {
  final AppConfigDTO appConfig;

  const SupportContent({
    Key? key,
    required this.appConfig,
  }) : super(key: key);

  @override
  State<SupportContent> createState() => _SupportContentState();
}

class _SupportContentState extends State<SupportContent> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
        child: Column(
          children: [
            const SizedBox(height: Dimens.standard16),
            ...?widget.appConfig.phones
                ?.map((e) => Column(
                      children: [
                        AppButton(
                          color: AppColors.nature.shade50,
                          onPressed: () async {
                            final uri = Uri(scheme: 'tel', path: e.phone);
                            if (await canLaunchUrl(uri)) {
                              launchUrl(uri);
                            }
                          },
                          text: "${e.title} - ${e.phone}",
                        ),
                        const SizedBox(height: Dimens.standard12),
                      ],
                    ))
                .toList(),
            const SizedBox(height: Dimens.standard4),
          ],
        ),
      );
}
