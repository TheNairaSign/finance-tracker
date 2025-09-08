/// A base class for all authentication related exceptions.
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

/// Thrown if the user is not found during login.
class UserNotFoundAuthException extends AuthException {
  UserNotFoundAuthException() : super('User not found.');
}

/// Thrown if the wrong password is provided during login.
class WrongPasswordAuthException extends AuthException {
  WrongPasswordAuthException() : super('Wrong password.');
}
