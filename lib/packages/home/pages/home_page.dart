import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/accounts/bloc/active_account_bloc.dart';
import 'package:komodo_dex/packages/home/widgets/home_assets_list.dart';
import 'package:komodo_dex/packages/home/widgets/home_header.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeAccount = context.select<ActiveAccountBloc, KomodoAccount?>(
      (bloc) => bloc.state.activeAccount,
    );

    if (activeAccount == null) {
      return CircularProgressIndicator.adaptive();
    }
    return Column(
      children: [
        HomeHeader(activeAccount: activeAccount),
        Expanded(child: HomeAssetsList()),
      ],
    );
  }
}
