import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AsyncDataTransformer extends DefaultTransformer {
  AsyncDataTransformer() : super(jsonDecodeCallback: _parseJson);
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(_parseAndDecode, text);
}