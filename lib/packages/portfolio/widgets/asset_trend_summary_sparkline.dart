import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance_trend.dart';
import 'package:komodo_dex/packages/portfolio/models/trend_summary.dart';

class AssetTrendSummarySparkline extends StatelessWidget {
  AssetTrendSummarySparkline({
    required this.summary,
    required this.history,
  }) : _spots = List.generate(
          history.length,
          (index) => FlSpot(
            history[index].date.millisecondsSinceEpoch.toDouble(),
            history[index].price,
          ),
        );

  final List<AssetPriceDataPoint> history;

  final TrendSummary summary;

  final List<FlSpot> _spots;

  Color get lineColor {
    switch (summary.trend) {
      case AssetTrendEnum.up:
        return Colors.greenAccent.shade700;
      case AssetTrendEnum.down:
        return Colors.redAccent.shade700;
      case AssetTrendEnum.neutral:
        return Colors.grey.shade700;
    }
  }

  List<Color> get gradientColors {
    late final Color baseColor;
    switch (summary.trend) {
      case AssetTrendEnum.up:
        baseColor = Colors.greenAccent.shade700;
      case AssetTrendEnum.down:
        baseColor = Colors.redAccent.shade700;
      case AssetTrendEnum.neutral:
        baseColor = Colors.grey.shade700;
    }

    const opacitySteps = <double>[0.4, 0.1, 0.05, 0];

    return opacitySteps.map((e) => baseColor.withOpacity(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: false,
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: summary.mean,
              color: lineColor,
              strokeWidth: 0.75,
              dashArray: [5, 5],
            ),
          ],
        ),
        lineBarsData: [
          // Data line
          LineChartBarData(
            spots: _spots,
            isCurved: true,
            color: lineColor,
            barWidth: 1,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
          ),
        ],
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
