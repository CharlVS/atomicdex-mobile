import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:komodo_dex/localizations.dart';
import 'package:komodo_dex/login/exceptions/auth_exceptions.dart';
import 'package:komodo_dex/packages/accounts/repository/active_account_repository.dart';
import 'package:komodo_dex/services/mm_service.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

// TODO: Migrate parts of the application referencing the legacy coins/auth
// blocs for authentication to a new AuthenticationBloc which listens to
// the stream of authentication events from this repository.

/// Repository for handling authentication logic. This repository is
/// responsible for handling all authentication logic and should be used
/// instead of the legacy authentication blocs. NB that this repository is
/// not a singleton and should be instantiated and passed to blocs.
class AuthenticationRepository {
  AuthenticationRepository._({
    required this.prefs,
    required Database sqlDB,
    required MMService marketMakerService,
  })  : _sqlDB = sqlDB,
        // _biometricStorageApi = biometricStorageApi,
        // _walletStorageApi = walletStorageApi,
        _apiService = marketMakerService;

  // final BiometricStorageApi _biometricStorageApi;
  final SharedPreferences prefs;
  final Database _sqlDB;
  final MMService _apiService;

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  KomodoWalletSdk get _sdk => KomodoWalletSdk.instance;

  AuthenticationStatus? _lastAuthState;
  KomodoWallet? _lastWallet;

  late final StreamSubscription<AuthenticationStatus> _subscription;
  final _controller = StreamController<AuthenticationStatus>.broadcast();

  Stream<AuthenticationStatus> get status async* {
    if (_lastAuthState == null) {
      yield AuthenticationStatus.unknown;
    } else {
      yield _lastAuthState!;
    }

    await for (final status in _controller.stream) {
      // Using stream to keep track of last auth state seems like a good idea,
      // but this fails if there are no listeners to the stream.
      _setInternalState(status: status, wallet: _lastWallet);
      yield status;
    }
  }

  Future<void> _setInternalState({
    required AuthenticationStatus? status,
    KomodoWallet? wallet,
  }) async {
    final bool isAuthenticated = status == AuthenticationStatus.authenticated;

    if (isAuthenticated && wallet == null) {
      throw Exception('Wallet cannot be null when status is authenticated.');
    }

    _lastAuthState = status;

    _lastWallet = isAuthenticated ? wallet : null;

    if (isAuthenticated) {
      // TODO! Integrate with legacy code relying on the old auth blocs.
      // await Db.saveCurrentWallet(wallet!.toLegacy());
      await _secureStorage.write(key: 'lastWalletId', value: wallet!.walletId);
    } else {
      await _secureStorage.delete(key: 'lastWalletId');
    }
  }

  Future<String?> _getStoredWalletId() =>
      _secureStorage.read(key: 'lastWalletId');

  AppLocalizations loc = AppLocalizations();

  /// Creates an instance of [AuthenticationRepository] and initializes
  /// the [BiometricStorageApi] and [WalletStorageApi] instances.
  ///
  /// Tries to restore the last authenticated wallet.
  // TODO: consider how/if passphrase-based login should be handled.
  static Future<AuthenticationRepository> instantiate({
    required Database sqlDB,
    required MMService marketMakerService,
    // WalletStorageApi? walletStorageApi,
    // required AtomicDexApi atomicDexApi,
    bool shouldTryRestore = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final instance = AuthenticationRepository._(
      prefs: prefs,
      sqlDB: sqlDB,
      marketMakerService: marketMakerService,
      // biometricStorageApi: biometricStorageApi,
    );

    if (!shouldTryRestore) {
      return instance;
    }

    await instance._tryRestoreSession();

    return instance;
  }

  bool get _isAuthenticated =>
      _lastAuthState == AuthenticationStatus.authenticated;

  Future<void> logInWithBiometrics({
    required String walletId,
  }) async {
    // TODO:
    // 1. Check if the wallet exists
    final walletProfile = await _sdk.wallets.getWallet(walletId);
    if (walletProfile == null) {
      throw WalletNotFoundException('Wallet not found.');
    }

    // TODO: Consider moving this to the SDK package. It would be ideal if we
    // didn't need to fetch the passphrase value.
    // 2. Check if the passphrase is correct
    final storedPassphrase = await _sdk.wallets.getPassphrase(
      walletId,
      method: AuthenticationMethods.biometrics,
    );

    if (storedPassphrase == null) {
      throw WalletNotFoundException('Passphrase not found for wallet');
    }

    // Start the API service with the default account.
    // TODO: Implement in ActiveAccount Bloc/Repository the functionality to
    // resume the session with the last used account. After that is implemented,
    // the code below should be removed.
    await legacyStartSession(
      passphrase: storedPassphrase,
      hdAccountId: null,
    );

    await _setInternalState(
      status: AuthenticationStatus.authenticated,
      wallet: walletProfile,
    );
    _controller.add(AuthenticationStatus.authenticated);
  }

  // TODO? Create Session class?
  Future<void> _tryRestoreSession() async {
    final storedWalletId = await _getStoredWalletId();

    if (storedWalletId == null) {
      debugPrint('No stored session found.');
      return;
    }

    await _secureStorage.delete(key: 'lastWalletId');

    return logInWithBiometrics(walletId: storedWalletId);
  }

  Future<bool> canBiometricsAuthenticate() async {
    final result = await _sdk.biometrics.canAuthenticate();

    debugPrint('biometricsAvailable: $result');

    return result;
  }

  void _ensureSignedIn() {
    if (!_isAuthenticated) {
      throw NotAuthenticatedException('User is not signed in.');
    }
  }

  Future<String?> getWalletPassphrase(String walletId) {
    return _sdk.wallets.getPassphrase(
      walletId,
      method: AuthenticationMethods.biometrics,
    );
  }

  /// Tried to get the wallet profile of the currently authenticated wallet.
  /// Returns null if the wallet profile could not be retrieved or if the
  /// wallet is not authenticated.
  ///
  /// Wallet can be seen as the equivalent to the `User` class often
  /// used in authentication examples.
  Future<KomodoWallet?> tryGetWallet() async {
    if (!_isAuthenticated) {
      return null;
    }
    final wallet = await _sdk.wallets.getWallet(_lastWallet!.walletId);

    await _setInternalState(
      status: AuthenticationStatus.authenticated,
      wallet: wallet,
    );

    return wallet;
  }

  //TODO.C: Auth bloc->repo try restore auth state on startup

  Future<void> logOut() async {
    await legacyEndSession();
    _controller.add(AuthenticationStatus.unauthenticated);
    _setInternalState(status: AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
