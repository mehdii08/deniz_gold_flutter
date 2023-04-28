import 'package:deniz_gold/presentation/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class DenizApp extends StatelessWidget {
  const DenizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        //todo fix me
        providers: [
          ChangeNotifierProvider<GoRouter>(create: buildRouter),
        ],
        child: Builder(
          builder:(context) =>  MaterialApp.router(
            key: appKey,
            routerConfig: context.read<GoRouter>(),
            theme: appTheme,
          ),
        ),
      );
}

final appTheme = ThemeData(
  // textTheme: _textTheme,//todo fix me
  fontFamily: 'AppFont',
);
