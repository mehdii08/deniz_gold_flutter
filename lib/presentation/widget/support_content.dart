import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/blocs/support/support_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportSheetContent extends StatefulWidget {

  const SupportSheetContent({Key? key}) : super(key: key);

  @override
  State<SupportSheetContent> createState() => _SupportSheetContentState();
}

class _SupportSheetContentState extends State<SupportSheetContent> {

  @override
  void initState() {
    context.read<SupportCubit>().getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
          child: BlocBuilder<SupportCubit,SupportState>(
            builder: (context, state) {
              if(state is SupportLoaded){
                return Column(
                  children: [
                    const SizedBox(height: Dimens.standard16),
                    ...?state.phones
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
                    const SizedBox(height: Dimens.standard24),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimens.standard40),
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            }
          ),
        ),
  );
}
