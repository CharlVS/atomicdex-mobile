import 'package:equatable/equatable.dart';
import 'package:komodo_wallet_sdk/komodo_wallet_sdk.dart';

/// [ActiveAccountState] is the base abstract class for all ActiveAccount states.
///
/// This class is used as a base for all other states to extend.
abstract class ActiveAccountState extends Equatable {
  const ActiveAccountState();

  KomodoAccount? get activeOrPendingAccount => this is ActiveAccountSuccess
      ? (this as ActiveAccountSuccess).account
      : this is ActiveAccountSwitchInProgress
          ? (this as ActiveAccountSwitchInProgress).account
          : null;

  KomodoAccount? get activeAccount => this is ActiveAccountSuccess
      ? (this as ActiveAccountSuccess).account
      : null;

  @override
  List<Object?> get props;

  Map<String, dynamic> toJson() => throw UnimplementedError();

  static ActiveAccountState fromJson(Map<String, dynamic> json) {
    switch (json['stateName'] as String) {
      case 'ActiveAccountInProgress':
        return ActiveAccountInProgress();
      case 'ActiveAccountSuccess':
        return ActiveAccountSuccess(
          account: KomodoAccount.fromJson(json['account']),
        );
      case 'ActiveAccountFailure':
        return ActiveAccountFailure(error: json['error']);
      case 'ActiveAccountSwitchInProgress':
        return ActiveAccountSwitchInProgress(
          account: KomodoAccount.fromJson(json['account']),
          requestedAccount: KomodoAccount.fromJson(json['requestedAccount']),
        );
      default:
        return ActiveAccountInitial();
    }
  }

  static String typeName(Type type) => stateNames[type]!;

  static Map<Type, String> get stateNames => {
        ActiveAccountInitial: 'ActiveAccountInitial',
        ActiveAccountInProgress: 'ActiveAccountInProgress',
        ActiveAccountSuccess: 'ActiveAccountSuccess',
        ActiveAccountFailure: 'ActiveAccountFailure',
        ActiveAccountSwitchInProgress: 'ActiveAccountSwitchInProgress',
      };
}

/// [ActiveAccountInitial] represents the initial state of the ActiveAccount bloc.
///
/// This state indicates that no action has been performed yet, and the active account status
/// is unknown or not yet loaded. The UI should show a loading indicator or a neutral state.
class ActiveAccountInitial extends ActiveAccountState {
  @override
  Map<String, dynamic> toJson() =>
      {'stateName': ActiveAccountState.typeName(runtimeType)};

  @override
  List<Object?> get props => [];
}

/// [ActiveAccountInProgress] represents the state when the ActiveAccount bloc is in progress
/// of loading or performing an action.
///
/// In this state, the UI should show a loading indicator or disable the relevant UI components
/// to prevent user interaction until the action is complete.
class ActiveAccountInProgress extends ActiveAccountState {
  @override
  Map<String, dynamic> toJson() => {
        'stateName': ActiveAccountState.typeName(runtimeType),
      };

  @override
  List<Object?> get props => [];
}

/// [ActiveAccountSuccess] represents the state when the ActiveAccount bloc has successfully
/// retrieved or changed the active account.
///
/// This state includes the current active [Account]. The UI should update to display
/// the active account information and allow the user to interact with it.
class ActiveAccountSuccess extends ActiveAccountState {
  const ActiveAccountSuccess({required this.account});
  final KomodoAccount account;

  @override
  List<Object?> get props => [account];

  @override
  Map<String, dynamic> toJson() => {
        'stateName': ActiveAccountState.typeName(runtimeType),
        'account': account.toJson(),
      };
}

/// [ActiveAccountFailure] represents the state when the ActiveAccount bloc has encountered
/// an error while retrieving or changing the active account.
///
/// In this state, the UI should display an error message or provide a way for the user to
/// retry the action.
class ActiveAccountFailure extends ActiveAccountState {
  const ActiveAccountFailure({required this.error, this.exception});
  final String error;

  final Exception? exception;

  @override
  List<Object?> get props => [error, exception];

  @override
  Map<String, dynamic> toJson() => {
        'stateName': ActiveAccountState.typeName(runtimeType),
        'error': error,
      };
}

/// [ActiveAccountSwitchInProgress] represents the state when the ActiveAccount bloc is in progress
/// of changing the active account to a new one.
///
/// This state includes the current active [Account] and the requested [Account] to switch to.
/// The UI should show a loading indicator or disable the relevant UI components to prevent
/// user interaction until the switch is complete.
class ActiveAccountSwitchInProgress extends ActiveAccountState {
  const ActiveAccountSwitchInProgress({
    required this.account,
    required this.requestedAccount,
  });

  final KomodoAccount account;
  final KomodoAccount requestedAccount;

  @override
  List<Object?> get props => [account, requestedAccount];

  @override
  Map<String, dynamic> toJson() => {
        'stateName': ActiveAccountState.typeName(runtimeType),
        'account': account.toJson(),
        'requestedAccount': requestedAccount.toJson(),
      };
}
