import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/coin_trades_tab.dart';
import 'package:deniz_gold/presentation/widget/title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/gold_trades_tab.dart';
import '../widget/select_left_or_right.dart';

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
  final isCoinSelectedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            context.goNamed(HomeScreen.route.name!);
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: const TitleAppBar(title: Strings.myTrades),
            body: ValueListenableBuilder<bool>(
                valueListenable: isCoinSelectedNotifier,
                builder: (context, isCoinSelected, _) {
                  return Column(
                    children: [
                      SelectLeftOrRight(
                        backgroundColor: AppColors.white,
                        isLeftSelected: isCoinSelected,
                        leftTitle: Strings.coinTrade,
                        rightTitle: Strings.goldTrade,
                        onLeftPressed: () => isCoinSelectedNotifier.value = true,
                        onRightPressed: () => isCoinSelectedNotifier.value = false,
                      ),
                      if (isCoinSelected) const CoinTradesTab() else const GoldTradesTab(),
                    ],
                  );
                }),
          ),
        ),
      );
}
