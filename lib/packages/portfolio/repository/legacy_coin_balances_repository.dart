import 'package:komodo_dex/packages/portfolio/api/portfolio_balances_api.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance_trend.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

class PortfolioBalancesRepository {
  PortfolioBalancesRepository({
    required PortfolioBalancesAPI api,
  }) : _api = api;

  final PortfolioBalancesAPI _api;

  Future<List<AssetBalanceTrend>> fetchBalances(AccountId accountId) =>
      _api.fetchBalances(accountId);

  Stream<List<AssetBalanceTrend>> balancesStream(AccountId accountId) async* {
    final assets = await fetchBalances(accountId);
    yield assets;

    yield* _api.balancesStream(accountId);
  }
}
