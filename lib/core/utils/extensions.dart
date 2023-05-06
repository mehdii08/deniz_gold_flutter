import 'package:dio/dio.dart';
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
    return formatter.format(int.parse(this!));
  }

  String clearCommas() => this != null ? this!.replaceAll(',', '') : "";
}

