import 'package:komodo_dex/navigation/legacy_locations.dart';
import 'package:komodo_dex/packages/accounts/navigation/account_routes.dart';
import 'package:komodo_dex/packages/home/navigation/home_location.dart';
import 'package:komodo_dex/packages/portfolio/navigation/portfolio_location.dart';
import 'package:komodo_dex/packages/wallets/navigation/routes.dart';

/// An index of all routes in the app. When adding a new route file to the app,
/// add it to this file.
class AppRoutes {
  AppRoutes._();

  static WalletRoutes get wallet => WalletRoutes();

  static PortfolioLocation get portfolio => PortfolioLocation();

  static HomeLocation get home => HomeLocation();

  static AccountRoutes get accounts => AccountRoutes();

  static final LegacyAppBarLocations legacy = LegacyAppBarLocations();
}
