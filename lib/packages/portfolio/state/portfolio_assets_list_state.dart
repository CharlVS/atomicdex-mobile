import 'package:equatable/equatable.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance_trend.dart';

abstract class PortfolioBalancesState extends Equatable {
  const PortfolioBalancesState();

  @override
  List<Object> get props => [];
}

class PortfolioBalancesInitial extends PortfolioBalancesState {}

class PortfolioBalancesLoadInProgress extends PortfolioBalancesState {}

class PortfolioBalancesLoadSuccess extends PortfolioBalancesState {
  const PortfolioBalancesLoadSuccess({required this.assets});

  final List<AssetBalanceTrend> assets;

  @override
  List<Object> get props => [assets];
}

class PortfolioBalancesLoadFailure extends PortfolioBalancesState {}
