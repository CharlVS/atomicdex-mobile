import 'package:komodo_dex/utils/utils.dart';

import '../model/balance.dart';
import '../model/coin.dart';

class CoinBalance {
  CoinBalance(this.coin, this.balance);

  CoinBalance.fromJson(Map<String, dynamic> json) {
    coin = Coin.fromJson(null, json['coin']);
    balance = Balance.fromJson(json['balance']);
    balanceUSD = json['balanceUSD'];
    priceForOne = json['priceForOne'];
  }

  Coin? coin;
  Balance? balance;
  double? balanceUSD;
  String? priceForOne;

  String? get iconAssetPath => getCoinIconPath(coin!.abbr);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'coin': coin!.toJson(),
      'balance': balance!.toJson(),
      'balanceUSD': balanceUSD,
      'priceForOne': priceForOne,
    };
  }

  String getBalanceUSD() {
    return balanceUSD!.toStringAsFixed(2);
  }
}
