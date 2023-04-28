enum TradeType {
  sell(0),
  buy(1);

  const TradeType(this.value);

  final int value;
}

enum CalculateType {
  weight(1),
  toman(2);

  const CalculateType(this.value);

  final int value;
}
