enum TradeType {
  sell(0),
  buy(1);

  const TradeType(this.value);

  final int value;

  static TradeType fromCode(int code) => code == 0 ? TradeType.sell : TradeType.buy;
}

enum CalculateType {
  weight(1),
  toman(2);

  const CalculateType(this.value);

  final int value;

  CalculateType fromCode(int code) => code == 1 ? CalculateType.weight : CalculateType.toman;
}

enum ChangeType { increased, decreased, unchanged }

enum IconAlign { right, left }
