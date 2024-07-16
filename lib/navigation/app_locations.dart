// lib/navigation/app_locations.dart
import 'package:beamer/beamer.dart';
import 'package:komodo_dex/packages/accounts/navigation/location.dart';
import 'package:komodo_dex/packages/home/navigation/home_location.dart';
import 'package:komodo_dex/packages/portfolio/navigation/portfolio_location.dart';
import 'package:komodo_dex/packages/wallets/navigation/locations.dart';

import 'legacy_locations.dart';

final List<BeamLocation> appLocations = [
  WalletsLocation(),
  // PortfolioLocation(),
  HomeLocation(),
  PortfolioLocation(),
  AccountsManagementLocation(),
  LegacyAppBarLocations(),
];
