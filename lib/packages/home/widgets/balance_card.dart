import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({required this.balance, super.key});

  final FiatValue balance;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimaryContainer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            balance.format(),
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: textColor),
          ),
        ],
      ),
    );

    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        'Estimated balance',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w300,
              color: textColor,
            ),
      ),
      subtitle: Text(
        balance.format(),
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: textColor),
      ),
    );
  }
}
