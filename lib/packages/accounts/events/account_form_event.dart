import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

abstract class AccountFormEvent extends Equatable {
  const AccountFormEvent();

  @override
  List<Object?> get props => [];
}

class AccountFormStartedEvent extends AccountFormEvent {
  AccountFormStartedEvent({required KomodoAccount? account})
      : accountId = account?.accountId,
        name = account?.name,
        description = account?.description,
        themeColor = account?.themeColor,
        avatar = (account?.avatar?.isEmpty ?? false)
            ? Uint8List.fromList(account!.avatar!)
            : null;

  final AccountId? accountId;
  final String? name;
  final String? description;
  final Color? themeColor;
  final Uint8List? avatar;

  @override
  List<Object?> get props => [accountId, name, description, themeColor, avatar];
}

class AccountFormNameChanged extends AccountFormEvent {
  const AccountFormNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class AccountFormDescriptionChanged extends AccountFormEvent {
  const AccountFormDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class AccountFormThemeColorChanged extends AccountFormEvent {
  const AccountFormThemeColorChanged(this.themeColor);

  final Color themeColor;

  @override
  List<Object> get props => [themeColor];
}

class AccountFormAvatarChanged extends AccountFormEvent {
  const AccountFormAvatarChanged(this.avatar);

  final List<int> avatar;

  @override
  List<Object> get props => [avatar];
}

class AccountFormSubmitted extends AccountFormEvent {}
