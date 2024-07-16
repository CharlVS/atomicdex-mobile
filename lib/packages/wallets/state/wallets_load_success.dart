import 'package:komodo_dex/packages/wallets/state/wallets_state.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

class WalletsLoadSuccess extends WalletsState {
  const WalletsLoadSuccess({required this.wallets});

  String get stateId => 'wallet_profiles_load_success';

  final List<KomodoWallet> wallets;

  @override
  List<Object> get props => [wallets.map((e) => e.props).toList()];

  @override
  Map<String, dynamic> toJson() => {
        'wallets': wallets.map((e) => e.toJson()).toList(),
      };

  static WalletsLoadSuccess fromJson(Map<String, dynamic> json) =>
      WalletsLoadSuccess(
        wallets: (json['wallets'] as List)
            .map((e) => KomodoWallet.fromJson(e))
            .toList(),
      );
}
