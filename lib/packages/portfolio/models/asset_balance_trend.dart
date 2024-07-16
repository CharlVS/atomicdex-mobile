import 'dart:math';

import 'package:flutter/material.dart';
import 'package:komodo_dex/atomicdex_api/src/models/value/asset.dart';
import 'package:komodo_dex/atomicdex_api/src/models/value/symbol.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance.dart';
import 'package:komodo_dex/packages/portfolio/models/trend_summary.dart';

@immutable
class AssetBalanceTrend {
  AssetBalanceTrend({
    required this.balance,
    required this.priceHistory,
  })  : summary = TrendSummary.fromPriceHistoryOrNull(priceHistory),
        assert(
          priceHistory.isNotEmpty,
          'priceHistory must not be empty',
        );

  final AssetBalance balance;

  final List<AssetPriceDataPoint> priceHistory;

  final TrendSummary? summary;
}

@immutable
class AssetPriceDataPoint {
  const AssetPriceDataPoint({required this.date, required this.price});

  final DateTime date;
  final double price;
}

AssetBalanceTrend generateDummyAssetTrendSummaryData() {
  final random = Random();
  final priceHistoryCount = random.nextInt(10) + 5; // 5-15 data points

  final priceHistory = List<AssetPriceDataPoint>.generate(
    priceHistoryCount,
    (i) => AssetPriceDataPoint(
      date: DateTime.now().subtract(Duration(days: i)),
      price: 50 + random.nextDouble() * 100, // price between 50 and 150
    ),
  );

  final nativeAmount = random.nextDouble() * 1000;

  const conversionRate = 275000;

  final assetBalance = AssetBalance(
    converted: CryptoValue(
      amount: nativeAmount,
      symbol: CryptoCurrencySymbol('BTC'),
      blockchain: 'Bitcoin',
    ),
    primary: FiatValue(
      amount: nativeAmount * conversionRate,
      symbol: FiatCurrencySymbol('USD'),
    ),
  );

  return AssetBalanceTrend(
    balance: assetBalance,
    priceHistory: priceHistory,
  );
}
