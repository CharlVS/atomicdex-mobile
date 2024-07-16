import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance_trend.dart';
import 'package:komodo_dex/packages/portfolio/widgets/asset_trend_summary_sparkline.dart';
import 'package:komodo_dex/packages/portfolio/widgets/stock_price_box.dart';

class AssetBalanceTrendListItem extends StatelessWidget {
  const AssetBalanceTrendListItem({
    required this.balanceTrend,
    this.onTap,
    super.key,
  });

  final AssetBalanceTrend balanceTrend;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final nativeBalance = balanceTrend.balance.converted;

    final convertedBalance = balanceTrend.balance.primary;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        constraints: BoxConstraints(
          maxHeight: 64,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
              backgroundColor: nativeBalance.symbol.hasIcon
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.secondaryContainer,
              foregroundImage: nativeBalance.symbol.icon!.getImageProvider(),
            ),
            SizedBox(width: 8),
            //

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nativeBalance.symbol.longFormat,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    nativeBalance.amount.toStringAsPrecision(8),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ],
              ),
            ),
            //

            Expanded(
              child: Row(
                children: [
                  if (balanceTrend.summary == null)
                    Spacer()
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: AssetTrendSummarySparkline(
                          summary: balanceTrend.summary!,
                          history: balanceTrend.priceHistory,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 4),
            //

            StockPriceBox(
              symbolText: convertedBalance.symbol.shortFormat,
              price: convertedBalance.amount,
              change: balanceTrend.summary?.change ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}
