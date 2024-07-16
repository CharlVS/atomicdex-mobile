import 'dart:async';

import 'package:komodo_dex/packages/accounts/repository/account_repository.dart';
import 'package:komodo_dex/packages/authentication/repository/authentication_repository.dart';
import 'package:komodo_dex/services/mm_service.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

class ActiveAccountRepository {
  ActiveAccountRepository({
    required AccountRepository accountRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _accountRepository = accountRepository,
        // _walletStorageApi = walletStorageApi,
        _authenticationRepository = authenticationRepository;

  final AccountRepository _accountRepository;
  final AuthenticationRepository _authenticationRepository;
  // final WalletStorageApi _walletStorageApi;

  AccountId? _activeAccountId;

  Stream<KomodoAccount?> get activeAccountStream async* {
    await for (final status in _authenticationRepository.status) {
      if (status == AuthenticationStatus.authenticated) {
        yield await tryGetActiveAccount();
      } else {
        yield null;
      }
    }
  }

  Future<void> setActiveAccount(AccountId accountId) async {
    final wallet = await _authenticationRepository.tryGetWallet();
    if (wallet == null) {
      throw Exception('Failed to get authenticated wallet.');
    }

    // Clear the passphrase from memory as soon as possible.
    String? passphrase;

    try {
      passphrase =
          await _authenticationRepository.getWalletPassphrase(wallet.walletId);

      if (passphrase == null) {
        throw Exception('Failed to get wallet passphrase.');
      }

      // TODO: Implement below in new ADex server package
      // await _atomicDexApi.startSession(
      //     passphrase: passphrase, accountId: accountId);

      final hdAccountId =
          accountId is HDAccountId ? accountId.hdId.toString() : null;

      await legacyStartSession(
        passphrase: passphrase,
        hdAccountId: hdAccountId,
      );

      // TODO! Figure out which part of the pre-refactored code need to be
      // called to initialise them.

      _activeAccountId = accountId;
    } catch (e) {
      rethrow;
    } finally {
      // Clear the passphrase from memory as soon as possible.
      passphrase = null;
    }
  }

  Future<KomodoAccount?> tryGetActiveAccount() async {
    final wallet = await _authenticationRepository.tryGetWallet();
    if (wallet != null && _activeAccountId != null) {
      return await _accountRepository.getAccount(accountId: _activeAccountId!);
    }
    return null;
  }

  Future<void> clearActiveAccount() async {
    _activeAccountId = null;

    // await _atomicDexApi.endSession();

    // TODO: Handle any other cleanup that needs to happen for legacy code.
  }

  Future<bool> canChangeActiveAccount() async {
    // Placeholder logic, will be updated later
    return true;
  }

  Future<AccountId> _getActiveAccountId() async {
    if (_activeAccountId == null) {
      throw Exception('No active account set.');
    }
    return _activeAccountId!;
  }
}

/// Start up and log in to the AtomicDex API.
///
/// Must be called before using the API.
@Deprecated('Move to new ADex server package. This is a temporary solution.')
Future<void> legacyStartSession({
  required String passphrase,
  required String? hdAccountId,
}) async {
  //TODO: Move this fun
  final serverInstance = MarketMakerService.instance;
  final _rpcPassword = serverInstance.generateRpcPassword();

  if (serverInstance.running) {
    await serverInstance.stopmm2();
  }

  await MarketMakerService.instance.init(
    passphrase: passphrase,
    rpcPassword: _rpcPassword,
    hdAccountId: hdAccountId == null ? null : int.tryParse(hdAccountId),
  );
}

@Deprecated('Move to new ADex server package. This is a temporary solution.')
Future<void> legacyEndSession() async {
  // TODO! Protection against logging out while sensitive operations are
  // running.

  final serverInstance = MarketMakerService.instance;

  if (serverInstance.running) {
    await serverInstance.stopmm2();
  }
}
