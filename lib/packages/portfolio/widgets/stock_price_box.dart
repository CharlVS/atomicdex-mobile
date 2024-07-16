import 'package:flutter/material.dart';

class StockPriceBox extends StatelessWidget {
  const StockPriceBox({
    required this.price,
    required this.change,
    required this.symbolText,
  });

  final double price;
  final double change;
  final String symbolText;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (change > 0) {
      backgroundColor = Colors.green;
    } else if (change < 0) {
      backgroundColor = Colors.red.shade700;
    } else {
      backgroundColor = Colors.grey;
    }

    // TODO: Change input types for this widget to make use of [NumberFromat]
    // to determine the correct prefix character.
    final prefixChar = change > 0
        ? '+'
        : change < 0
            ? '-'
            : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          '\$${price.toInt()}',
          style: Theme.of(context).textTheme.bodyLarge,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 70,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: backgroundColor,
          ),
          child: Text(
            '$prefixChar$symbolText${change.abs().toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}
