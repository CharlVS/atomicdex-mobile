import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/accounts/bloc/active_account_bloc.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance_trend.dart';
import 'package:komodo_dex/packages/portfolio/widgets/asset_balance_trend_list_item.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  Widget build(BuildContext context) {
    final activeAccount = context.select<ActiveAccountBloc, KomodoAccount?>(
      (bloc) => bloc.state.activeAccount,
    );

    final balanceTrends = [
      generateDummyAssetTrendSummaryData(),
      generateDummyAssetTrendSummaryData(),
      generateDummyAssetTrendSummaryData(),
    ];

    if (activeAccount == null) {
      return CircularProgressIndicator.adaptive();
    }
    return Column(
      children: [
        LimitedBox(
          maxHeight: kToolbarHeight + 36,
          child: AppBar(
            elevation: 1,
            actions: [
              IconButton.filled(
                icon: Icon(Icons.add),
                onPressed: () {
                  print('add');
                },
              ),
            ],
            title: Text('Portfolio'),
            bottom: PreferredSize(
              child: Container(
                width: double.infinity,
                child: Text(
                  "Title 2",
                  softWrap: false,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              preferredSize: Size.fromHeight(70),
            ),
          ),
        ),
        Flexible(
          child: ListView.separated(
            itemCount: balanceTrends.length,
            itemBuilder: (context, index) {
              final balanceTrend = balanceTrends[index];
              return AssetBalanceTrendListItem(
                key: ValueKey('portfolio-item-$index'),
                // key: ValueKey(balanceTrend.balance.primary.symbol),
                balanceTrend: balanceTrend,
                onTap: () {
                  print('ontap');
                },
              );
            },
            separatorBuilder: (context, index) => Divider(
              indent: 16,
              endIndent: 16,
              height: 4,
              thickness: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
