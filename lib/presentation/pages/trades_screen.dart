import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/widget/empty_view.dart';
import 'package:deniz_gold/presentation/widget/filter_item.dart';
import 'package:deniz_gold/presentation/widget/title_app_bar.dart';
import 'package:deniz_gold/presentation/widget/trade_item.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    final dateFilterItems = <String,int>{
      '۶ ماه پیش' : 6,
      '۳ ماه پیش' : 3,
      '۲ ماه پیش' : 3,
      '۱ ماه پیش' : 1,
    };

    final tradeTypeFilterItems = <String,int>{
      'خرید' : 1,
      'فروش' : 0,
    };
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
                        EmptyView(
                          text: Strings.tradesListIsEmpty,
                          buttonText: Strings.tradeGold,
                          // onTap: ()=> context.goNamed(TradeScreen.route.name!),//todo
                          onTap: () {},
                        ),
                      ] else ...[
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            FilterItem(
                              title: Strings.selectDate,
                              svgIcon: 'assets/images/calendar.svg',
                              selectableItems: dateFilterItems,
                              onChange: (selectedKey){},
                            ),
                            const SizedBox(width: Dimens.standard8),
                            FilterItem(
                              title: Strings.tradeType,
                              selectableItems: tradeTypeFilterItems,
                              onChange: (selectedKey){},
                            ),
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
