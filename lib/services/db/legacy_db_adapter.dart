// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:komodo_dex/model/legacy_wallet.dart';
import 'package:komodo_dex/packages/accounts/repository/account_repository.dart';
import 'package:komodo_dex/packages/accounts/repository/active_account_repository.dart';
import 'package:komodo_dex/packages/authentication/repository/authentication_repository.dart';
import 'package:komodo_dex/packages/wallets/repository/wallets_repository.dart';
import 'package:komodo_dex/services/db/database.dart';
import 'package:komodo_dex/utils/log.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';
import 'package:sqflite/sqflite.dart';

class LegacyDatabaseAdapter {
  static LegacyDatabaseAdapter? _instance;

  static LegacyDatabaseAdapter? get maybeInstance => _instance;

  final AuthenticationRepository _authenticationRepository;

  final ActiveAccountRepository _activeAccountRepository;
  final AccountRepository _accountRepository;
  final WalletsRepository _walletsRepository;
  LegacyDatabaseAdapter._({
    required WalletsRepository walletsRepository,
    required AuthenticationRepository authenticationRepository,
    required ActiveAccountRepository activeAccountRepository,
    required AccountRepository accountRepository,
  })  : _walletsRepository = walletsRepository,
        _accountRepository = accountRepository,
        _activeAccountRepository = activeAccountRepository,
        _authenticationRepository = authenticationRepository;

  KomodoWalletSdk get _sdk => KomodoWalletSdk.instance;

  Future<void> createNewWallet(KomodoWallet wallet) async {
    await _walletsRepository.createWalletWithoutPassphrase(wallet: wallet);

    final walletAccounts =
        await _sdk.accounts.getAccountsByWalletId(wallet.walletId);

    if (walletAccounts.isEmpty) {
      await _sdk.accounts.createAccount<IguanaAccountId>(
        walletId: wallet.walletId,
        // TODO: Localize
        name: 'Default account',
      );
    }
  }

  Future<void> deleteLegacyWallet(LegacyWallet wallet) async {
    await Db.sqlDbInstance.delete(
      'Wallet',
      where: 'id = ?',
      whereArgs: [wallet.walletId],
    );
  }

  Future<KomodoAccount?> getActiveAccount() async {
    return await _activeAccountRepository.tryGetActiveAccount();
  }

  Future<LegacyWallet?> getAuthenticatedWallet() async {
    final authWallet = await _authenticationRepository.tryGetWallet();

    return authWallet == null
        ? null
        : LegacyWallet(name: authWallet.name, id: authWallet.walletId);
  }

  Future<List<LegacyWallet>> getLegacyStoredWallets() async {
    final Database db = await Db.db;
    final List<Map<String, dynamic>> walletsJson = await db.query('Wallet');

    Log('LegacyDatabaseAdapter:getLegacyStoredWallets', walletsJson.length);
    return walletsJson
        .map((e) => LegacyWallet(id: e['id'], name: e['name']))
        .toList();
  }

  List<LegacyWallet> getNonMigratedWallets(
    List<LegacyWallet> legacyWallets,
    List<KomodoWallet> wallets,
  ) {
    return legacyWallets
        .where(
          (legacyWallet) => !legacyWalletExistsInWallets(legacyWallet, wallets),
        )
        .toList();
  }

  Future<List<LegacyWallet>> listWallets() async {
    final wallets = await _walletsRepository.listWallets();

    return wallets
        .map((w) => LegacyWallet(name: w.name, id: w.walletId))
        .toList();
  }

  void logWalletMigration(List<KomodoWallet> nonMigratedWallets) {
    final bool needsToMigrateWallets = nonMigratedWallets.isNotEmpty;

    Log(
      'LegacyDatabaseAdapter:migrateLegacyWallets',
      needsToMigrateWallets
          ? 'Migrating ${nonMigratedWallets.length} '
              'legacy wallets to new storage format.'
          : 'No legacy wallets to migrate.',
    );
  }

  /// Migrate legacy wallets to the new storage format for multi-account
  /// support.
  ///
  /// Each legacy wallet which does not already exist in the new
  /// format will be migrated by creating a new-format wallet with a single
  /// Iguana account.
  ///
  /// After migration, the legacy wallet is deleted from SQLite.
  Future<void> migrateLegacyWallets() async {
    final legacyWallets = await getLegacyStoredWallets();
    final wallets = await _sdk.wallets.listWallets();

    final nonMigratedWallets = getNonMigratedWallets(legacyWallets, wallets);
    logWalletMigration(nonMigratedWallets);

    for (final wallet in nonMigratedWallets) {
      await migrateWallet(wallet);
    }
  }

  Future<void> migrateWallet(LegacyWallet wallet) async {
    try {
      await createNewWallet(wallet);
      await deleteLegacyWallet(wallet);
    } catch (e) {
      revertWalletMigrationOnError(wallet, e);
    }
  }

  void revertWalletMigrationOnError(KomodoWallet wallet, dynamic error) {
    _sdk.accounts.deleteAccount(wallet.walletId, IguanaAccountId()).ignore();

    _walletsRepository.removeWallet(wallet.walletId).ignore();

    Db.sqlDbInstance
        .insert(
          'Wallet',
          {'id': wallet.walletId, 'name': wallet.name},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        )
        .ignore();

    Log(
      'LegacyDatabaseAdapter:migrateLegacyWallets',
      'Failed to migrate wallet: $error',
    );
  }

  Future<LegacyWallet?> tryGetAuthenticatedWallet() async {
    final wallet = await getAuthenticatedWallet();
    final account = await getActiveAccount();

    return _accountAsLegacyWallet(account);
  }

  bool legacyWalletExistsInWallets(
    LegacyWallet legacyWallet,
    List<KomodoWallet> wallets,
  ) {
    assert(legacyWallet.id != null);
    return wallets.any((wallet) => wallet.walletId == legacyWallet.id);
  }

  static Future<void> init({
    required WalletsRepository walletsRepository,
    required AuthenticationRepository authenticationRepository,
    required ActiveAccountRepository activeAccountRepository,
    required AccountRepository accountRepository,
  }) async {
    assert(_instance == null);
    if (_instance != null) return;

    _instance = LegacyDatabaseAdapter._(
      walletsRepository: walletsRepository,
      authenticationRepository: authenticationRepository,
      activeAccountRepository: activeAccountRepository,
      accountRepository: accountRepository,
    );
  }
}

LegacyWallet? _accountAsLegacyWallet(KomodoAccount? account) {
  if (account == null) return null;

  return LegacyWallet(
    id: account.walletId,
    name: account.name,
  );
}

LegacyWallet? _walletAsLegacyWallet(KomodoWallet? wallet) {
  if (wallet == null) return null;

  return LegacyWallet(
    id: wallet.walletId,
    name: wallet.name,
  );
}
