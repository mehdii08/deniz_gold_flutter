import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/data/enums.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/title_app_bar.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:deniz_gold/presentation/blocs/trades/trades_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';

class TradesScreen extends StatefulWidget {
  const TradesScreen({Key? key}) : super(key: key);

  static final route = GoRoute(
    name: 'TradesScreen',
    path: '/trades',
    builder: (_, __) => const TradesScreen(),
  );

  @override
  State<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen> {
  final scrollController = ScrollController();
  final cubit = sl<TradesCubit>();

  @override
  void initState() {
    super.initState();
    cubit.getData();
    scrollController.addListener(_onScrollControllerChanged);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollControllerChanged);
    scrollController.dispose();
    super.dispose();
  }

  _onScrollControllerChanged() {
    if (scrollController.position.maxScrollExtent - scrollController.position.pixels < 100) {
      if (cubit.state is TradesLoading) {
        return;
      }
      cubit.getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(HomeScreen.route.name!);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const TitleAppBar(title: Strings.myTrades),
        body: BlocProvider<TradesCubit>(
          create: (_) => cubit,
          child: BlocConsumer<TradesCubit, TradesState>(
            listener: (context, state) {
              if (state is TradesFailed) {
                showToast(title: state.message, context: context, toastType: ToastType.error);
              }
            },
            builder: (context, state) {
              if (state is TradesLoading && state.result.items.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.standard2X,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimens.standard2X),
                      if (state is TradesLoaded && state.result.items.isEmpty) ...[
                        const SizedBox(height: Dimens.standard8X),
                        const Text(Strings.listIsEmpty),
                      ] else ...[
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.standard16,
                                vertical: Dimens.standard6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard8)),
                                border: Border.all(color: AppColors.nature.shade50),
                              ),
                              child: AppText(
                                Strings.selectDate,
                                textStyle: AppTextStyle.button4,
                                color: AppColors.nature.shade600,
                              ),
                            ),
                            const SizedBox(width: Dimens.standard8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.standard16,
                                vertical: Dimens.standard6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard8)),
                                border: Border.all(color: AppColors.nature.shade50),
                              ),
                              child: AppText(
                                Strings.tradeType,
                                textStyle: AppTextStyle.button4,
                                color: AppColors.nature.shade600,
                              ),
                            )
                          ],
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.result.items.length + (state is TradesLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.result.items.length) {
                              return const SizedBox(height: 24, width: 24, child: CircularProgressIndicator());
                            }
                            return TradeItem(trade: state.result.items[index]);
                          },
                        )
                      ],
                      const SizedBox(height: 130),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TradeItem extends StatelessWidget {
  final TradeDTO trade;

  const TradeItem({
    Key? key,
    required this.trade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: Dimens.standard12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppText(
                          "۴۵,۵۰۰,۰۰۰",
                          textStyle: AppTextStyle.subTitle3,
                        ),
                        const Spacer(),
                        AppText(
                          trade.title.length > 10 ? trade.title.substring(0, 13) : trade.title,
                          textStyle: AppTextStyle.subTitle4,
                          color: trade.type == TradeType.sell.value ? AppColors.red : AppColors.green,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppText(
                          Strings.toman,
                          textStyle: AppTextStyle.body6,
                          color: AppColors.nature.shade600,
                        ),
                        const Spacer(),
                        AppText(
                          '${trade.faDate} - ${trade.faTime}',
                          textStyle: AppTextStyle.body5,
                          color: AppColors.nature.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimens.standard16),
              Container(
                width: Dimens.standard4,
                height: Dimens.standard56,
                color: trade.type == TradeType.sell.value ? AppColors.red : AppColors.green,
              )
            ],
          ),
          const SizedBox(height: Dimens.standard12),
          Row(
            children: [
              AppText(
                Strings.eachGeramPrice,
                textStyle: AppTextStyle.body6,
                color: AppColors.nature.shade600,
              ),
              const Spacer(),
              AppText(
                Strings.weight,
                textStyle: AppTextStyle.body6,
                color: AppColors.nature.shade600,
              ),
              const SizedBox(width: Dimens.standard20),
            ],
          ),
          Row(
            children: [
              AppText(
                '۲,۶۷۵,۰۰۰',
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
              ),
              const Spacer(),
              AppText(
                '۲۰ گرم',
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
              ),
              const SizedBox(width: Dimens.standard20),
            ],
          ),
          const SizedBox(height: Dimens.standard12),
          Divider(
            color: AppColors.nature.shade50,
          )
        ],
      );
}
