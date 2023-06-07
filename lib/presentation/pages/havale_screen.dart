import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/data/dtos/havale_dto.dart';
import 'package:deniz_gold/data/dtos/havaleh_owner_dto.dart';
import 'package:deniz_gold/presentation/blocs/havale/havale_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/UserStatusChecker.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/empty_view.dart';
import 'package:deniz_gold/presentation/widget/title_app_bar.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/presentation/widget/utils.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HavaleScreen extends StatefulWidget {
  const HavaleScreen({Key? key}) : super(key: key);

  static final route = GoRoute(
    name: 'HavaleScreen',
    path: '/havaleh',
    builder: (_, __) => const HavaleScreen(),
  );

  @override
  State<HavaleScreen> createState() => _HavaleScreenState();
}

class _HavaleScreenState extends State<HavaleScreen> {
  final scrollController = ScrollController();
  final valueController = TextEditingController(text: "0");
  final nameController = TextEditingController();
  final cubit = sl<HavaleCubit>()..getData();
  final canSubmitNotifier = ValueNotifier<bool>(false);
  final havalehOwnerNotifier = ValueNotifier<HavalehOwnerDTO?>(null);

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
      if (cubit.state is HavaleLoading) {
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
            appBar: const TitleAppBar(title: Strings.storeGoldenHavale),
            body: UserStatusChecker(
              updateUser: true,
              child: BlocProvider<HavaleCubit>(
                create: (_) => cubit,
                child: BlocConsumer<HavaleCubit, HavaleState>(
                  listener: (context, state) {
                    if (state is HavaleFailed) {
                      showToast(title: state.message, context: context, toastType: ToastType.error);
                    } else if (state is HavaleLoaded && state.message != null) {
                      valueController.text = "0";
                      nameController.clear();
                      havalehOwnerNotifier.value = null;
                      canSubmitNotifier.value = false;
                      showToast(title: state.message!, context: context);
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          const SizedBox(height: Dimens.standard20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppTextField(
                                  title: Strings.enterWeightByGheram,
                                  controller: valueController,
                                  keyboardType: TextInputType.number,
                                  onChange: (value) => checkSubmitAvailableity(),
                                  prefixIcon: GestureDetector(
                                    onTap: () {
                                      valueController.increaseValue();
                                      checkSubmitAvailableity();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/plus.svg',
                                      height: Dimens.standard6,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      valueController.decreaseValue();
                                      checkSubmitAvailableity();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/negativ.svg',
                                      height: Dimens.standard6,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimens.standard20),
                                AppTextField(
                                  controller: nameController,
                                  title: Strings.havaleOwnerName,
                                  textAlign: TextAlign.right,
                                  onChange: (value) => checkSubmitAvailableity(),
                                ),
                                const SizedBox(height: Dimens.standard20),
                                ValueListenableBuilder(
                                  valueListenable: havalehOwnerNotifier,
                                  builder: (context, havalehOwner, _) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        Strings.havaleNazde,
                                        textStyle: AppTextStyle.body5,
                                        color: AppColors.nature.shade600,
                                      ),
                                      const SizedBox(height: Dimens.standard8),
                                      GestureDetector(
                                        onTap: () {
                                          showHavalehSelectorSelectorBottomSheet(
                                              context: context,
                                              selectedKey: havalehOwner?.title,
                                              onChange: (key, value) {
                                                havalehOwnerNotifier.value = (key == null && value == null)
                                                    ? null
                                                    : HavalehOwnerDTO(title: key!, id: value!);
                                              });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimens.standard10, horizontal: Dimens.standard12),
                                          decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard8)),
                                              border:
                                                  Border.all(color: AppColors.nature.shade200, width: Dimens.standard1)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/down.svg',
                                                width: Dimens.standard24,
                                                fit: BoxFit.fitWidth,
                                              ),
                                              AppText(
                                                havalehOwner?.title ?? Strings.yourself,
                                                textStyle: AppTextStyle.body4,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: Dimens.standard32),
                                ValueListenableBuilder<bool>(
                                  valueListenable: canSubmitNotifier,
                                  builder: (context, value, _) => AppButton(
                                    isLoading: state is HavaleLoading && !state.isList,
                                    text: Strings.storeHavaleRequest,
                                    onPressed: value
                                        ? () {
                                            context.read<HavaleCubit>().storeHavale(
                                                value: valueController.text,
                                                name: nameController.text,
                                                destination: havalehOwnerNotifier.value?.id);
                                          }
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: Dimens.standard30),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: Dimens.standard8),
                                        child: AppText(
                                          Strings.havalehDescription,
                                          textStyle: AppTextStyle.body5,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset('assets/images/warning_fill.svg',
                                        width: Dimens.standard24, height: Dimens.standard24, fit: BoxFit.fitHeight)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimens.standard20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: Dimens.standard16),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(Dimens.standard16)),
                                color: AppColors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: Dimens.standard16),
                                AppText(
                                  Strings.latestHavales,
                                  textStyle: AppTextStyle.subTitle4,
                                  color: AppColors.nature.shade600,
                                ),
                                const SizedBox(height: Dimens.standard16),
                                if (state is HavaleLoading && state.isList && state.result.items.isEmpty) ...[
                                  const SizedBox(height: Dimens.standard4X),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Center(child: CircularProgressIndicator()),
                                  ),
                                  const SizedBox(height: Dimens.standard6X),
                                ] else ...[
                                  if (state is HavaleLoaded && state.result.items.isEmpty) ...[
                                    const SizedBox(height: Dimens.standard28),
                                    const EmptyView(text: Strings.noAnyHavale),
                                  ] else
                                    ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: state.result.items.length + (state is HavaleLoading ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (index == state.result.items.length) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator()
                                            ],
                                          );
                                        }
                                        return HavalehItem(havaleh: state.result.items[index]);
                                      },
                                    ),
                                  const SizedBox(height: 130),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

  checkSubmitAvailableity() {
    canSubmitNotifier.value =
        valueController.text.isNotEmpty && valueController.text != "0" && nameController.text.isNotEmpty;
  }
}

class HavalehItem extends StatelessWidget {
  final HavaleDTO havaleh;

  const HavalehItem({
    Key? key,
    required this.havaleh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.standard16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        HavaleStatusBadge(
                          status: havaleh.status,
                          statusText: havaleh.statusText,
                        ),
                        const Spacer(),
                        AppText(
                          havaleh.title,
                          textStyle: AppTextStyle.subTitle4,
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimens.standard4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(
                          "${havaleh.date} - ${havaleh.time}",
                          textStyle: AppTextStyle.body6,
                        ),
                        const Spacer(),
                        AppText(
                          '${Strings.toName} ${havaleh.name}',
                          textStyle: AppTextStyle.body5,
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimens.standard4),
                    if (havaleh.destination != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          AppText(
                            "${Strings.nazde} ${havaleh.destination?.title ?? ""}",
                            textStyle: AppTextStyle.body5,
                            color: AppColors.nature.shade400,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: Dimens.standard16),
              Container(
                width: Dimens.standard4,
                height: Dimens.standard84,
                color: AppColors.nature.shade100,
              )
            ],
          ),
        ),
        Divider(color: AppColors.nature.shade50),
      ],
    );
}

class HavaleStatusBadge extends StatelessWidget {
  final int status;
  final String statusText;

  const HavaleStatusBadge({
    Key? key,
    required this.status,
    required this.statusText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(Dimens.standard6),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(Dimens.standard16)),
            color: status == 1
                ? AppColors.nature.shade50
                : status == 2
                    ? AppColors.green.shade50
                    : AppColors.red.shade50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              statusText,
              textStyle: AppTextStyle.body6,
            ),
            const SizedBox(width: Dimens.standard6),
            SvgPicture.asset(
              status == 1
                  ? 'assets/images/time_clock.svg'
                  : status == 2
                      ? 'assets/images/checkmark_circle.svg'
                      : 'assets/images/fill_close.svg',
              width: Dimens.standard16,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      );
}
