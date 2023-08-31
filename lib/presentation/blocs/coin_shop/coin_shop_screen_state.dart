part of 'coin_shop_screen_cubit.dart';

class CoinTabState extends Equatable {
  final List<CoinDTO> coins;
  final List<CartCoin> selectedCoins;
  final bool isLoading;
  final bool buttonIsLoading;
  final CoinTradeCalculateResponseDTO? coinTradeCalculateResponseDTO;
  final CoinTradeSubmitResponseDTO? coinTradeSubmitResponseDTO;

  const CoinTabState({
    this.coins = const [],
    this.selectedCoins = const [],
    this.isLoading = false,
    this.buttonIsLoading = false,
    this.coinTradeCalculateResponseDTO,
    this.coinTradeSubmitResponseDTO,
  });

  CoinTabState copyWith({
    List<CoinDTO>? coins,
    List<CartCoin>? selectedCoins,
    bool? isLoading,
    bool? buttonIsLoading,
    CoinTradeCalculateResponseDTO? coinTradeCalculateResponseDTO,
    CoinTradeSubmitResponseDTO? coinTradeSubmitResponseDTO,
  }) =>
      CoinTabState(
        coins: coins ?? this.coins,
        selectedCoins: selectedCoins ?? this.selectedCoins,
        isLoading: isLoading ?? this.isLoading,
        buttonIsLoading: buttonIsLoading ?? this.buttonIsLoading,
        coinTradeCalculateResponseDTO: coinTradeCalculateResponseDTO ?? this.coinTradeCalculateResponseDTO,
        coinTradeSubmitResponseDTO: coinTradeSubmitResponseDTO ?? this.coinTradeSubmitResponseDTO,
      );

  CoinTabState increase({required int id}) {
    List<CartCoin> tempList = [...selectedCoins];
    final coin = tempList.firstWhereOrNull((element) => element.id == id);
    if (coin != null) {
      final index = tempList.indexOf(coin);
      if (index != -1) {
        tempList.removeAt(index);
        tempList.insert(index, coin.increase());
      }
    } else {
      tempList.add(CartCoin(id: id, count: 1));
    }
    return copyWith(selectedCoins: tempList);
  }

  CoinTabState decrease({required int id}) {
    List<CartCoin> tempList = [...selectedCoins];
    final coin = tempList.firstWhereOrNull((element) => element.id == id);
    if (coin != null) {
      final index = tempList.indexOf(coin);
      if (index != -1) {
        tempList.removeAt(index);
        if (coin.count > 1) {
          tempList.insert(index, coin.decrease());
        }
      }
    }
    return copyWith(selectedCoins: tempList);
  }

  @override
  List<Object?> get props => [coins, selectedCoins, isLoading, buttonIsLoading, coinTradeCalculateResponseDTO,coinTradeSubmitResponseDTO,];
}

class CartCoin extends Equatable {
  final int id;
  final int count;

  const CartCoin({
    required this.id,
    required this.count,
  });

  Map<String, dynamic> toJson() => {'id': id, 'count': count};

  CartCoin increase() => CartCoin(
        id: id,
        count: count + 1,
      );

  CartCoin decrease() => CartCoin(
        id: id,
        count: count - 1,
      );

  @override
  List<Object?> get props => [id, count];
}
