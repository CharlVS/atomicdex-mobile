import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komodo_dex/packages/accounts/models/account.dart';
import 'package:komodo_dex/packages/accounts/repository/active_account_repository.dart';
import 'package:komodo_dex/packages/portfolio/events/portfolio_assets_list_event.dart';
import 'package:komodo_dex/packages/portfolio/models/asset_balance_trend.dart';
import 'package:komodo_dex/packages/portfolio/repository/legacy_coin_balances_repository.dart';
import 'package:komodo_dex/packages/portfolio/state/portfolio_assets_list_state.dart';

class PortfolioBalancesBloc
    extends Bloc<PortfolioBalancesEvent, PortfolioBalancesState> {
  PortfolioBalancesBloc({
    required PortfolioBalancesRepository repository,
    required ActiveAccountRepository activeAccountRepository,
  })  : _repository = repository,
        _activeAccountRepository = activeAccountRepository,
        super(PortfolioBalancesInitial()) {
    on<PortfolioBalancesFetchRequested>(_onPortfolioBalancesFetchRequested);
    on<PortfolioBalancesSubscriptionRequested>(
      _onPortfolioBalancesSubscriptionRequested,
    );
  }

  final PortfolioBalancesRepository _repository;
  final ActiveAccountRepository _activeAccountRepository;

  StreamSubscription<Account?>? _activeAccountSubscription;

  @override
  Future<void> close() {
    _activeAccountSubscription?.cancel();
    return super.close();
  }

  void _onPortfolioBalancesFetchRequested(
    PortfolioBalancesFetchRequested event,
    Emitter<PortfolioBalancesState> emit,
  ) async {
    final account = await _activeAccountRepository.tryGetActiveAccount();
    if (account == null) {
      emit(PortfolioBalancesLoadFailure());
      return;
    }

    try {
      final assets = await _repository.fetchBalances(account.accountId);
      emit(PortfolioBalancesLoadSuccess(assets: assets));
    } catch (e) {
      emit(PortfolioBalancesLoadFailure());
    }
  }

  void _onPortfolioBalancesSubscriptionRequested(
    PortfolioBalancesSubscriptionRequested event,
    Emitter<PortfolioBalancesState> emit,
  ) async {
    emit(PortfolioBalancesLoadInProgress());

    _activeAccountSubscription?.cancel();
    _activeAccountSubscription =
        _activeAccountRepository.activeAccountStream.listen(
      (account) async {
        if (account != null) {
          try {
            await emit.forEach<List<AssetBalanceTrend>>(
              _repository.balancesStream(account.accountId),
              onData: (assets) {
                return PortfolioBalancesLoadSuccess(assets: assets);
              },
              onError: (e, s) {
                return PortfolioBalancesLoadFailure();
              },
            );
            debugPrint('PortfolioBalancesBloc: Subscription closed.');
          } catch (e) {
            debugPrint('PortfolioBalancesBloc: Subscription error: $e');
            emit(PortfolioBalancesLoadFailure());
          }
        }
      },
    );
  }
}
