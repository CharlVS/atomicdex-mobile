import 'package:flutter/foundation.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance_trend.dart';

enum AssetTrendEnum { up, down, neutral }

@immutable
class TrendSummary {
  const TrendSummary({
    required this.open,
    required this.change,
    required this.mean,
    required this.max,
    required this.min,
    required this.trend,
  });

  final AssetPriceDataPoint min;
  final AssetPriceDataPoint max;
  final AssetPriceDataPoint open;

  final double mean;
  final double change;

  final AssetTrendEnum trend;

  static TrendSummary? fromPriceHistoryOrNull(
    List<AssetPriceDataPoint> priceHistory,
  ) {
    if (!canCompute(priceHistory)) return null;
    return TrendSummary._summaryToPriceHistory(priceHistory);
  }

  static TrendSummary fromPriceHistory(
    List<AssetPriceDataPoint> priceHistory,
  ) =>
      TrendSummary._summaryToPriceHistory(priceHistory);

  // ignore: prefer_constructors_over_static_methods
  static TrendSummary _summaryToPriceHistory(
    List<AssetPriceDataPoint> priceHistory,
  ) {
    if (!canCompute(priceHistory))
      throw Exception('Cannot compute trend summary with no data');

    final count = priceHistory.length;

    final sum = priceHistory.fold<double>(
      0,
      (previousValue, element) => previousValue + element.price,
    );
    final mean = (count == 0 ? 0 : sum / count).toDouble();

    final open = priceHistory.first;
    final close = priceHistory.last;
    final change = close.price - open.price;

    final max = priceHistory.reduce(
      (value, element) => value.price > element.price ? value : element,
    );

    final min = priceHistory.reduce(
      (value, element) => value.price < element.price ? value : element,
    );

    final trendType = change > 0
        ? AssetTrendEnum.up
        : change < 0
            ? AssetTrendEnum.down
            : AssetTrendEnum.neutral;

    return TrendSummary(
      open: open,
      change: change,
      mean: mean,
      max: max,
      min: min,
      trend: trendType,
    );
  }

  static bool canCompute(List<AssetPriceDataPoint> priceHistory) {
    return priceHistory.isNotEmpty;
  }
}
