import 'dart:convert';
import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komodo_dex/navigation/app_routes.dart';
import 'package:komodo_dex/packages/accounts/bloc/accounts_list_bloc.dart';
import 'package:komodo_dex/packages/accounts/bloc/active_account_bloc.dart';
import 'package:komodo_dex/packages/accounts/events/accounts_list_event.dart';
import 'package:komodo_dex/packages/accounts/events/active_account_event.dart';
import 'package:komodo_dex/packages/accounts/models/account.dart';
import 'package:komodo_dex/packages/accounts/state/accounts_list_state.dart';
import 'package:komodo_dex/packages/accounts/state/active_account_state.dart';
import 'package:komodo_dex/packages/app/widgets/main_app.dart';

class AccountsListPage extends StatefulWidget {
  @override
  State<AccountsListPage> createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountsListBloc>().add(AccountsListSubscriptionRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountsListBloc, AccountsListState>(
          listener: _onAccountsListStateChange,
        ),
        BlocListener<ActiveAccountBloc, ActiveAccountState>(
          listener: _onActiveAccountStateChange,
        ),
      ],
      child: BlocBuilder<AccountsListBloc, AccountsListState>(
        builder: (context, state) {
          if (_shouldShowLoadingIndicator) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AccountsListLoadSuccess) {
            return Scaffold(
              appBar: AppBar(title: Text('Accounts List')),
              body: ListView.builder(
                itemCount: state.accounts.length,
                itemBuilder: (BuildContext context, int index) {
                  final account = state.accounts[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: account.themeColor,
                        child: Text(_accountNameAbbreviation(account.name)),
                      ),
                      title: Text(account.name),
                      subtitle: account.description == null
                          ? null
                          : Text(account.description!),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _onProfileEdit(account),
                      ),
                      onTap: () => _onTapAccount(account),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Beamer.of(context)
                      .beamToNamed(AppRoutes.accounts.createAccount());
                },
                child: Icon(Icons.add),
              ),
            );
          } else if (state is AccountsListError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('No accounts loaded.'));
          }
        },
      ),
    );
  }

  bool get _shouldShowLoadingIndicator {
    final state = context.read<AccountsListBloc>().state;
    return state is AccountsListLoadInProgress || state is AccountsListInitial;
  }

  void _onAccountsListStateChange(
      BuildContext context, AccountsListState state) {
    if (state is AccountsListError) {
      MainApp.rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  void _onActiveAccountStateChange(
      BuildContext context, ActiveAccountState state) {
    if (state is ActiveAccountSuccess) {
      Beamer.of(context).beamToNamed(AppRoutes.portfolio.home());
    } else if (state is ActiveAccountFailure) {
      MainApp.rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }

  void _onTapAccount(Account account) {
    context.read<ActiveAccountBloc>().add(
          ActiveAccountSwitchRequested(requestedAccountId: account.accountId),
        );
  }

  void _onProfileEdit(Account account) {
    Beamer.of(context).beamToNamed(
      AppRoutes.accounts.editAccount(
        jsonEncode(account.accountId.toJson()),
      ),
    );
  }

  String _accountNameAbbreviation(String name) {
    return name.substring(0, min(2, name.length)).toUpperCase();
  }
}
