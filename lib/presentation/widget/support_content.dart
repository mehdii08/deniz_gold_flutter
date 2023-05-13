import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/data/dtos/app_config_dto.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        const SizedBox(height: Dimens.standard40),
      ],
    ),
  );
}