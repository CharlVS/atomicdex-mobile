import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/accounts/models/account.dart';
import 'package:komodo_dex/packages/home/widgets/balance_card.dart';
import 'package:komodo_dex/packages/home/widgets/home_account_row.dart';

class PortfolioSummaryContainer extends StatelessWidget {
  const PortfolioSummaryContainer({required this.account, super.key});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      clipBehavior: Clip.none,
      margin: EdgeInsets.only(bottom: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: HomeAccountRow(account: account),
          ),
          BalanceCard(balance: account.balance),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
