import 'package:flutter/material.dart';

class HomeScaffold extends StatefulWidget {
  final Widget child;

  const HomeScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
