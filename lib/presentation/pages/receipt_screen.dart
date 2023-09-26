import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/core/utils/extensions.dart';
import 'package:deniz_gold/presentation/blocs/receipt/receipt_screen_cubit.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/pages/home_screen.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_button.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:deniz_gold/presentation/widget/app_text_field.dart';
import 'package:deniz_gold/presentation/widget/empty_view.dart';
import 'package:deniz_gold/presentation/widget/logo_app_bar.dart';
import 'package:deniz_gold/presentation/widget/recpeit_item.dart';
import 'package:deniz_gold/presentation/widget/toast.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:cross_file_image/cross_file_image.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({Key? key}) : super(key: key);

  static final route = GoRoute(
    name: 'ReceiptScreen',
    path: '/receipt',
    builder: (_, __) => const ReceiptScreen(),
  );

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenScreenState();
}

class _ReceiptScreenScreenState extends State<ReceiptScreen> {
  final cubit = sl<ReceiptScreenCubit>();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final trackingCodeController = TextEditingController();
  final errors = ValueNotifier<ReceiptNumberError>(ReceiptNumberError());
  final selectedFileNotifier = ValueNotifier<XFile?>(null);
  final imagePicker = ImagePicker();

  _validateThenSubmit(VoidCallback onSubmit) {
    String? name;
    String? price;
    String? file;

    if (nameController.text.length < 3) name = Strings.nameError;
    if (priceController.text.isEmpty) price = Strings.priceError;
    if (selectedFileNotifier.value == null) file = Strings.fileCodeError;

    errors.value = ReceiptNumberError(nameError: name, trackingCode: null, priceError: price, fileError: file);

    if (name == null && price == null && file == null) {
      onSubmit();
    }
  }

  @override
  void initState() {
    cubit.eventListener.stream.listen((event) {
      showToast(title: event.message, context: context, toastType: event.type);
      priceController.clear();
      nameController.clear();
      trackingCodeController.clear();
    });
    cubit.getData();
    super.initState();
  }

  @override
  void dispose() {
    cubit.eventListener.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            context.goNamed(HomeScreen.route.name!);
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.nature.shade50,
            appBar: LogoAppBar(
              backgroundColor: AppColors.nature.shade900,
              // title: Strings.receipt,
            ),
            body: BlocProvider<ReceiptScreenCubit>(
              create: (_) => cubit,
              child: BlocConsumer<ReceiptScreenCubit, ReceiptScreenState>(
                listener: (context, state) {
                  // if (state is ReceiptScreenFailed) {
                  //   showToast(title: state.message, context: context, toastType: ToastType.error);
                  // }
                },
                builder: (context, state) {
                  return SafeArea(
                    child:
                        Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          decoration: const BoxDecoration(color: AppColors.white),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimens.standard2X),
                              child: ValueListenableBuilder<ReceiptNumberError>(
                                valueListenable: errors,
                                builder: (context, inputErrors, _) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(height: Dimens.standard24),
                                    AppText(
                                      Strings.confirmReceipt,
                                      textStyle: AppTextStyle.subTitle4,
                                      textAlign: TextAlign.right,
                                      color: AppColors.nature.shade900,
                                    ),
                                    AppText(
                                      Strings.confirmReceiptDiscreption,
                                      textStyle: AppTextStyle.body5,
                                      color: AppColors.nature.shade900,
                                    ),
                                    const SizedBox(
                                      height: Dimens.standard24,
                                    ),
                                    AppTextField(
                                        textAlign: TextAlign.right,
                                        controller: priceController,
                                        onChange: (value) {
                                          value = value
                                              .replacePersianNumbers()
                                              .removeDecimals()
                                              .clearCommas()
                                              .numberFormat();
                                          priceController.value = TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(offset: value.length),
                                          );
                                        },
                                        keyboardType: TextInputType.number,
                                        title: Strings.receiptPrice,
                                        error: inputErrors.priceError),
                                    const SizedBox(
                                      height: Dimens.standard16,
                                    ),
                                    AppTextField(
                                        textAlign: TextAlign.right,
                                        controller: nameController,
                                        keyboardType: TextInputType.name,
                                        title: Strings.receiptName,
                                        error: inputErrors.nameError),
                                    const SizedBox(
                                      height: Dimens.standard16,
                                    ),
                                    AppTextField(
                                        textAlign: TextAlign.right,
                                        controller: trackingCodeController,
                                        keyboardType: TextInputType.number,
                                        title: Strings.receiptTrackingCode,
                                        error: inputErrors.trackingCode),
                                    const SizedBox(
                                      height: Dimens.standard16,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: selectedFileNotifier,
                                      builder: (context, selectedFile, _) {
                                        if (selectedFile != null) {
                                          return Row(
                                            children: [
                                              const SizedBox(
                                                width: Dimens.standard8,
                                              ),
                                              GestureDetector(
                                                onTap: () => selectedFileNotifier.value = null,
                                                child: Image.asset(
                                                  'assets/images/close.png',
                                                  color: AppColors.nature.shade900,
                                                  fit: BoxFit.fitWidth,
                                                  width: Dimens.standard32,
                                                ),
                                              ),
                                              const Spacer(),
                                              AppText(
                                                selectedFile.name,
                                                textStyle: AppTextStyle.button4,
                                                color: AppColors.nature.shade900,
                                              ),
                                              const SizedBox(width: Dimens.standard8),
                                              SizedBox(
                                                width: Dimens.standard32,
                                                height: Dimens.standard32,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(Dimens.standard8),
                                                  child: Image(image: XFileImage(selectedFileNotifier.value!)),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        return GestureDetector(
                                          onTap: () async {
                                            selectedFileNotifier.value =
                                                await imagePicker.pickImage(source: ImageSource.gallery);
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  AppText(
                                                    Strings.pictureFish,
                                                    textStyle: AppTextStyle.button4,
                                                    color: AppColors.nature.shade900,
                                                  ),
                                                  const SizedBox(
                                                    width: Dimens.standard8,
                                                  ),
                                                  Image.asset(
                                                    'assets/images/upload.png',
                                                    fit: BoxFit.fitWidth,
                                                    width: Dimens.standard32,
                                                  ),
                                                ],
                                              ),
                                              if (inputErrors.fileError != null) ...[
                                                const SizedBox(height: Dimens.standard8),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      AppText(
                                                        inputErrors.fileError ?? "",
                                                        textStyle: AppTextStyle.body5,
                                                        color: AppColors.red,
                                                      ),
                                                      const SizedBox(width: Dimens.standard8),
                                                      Image.asset(
                                                        'assets/images/info_fill.png',
                                                        fit: BoxFit.fitWidth,
                                                        width: Dimens.standard20,
                                                        height: Dimens.standard20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: Dimens.standard11,
                                    ),
                                    Container(
                                      height: Dimens.standard1,
                                      color: AppColors.nature.shade100,
                                      width: double.maxFinite,
                                    ),
                                    const SizedBox(
                                      height: Dimens.standard24,
                                    ),
                                    AppButton(
                                      onPressed: () {
                                        _validateThenSubmit(() {
                                          context.read<ReceiptScreenCubit>().sendFish(
                                                name: nameController.text,
                                                trackingCode: trackingCodeController.text,
                                                price: priceController.text.clearCommas(),
                                                file: selectedFileNotifier.value!,
                                                deviceType: kIsWeb ? "2" : "1",
                                              );
                                        });
                                      },
                                      text: Strings.sendFish,
                                      textStyle: AppTextStyle.button4,
                                      borderRadius: Dimens.standard8,
                                      isLoading: state.buttonIsLoading,
                                    ),
                                    const SizedBox(
                                      height: Dimens.standard40,
                                    ),
                                    Container(
                                      height: Dimens.standard2,
                                      color: AppColors.nature.shade100,
                                      width: double.maxFinite,
                                    ),
                                    const SizedBox(
                                      height: Dimens.standard32,
                                    ),
                                    AppText(
                                      Strings.receiptResendly,
                                      textStyle: AppTextStyle.subTitle4,
                                      color: AppColors.nature.shade900,
                                    ),
                                    if (state.listIsLoading) ...[
                                      const SizedBox(height: Dimens.standard48),
                                      const Align(
                                        alignment: Alignment.topCenter,
                                        child: CircularProgressIndicator(),
                                      ),
                                      const SizedBox(height: Dimens.standard48),
                                    ] else if (state.receipts.isEmpty) ...[
                                      const SizedBox(
                                        height: Dimens.standard48,
                                      ),
                                      const EmptyView(
                                        text: Strings.emptyList,
                                        buttonText: Strings.tradeGold,
                                      ),
                                    ] else ...[
                                      const SizedBox(
                                        height: Dimens.standard12,
                                      ),
                                      Divider(
                                        color: AppColors.nature.shade100,
                                      ),
                                      ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: state.receipts.length,
                                        itemBuilder: (context, index) {
                                          return ReceiptItem(receiptDTO: state.receipts[index]);
                                        },
                                      ),
                                      const SizedBox(height: Dimens.standard130),
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
          ),
        ),
      );
}

class ReceiptNumberError {
  final String? trackingCode;
  final String? nameError;
  final String? priceError;
  final String? fileError;

  ReceiptNumberError({this.trackingCode, this.nameError, this.priceError, this.fileError});
}
