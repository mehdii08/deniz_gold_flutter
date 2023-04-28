import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {

  static final route = GoRoute(
    name: 'SplashScreen',
    path: '/splash',
    builder: (_, __) => const SplashScreen(),
  );

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    print("----------> splash");
    return Scaffold(
      body: Container(),
    );
  }
}
