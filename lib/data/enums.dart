enum BuyAndSellType {
  sell(0),
  buy(1);

  const BuyAndSellType(this.value);

  final int value;

  static BuyAndSellType fromCode(int code) => code == 0 ? BuyAndSellType.sell : BuyAndSellType.buy;
}

enum CoinAndGoldType {
  gold(1),
  coin(2);

  const CoinAndGoldType(this.value);

  final int value;

  static CoinAndGoldType fromCode(int code) => code == 1 ? CoinAndGoldType.gold : CoinAndGoldType.coin;
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
