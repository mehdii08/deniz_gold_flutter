import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/presentation/blocs/transactions/transactions_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/empty_view.dart';
import 'package:deniz_gold/presentation/widget/title_app_bar.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/presentation/widget/transaction_item.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  static final route = GoRoute(
    name: 'TransactionsScreen',
    path: '/transactions',
    builder: (_, __) => const TransactionsScreen(),
  );

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final scrollController = ScrollController();
  final cubit = sl<TransactionsCubit>();

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
    if (scrollController.position.maxScrollExtent -
            scrollController.position.pixels <
        100) {
      if (cubit.state is TransactionsLoading) {
        return;
      }
      cubit.getData();
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            context.goNamed(HomeScreen.route.name!);
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: TitleAppBar(
              title: Strings.transactions,
              onClick: () {
                cubit.getPdf();
              },
            ),
            body: BlocProvider<TransactionsCubit>(
              create: (_) => cubit,
              child: BlocConsumer<TransactionsCubit, TransactionsState>(
                listener: (context, state) {
                  if (state is TransactionsFailed) {
                    showToast(
                        title: state.message,
                        context: context,
                        toastType: ToastType.error);
                  }
                },
                builder: (context, state) {
                  if (state is TransactionsLoading &&
                      state.transactions.isEmpty) {
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
                          if (state is TransactionsLoaded &&
                              state.transactions.isEmpty) ...[
                            const SizedBox(height: Dimens.standard8X),
                            const EmptyView(
                                text: Strings.transactionsListIsEmpty),
                          ] else ...[
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.transactions.length +
                                  (state is TransactionsLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.transactions.length) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                          width: Dimens.standard24,
                                          height: Dimens.standard24,
                                          child: CircularProgressIndicator())
                                    ],
                                  );
                                }
                                return TransactionItem(
                                    transaction: state.transactions[index]);
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
        ),
      );
}
