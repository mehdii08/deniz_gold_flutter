import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

extension Responseee on Response<dynamic> {
  Map<String, dynamic> dataAsMap() => (data as Map<String, dynamic>)['data'];

  bool hasData() => data['data'] is Map<String, dynamic>;

  bool isSuccessFull() => (data as Map<String, dynamic>)['success'];
}

final formatter = intl.NumberFormat.decimalPattern();

extension NumberFormat on String? {
  String numberFormat() {
    if (this == null) {
      return "";
    }
    if (this!.isEmpty) {
      return "";
    }
    if (this!.contains(".")) {
      final integerPart = this!.substring(0, this!.indexOf(".")).numberFormat();
      final decimalPart = this!.substring(this!.indexOf("."), this!.length);
      return "$integerPart$decimalPart";
    }
    return formatter.format(double.parse(this!));
  }

  String clearCommas() => this != null ? this!.replaceAll(',', '') : "";
}

extension StringExtension on String{

  String removeExtraDecimals() {
    if (!contains('.')) return this;
    final sections = split('.');
    final intPart = sections[0];
    String decimalPart = sections[1];
    if (decimalPart.length > 3) {
      decimalPart = decimalPart.substring(0, 3);
    }
    return '$intPart.$decimalPart';
  }

  String removeDecimals() {
    if (contains('.')) return substring(0, indexOf('.'));
    return this;
  }

  String replacePersianNumbers() {
    String temp = this;
    if (temp.contains('۰')) temp = replaceAll('۰', '0');
    if (temp.contains('۱')) temp = temp.replaceAll('۱', '1');
    if (temp.contains('۲')) temp = temp.replaceAll('۲', '2');
    if (temp.contains('۳')) temp = temp.replaceAll('۳', '3');
    if (temp.contains('۴')) temp = temp.replaceAll('۴', '4');
    if (temp.contains('۵')) temp = temp.replaceAll('۵', '5');
    if (temp.contains('۶')) temp = temp.replaceAll('۶', '6');
    if (temp.contains('۷')) temp = temp.replaceAll('۷', '7');
    if (temp.contains('۸')) temp = temp.replaceAll('۸', '8');
    if (temp.contains('۹')) temp = temp.replaceAll('۹', '9');
    return temp;
  }

  int toInt(){
    try{
      return int.parse(clearCommas());
    }catch(e){
      return 0;
    }

  }

  double toDouble(){
    try{
      return double.parse(this);
    }catch(e){
      return 0;
    }

  }

}

extension ValueController on TextEditingController{
  increaseValue(){
    try {
      int intVal = int.parse(text);
      intVal++;
      text = intVal.toString();
    } catch (e) {
      text = "0";
    }
  }
  decreaseValue(){
    try {
      int intVal = int.parse(text);
      intVal--;
      text = intVal < 0 ? "0" : intVal.toString();
    } catch (e) {
      text = "0";
    }
  }
}

