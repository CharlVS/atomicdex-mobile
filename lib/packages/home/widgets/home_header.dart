import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/accounts/models/account.dart';
import 'package:komodo_dex/packages/home/widgets/home_actions_row.dart';
import 'package:komodo_dex/packages/home/widgets/portfolo_summary_container.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.activeAccount, super.key});

  final Account activeAccount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        PortfolioSummaryContainer(account: activeAccount),
        Positioned(
          bottom: 0, // half of button's height, adjust as needed
          left: 0,
          right: 0,
          child: HomeActionsRow(),
        ),
      ],
    );
  }
}
