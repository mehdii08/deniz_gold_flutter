import 'dart:async';

import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/data/dtos/coin_trade_submit_response_dto.dart';
import 'package:deniz_gold/data/dtos/trade_dto.dart';
import 'package:deniz_gold/data/dtos/trade_submit_response_dto.dart';
import 'package:deniz_gold/presentation/blocs/checkTradeStatus/check_trade_status_cubit.dart';
import 'package:deniz_gold/presentation/blocs/trade/trade_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


class TradeAnswerWaitingDialog extends StatefulWidget {
  final TradeSubmitResponseDTO data;
  final bool isSell;
  final TradeCubit tradeCubit;
  final Function(TradeDTO) onResultReached;

  const TradeAnswerWaitingDialog({
    Key? key,
    required this.data,
    required this.isSell,
    required this.tradeCubit,
    required this.onResultReached,
  }) : super(key: key);

  @override
  State<TradeAnswerWaitingDialog> createState() => _TradeAnswerWaitingDialogState();
}

class _TradeAnswerWaitingDialogState extends State<TradeAnswerWaitingDialog> with TickerProviderStateMixin {
  Timer? _timer;
  int _progress = 0;
  late CheckTradeStatusCubit checkTradeStatusCubit;

  @override
  void initState() {
    super.initState();
    checkTradeStatusCubit = sl();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (kIsWeb && _progress != 0 && _progress % 5 == 0) {
          checkTradeStatusCubit.check(tradeId: widget.data.requestId, silent: true);
        }
        if (_progress == widget.data.timeForCancel) {
          checkTradeStatusCubit.check(tradeId: widget.data.requestId);
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _progress++;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async => _progress >= widget.data.timeForCancel,
    child: BlocProvider<CheckTradeStatusCubit>.value(
      value: checkTradeStatusCubit,
      child: BlocConsumer<CheckTradeStatusCubit, CheckTradeStatusState>(
        listener: (context, state) {
          if (state is CheckTradeStatusLoaded) {
            _timer?.cancel();
            widget.onResultReached(state.trade);
          }
        },
        builder: (context, checkTradeStatusState) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Dimens.standard53,
                height: Dimens.standard53,
                padding: const EdgeInsets.all(Dimens.standard16),
                decoration: BoxDecoration(color: AppColors.nature, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  'assets/images/time.svg',
                  width: Dimens.standard20,
                  fit: BoxFit.fitWidth,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: Dimens.standard16),
              AppText(
                Strings.validatingOrder,
                textStyle: AppTextStyle.subTitle3,
              ),
              AppText(
                widget.isSell ? Strings.sellDescription : Strings.buyDescription,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimens.standard40),
              if (checkTradeStatusState is CheckTradeStatusLoading)
                const CircularProgressIndicator()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.standard53),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.nature.shade50,
                      color: AppColors.yellow,
                      value: _progress.toDouble() / widget.data.timeForCancel,
                      minHeight: 12,
                    ),
                  ),
                ),
              const SizedBox(height: Dimens.standard40),
            ],
          ),
        ),
      ),
    ),
  );
}

class CoinTradeAnswerWaitingDialog extends StatefulWidget {
  final CoinTradeSubmitResponseDTO data;
  final Function(TradeDTO) onResultReached;

  const CoinTradeAnswerWaitingDialog({
    Key? key,
    required this.data,
    required this.onResultReached,
  }) : super(key: key);

  @override
  State<CoinTradeAnswerWaitingDialog> createState() => _CoinTradeAnswerWaitingDialog();
}

class _CoinTradeAnswerWaitingDialog extends State<CoinTradeAnswerWaitingDialog> with TickerProviderStateMixin {
  late Timer? _timer;
  int _progress = 0;
  late CheckTradeStatusCubit checkTradeStatusCubit;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (kIsWeb && _progress != 0 && _progress % 5 == 0) {
        checkTradeStatusCubit.check(tradeId: widget.data.requestId, silent: true);
      }
      if (_progress == widget.data.timeForCancel) {
        checkTradeStatusCubit.check(tradeId: widget.data.requestId);
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _progress++;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkTradeStatusCubit = sl();
    startTimer();
  }

  @override
  void dispose() {
    if (kIsWeb) _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async => _progress >= widget.data.timeForCancel,
    child: BlocProvider<CheckTradeStatusCubit>.value(
      value: checkTradeStatusCubit,
      child: BlocConsumer<CheckTradeStatusCubit, CheckTradeStatusState>(
        listener: (context, state) {
          if (state is CheckTradeStatusLoaded) {
            if (kIsWeb) _timer?.cancel();
            widget.onResultReached(state.trade);
          }
        },
        builder: (context, checkTradeStatusState) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Dimens.standard53,
                height: Dimens.standard53,
                padding: const EdgeInsets.all(Dimens.standard16),
                decoration: BoxDecoration(color: AppColors.nature, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  'assets/images/time.svg',
                  width: Dimens.standard20,
                  fit: BoxFit.fitWidth,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: Dimens.standard16),
              AppText(
                Strings.validatingOrder,
                textStyle: AppTextStyle.subTitle3,
              ),
              AppText(
                Strings.orderDescription,
                textStyle: AppTextStyle.body4,
                color: AppColors.nature.shade700,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimens.standard40),
              if (checkTradeStatusState is CheckTradeStatusLoading)
                const CircularProgressIndicator()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.standard53),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.nature.shade50,
                      color: AppColors.yellow,
                      value: _progress.toDouble() / widget.data.timeForCancel,
                      minHeight: 12,
                    ),
                  ),
                ),
              const SizedBox(height: Dimens.standard40),
            ],
          ),
        ),
      ),
    ),
  );
}