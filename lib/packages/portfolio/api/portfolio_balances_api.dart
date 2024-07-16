import 'package:komodo_dex/atomicdex_api/atomicdex_api.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance_trend.dart';

abstract interface class PortfolioBalancesAPI {
  Future<List<AssetBalanceTrend>> fetchBalances(AccountId accountId);
  Stream<List<AssetBalanceTrend>> balancesStream(AccountId accountId);
}
