import 'package:flutter/material.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

enum ToastType { success, error }

showToast(
    {required String title,
    required BuildContext context,
    ToastType toastType = ToastType.success,
    VoidCallback? onClose}) {
  if (toastType == ToastType.success) {
    MotionToast.success(
      borderRadius: Dimens.standard2X,
      animationType: AnimationType.fromLeft,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      padding: const EdgeInsets.all(Dimens.standard4X),
      displaySideBar: false,
      layoutOrientation: ToastOrientation.rtl,
      position: MotionToastPosition.top,
      description: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(title),
      ),
      onClose: onClose,
    ).show(context);
  } else if (toastType == ToastType.error) {
    MotionToast.error(
      borderRadius: Dimens.standard2X,
      animationType: AnimationType.fromLeft,
      animationCurve: Curves.fastLinearToSlowEaseIn,
      padding: const EdgeInsets.all(Dimens.standard4X),
      displaySideBar: false,
      layoutOrientation: ToastOrientation.rtl,
      position: MotionToastPosition.top,
      description: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(title),
      ),
      onClose: onClose,
    ).show(context);
  }
}
