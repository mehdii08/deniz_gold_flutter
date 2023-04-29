bool isMobile(String value) {
  String pattern = '^0[0-9]{10}\$';
  RegExp regExp = RegExp(pattern);
  return value.isNotEmpty && regExp.hasMatch(value);
}
