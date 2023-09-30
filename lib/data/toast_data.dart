import 'package:deniz_gold/presentation/widget/toast.dart';

class ToastData {
  final String message;
  final ToastType type;

  const ToastData({
    required this.message,
    this.type = ToastType.success,
  });
}


