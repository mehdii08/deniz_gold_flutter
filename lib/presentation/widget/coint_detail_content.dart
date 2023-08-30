import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/presentation/blocs/coin_trades_detail/coint_trades_detail_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/key_value.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinDetailContent extends StatefulWidget {
  final int id;

  const CoinDetailContent({Key? key, required this.id}) : super(key: key);

  @override
  State<CoinDetailContent> createState() => _CoinDetailContentState();
}

class _CoinDetailContentState extends State<CoinDetailContent> {
  CoinTradesDetailCubit cubit = sl<CoinTradesDetailCubit>();

  @override
  void initState() {
    super.initState();
    cubit.getData(id: widget.id);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                child: BlocProvider<CoinTradesDetailCubit>.value(
                  value: cubit,
                  child: BlocConsumer<CoinTradesDetailCubit, CoinTradesDetailState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is CoinTradesDetailLoaded) {
                          return Column(
                            children: [
                              const SizedBox(height: Dimens.standard20),
                              KeyValue(title: Strings.tradeType, value: state.result.type),
                              const SizedBox(height: Dimens.standard12),
                              ...?state.result.coins
                                  ?.map((e) => Padding(
                                        padding: const EdgeInsets.only(bottom: Dimens.standard8),
                                        child: KeyValue(title: e.title, value: '${e.count} عدد'),
                                      ))
                                  .toList(),
                              const SizedBox(
                                height: Dimens.standard4,
                              ),
                              Divider(
                                color: AppColors.nature.shade100,
                              ),
                              const SizedBox(
                                height: Dimens.standard12,
                              ),
                              KeyValue(
                                  title: Strings.priceTotalRialCoin,
                                  value: '${state.result.total_price.numberFormat()} ${Strings.toman}'),
                              const SizedBox(
                                height: Dimens.standard20,
                              )
                            ],
                          );
                        } else {
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
                      }),
                ))
          ],
        ),
      );
}
