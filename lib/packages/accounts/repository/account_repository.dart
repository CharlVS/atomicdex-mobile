import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:komodo_dex/packages/authentication/repository/authentication_repository.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

class AccountRepository {
  KomodoWalletSdk get _sdk => KomodoWalletSdk.instance;
  final AuthenticationRepository _authenticationRepository;

  AccountRepository({
    // required AccountApi accountApi,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  /// Returns a stream of accounts for the currently authenticated user.
  Stream<List<KomodoAccount>> accountsStream() async* {
    final wallet = await _authenticationRepository.tryGetWallet();

    if (wallet != null) {
      final walletId = wallet.walletId;
      yield await _sdk.accounts.getAccountsByWalletId(walletId);
    }

    // Listen to changes in auth user to either close the stream or
    // update the walletId.
    await for (AuthenticationStatus status
        in _authenticationRepository.status) {
      if (status == AuthenticationStatus.authenticated) {
        final walletId = await _getAuthenticatedWalletId();
        yield* _sdk.accounts.accountsStream(walletId);
      } else {
        // // Close the stream when unauthenticated or status is unknown.
        // // You can modify this behavior as needed.
        // break;
        yield [];
        break;
      }
    }
  }

  Future<KomodoAccount> createAccount<T extends AccountId>({
    required String name,
    String? description,
    Color? themeColor,
    Uint8List? avatar,
  }) async {
    final walletId = await _getAuthenticatedWalletId();

    return _sdk.accounts.createAccount<HDAccountId>(
      walletId: walletId,
      name: name,
      description: description,
      themeColor: themeColor,
      avatar: avatar,
    );
  }

  Future<KomodoAccount> updateAccount({
    required AccountId accountId,
    required String name,
    String? description,
    Color? themeColor,
    Uint8List? avatar,
  }) async {
    final walletId = await _getAuthenticatedWalletId();

    return _sdk.accounts.updateAccount(
      currentWalletId: walletId,
      account: KomodoAccount(
        walletId: walletId,
        accountId: accountId,
        name: name,
        description: description,
        themeColor: themeColor,
        avatar: avatar,
      ),
    );
  }

  Future<KomodoAccount?> getAccount({required AccountId accountId}) async {
    final walletId = await _getAuthenticatedWalletId();

    return await _sdk.accounts
        .getAccount(walletId: walletId, accountId: accountId);
  }

  Future<List<KomodoAccount>> getAuthUserAccounts() async {
    final walletId = await _getAuthenticatedWalletId();

    return await _sdk.accounts.getAccountsByWalletId(walletId);
  }

  Future<void> deleteAccount(AccountId accountId) async {
    final walletId = await _getAuthenticatedWalletId();

    await _sdk.accounts.deleteAccount(walletId, accountId);
  }

  Future<void> dispose() async {
    await _sdk.accounts.dispose();
  }

  Future<String> _getAuthenticatedWalletId() async {
    final wallet = await _authenticationRepository.tryGetWallet();
    if (wallet == null) {
      throw Exception('Failed to get authenticated wallet.');
    }
    return wallet.walletId;
  }
}
