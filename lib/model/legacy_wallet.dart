import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

/// @deprecated LegacyWallet has been replaced by the Wallet class in the
/// [komodo_wallet_sdk] package. Existing code can use LegacyWallet as a drop-in
/// replacement for the old Wallet class, but new code should use the Wallet
/// class directly.
///
/// This class extends the new Wallet class and maintains the interface of the
/// old Wallet class for backwards compatibility.
@Deprecated('Use Wallet from the komodo_wallet_sdk package instead.')
class LegacyWallet extends KomodoWallet {
  @Deprecated(_deprecatedMessage)
  LegacyWallet({
    required super.name,
    required String id,
  }) : super(
          walletId: id,
          description: null,
          balance: null,
          color: null,
          profileImage: null,
        );

  String get id => walletId;

  static const String _deprecatedMessage =
      'LegacyWallet is deprecated. Use Wallet from the komodo_wallet_sdk '
      'package instead.';

  /// Creates a JSON map from a LegacyWallet instance.
  ///
  /// The map contains a 'name' key and an 'id' key, each associated with the
  /// corresponding property of the LegacyWallet instance.
  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': walletId,
      }..addAll(super.toJson());
}
