import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

/// A class responsible for managing wallet-related data.
///
/// The WalletRepository class uses BiometricStorageApi and WalletProfileHiveApi
/// to interact with biometric storage and Hive storage, respectively.
///
/// Example:
///
/// ```dart
/// final biometricStorage = BiometricStorage();
/// final biometricStorageApi = BiometricStorageApi(biometricStorage: biometricStorage);
/// final walletProfileHiveApi = WalletProfileHiveApi();
/// final walletRepository = WalletRepository(biometricStorageApi: biometricStorageApi, walletProfileHiveApi: walletProfileHiveApi);
/// ```
class WalletsRepository {
  WalletsRepository();

  KomodoWalletSdk get _sdk => KomodoWalletSdk.instance;

  // /// Creates a WalletRepository instance.
  // ///
  // /// Convenience method for default WalletRepository constructor.
  // /// handling all the necessary initialization of dependencies.
  // ///
  // /// Initialize using the default constructor if you want to inject your own
  // /// instances of the dependencies.
  // static Future<WalletsRepository> create({
  //   WalletStorageApi? walletStorageApi,
  // }) async {
  //   // Initialize BiometricStorageApi
  //   final biometricStorage = BiometricStorageApi(
  //     baseStorageKey: 'wallet_data',
  //   );

  //   // Initialize WalletProfileHiveApi
  //   walletStorageApi ??= await WalletStorageApi.create();

  //   // Initialize WalletRepository
  //   return WalletsRepository(
  //     walletStorageApi: walletStorageApi,
  //     biometricWalletPassphraseApi: biometricStorage,
  //   );
  // }

  Future<String?> getWalletPassphrase(String walletId) async {
    try {
      return await _sdk.wallets.getPassphrase(
        walletId,
        method: AuthenticationMethods.biometrics,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> createWallet({
    required KomodoWallet wallet,
    required String passphrase,
  }) async {
    // TODO? Move ID generation to SDK?
    return _sdk.wallets.createWallet(wallet: wallet, passphrase: passphrase);
  }

  /// Used when creating a new wallet for which the biometrics passphrase
  /// storage is not known or set at the time of creation.
  ///
  /// E.g. When migrating a wallet from legacy storage to the new storage
  /// we don't know the passphrase at the time of creation. The user will
  /// be prompted to enter the passphrase or legacy password when they first try
  /// to access the wallet.
  ///
  /// NB: This method does not store the passphrase in biometric storage.
  Future<void> createWalletWithoutPassphrase({
    required KomodoWallet wallet,
  }) async {
    try {
      await _sdk.wallets.createWalletWithoutPassphrase(wallet: wallet);
    } catch (e) {
      //Delete the profile if creation fails. Await future but ignore result
      _sdk.wallets.removeWallet(wallet.walletId).ignore();

      return Future.error(e);
    }
  }

  Future<KomodoWallet?> getWallet(String walletId) async {
    return await _sdk.wallets.getWallet(walletId);
  }

  Future<List<KomodoWallet>> listWallets() async {
    return await _sdk.wallets.listWallets();
  }

  /// Removes a WalletProfile instance from the list of wallet profiles.
  ///
  /// NB: This method does not remove the wallet passphrase from biometric
  /// storage or delete the wallet from the blockchain.
  Future<void> removeWallet(String walletId) async {
    throw UnimplementedError();
    // TODO: Add on calls to remove passphrase from biometric storage
    await _sdk.wallets.removeWallet(walletId);
  }
}
