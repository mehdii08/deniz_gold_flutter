import 'package:deniz_gold/presentation/deniz_app.dart';
import 'package:deniz_gold/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSL();
  runApp(const DenizApp());
}
