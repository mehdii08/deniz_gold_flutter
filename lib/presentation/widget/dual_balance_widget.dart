import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/presentation/blocs/balance/balance_cubit.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DualBalanceWidget extends StatefulWidget {
  const DualBalanceWidget({Key? key}) : super(key: key);

  @override
  State<DualBalanceWidget> createState() => _DualBalanceWidgetState();
}

class _DualBalanceWidgetState extends State<DualBalanceWidget> {
  @override
  Widget build(BuildContext context) => BlocProvider<BalanceCubit>(
        create: (_) => sl(),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
          padding: const EdgeInsets.all(8),
          child: BlocConsumer<BalanceCubit, BalanceState>(
            listener: (context, balanceState) {
              if (balanceState is BalanceFailed) {
                showToast(title: balanceState.message, context: context, toastType: ToastType.error);
              }
            },
            builder: (context, balanceState) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          Strings.remainingGold_,
                          textStyle: AppTextStyle.body5,
                          color: AppColors.nature.shade600,
                        ),
                        AppText(
                          balanceState is BalanceLoaded
                              ? balanceState.data.gold.balance.numberFormat()
                              : Strings.stars,
                          textDirection: TextDirection.ltr,
                          textStyle: AppTextStyle.body4,
                          color: balanceState is BalanceLoaded ? _getColor(balanceState, balanceState.data.gold.balance) :  AppColors.nature.shade800,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: balanceState is BalanceLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [SizedBox(width: 30, height: 30, child: CircularProgressIndicator())],
                          )
                        : GestureDetector(
                            onTap: () => balanceState is BalanceInitial
                                ? context.read<BalanceCubit>().getData()
                                : context.read<BalanceCubit>().reset(),
                            child: Image.asset(
                              balanceState is BalanceInitial ? "assets/images/eye.png" : "assets/images/eye_slash.png",
                              width: 20,
                              height: 20,
                              color: AppColors.nature.shade700,
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          Strings.remainingRials,
                          textStyle: AppTextStyle.body5,
                          color: AppColors.nature.shade600,
                        ),
                        AppText(
                          balanceState is BalanceLoaded
                              ? balanceState.data.rial.balance.numberFormat()
                              : Strings.stars,
                          textDirection: TextDirection.ltr,
                          textStyle: AppTextStyle.body4,
                          color: balanceState is BalanceLoaded ? _getColor(balanceState, balanceState.data.rial.balance) :  AppColors.nature.shade800,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  _getColor(BalanceLoaded balanceState, String balance) => !balanceState.data.balanceColorInfluens ?  AppColors.nature.shade800 : balance.contains("-") ? AppColors.red : AppColors.green;
}
