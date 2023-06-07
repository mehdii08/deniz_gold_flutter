import 'package:deniz_gold/presentation/blocs/notification_listener/notification_listener_cubit.dart';
import 'package:deniz_gold/presentation/widget/havaleh_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseView extends StatefulWidget {
  final Widget child;

  const BaseView({required this.child, Key? key}) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  bool _isShowingDialog = false;

  @override
  Widget build(BuildContext context) => BlocConsumer<NotificationListenerCubit, NotificationListenerState>(
        listener: (context, state) {
          print("---------> staterr ");
          if (state is NotificationListenerLoaded && !_isShowingDialog) {
            _isShowingDialog = true;
            showDialog(context: context, builder: (context) => HavalehStatusDialog(havaleh: state.havaleh))
                .then((value) => _isShowingDialog = false);
          }
        },
        builder: (context, state) {
          return widget.child;
        },
      );
}
