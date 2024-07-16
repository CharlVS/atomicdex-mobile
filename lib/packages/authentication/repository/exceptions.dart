class AuthenticationRepositoryHelper {}

class AuthenticationRepositoryException implements Exception {
  AuthenticationRepositoryException(this.message);

  final String message;
}

// class WalletNotFoundException implements AuthenticationRepositoryException {
//   WalletNotFoundException(this.message);

//   final String message;
// }

// class WalletAlreadyExistsException
//     implements AuthenticationRepositoryException {
//   WalletAlreadyExistsException(this.message);

//   final String message;
// }

// class WalletNotCreatedException implements AuthenticationRepositoryException {
//   WalletNotCreatedException(this.message);

//   final String message;
// }
