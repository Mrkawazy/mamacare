class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

// Auth Exceptions
class AuthException extends AppException {
  AuthException(String message) : super(message);
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('User not found');
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Invalid credentials');
}

class EmailAlreadyExistsException extends AuthException {
  EmailAlreadyExistsException() : super('Email already registered');
}

class PhoneNumberExistsException extends AuthException {
  PhoneNumberExistsException() : super('Phone number already registered');
}

class UserDisabledException extends AuthException {
  UserDisabledException() : super('Account is disabled');
}

class InsufficientPermissionsException extends AuthException {
  InsufficientPermissionsException() : super('Insufficient permissions');
}

// Database Exceptions
class DatabaseException extends AppException {
  DatabaseException(String message) : super(message);
}

// Location Exceptions
class LocationException extends AppException {
  LocationException(String message) : super(message);
}

class LocationPermissionDeniedException extends LocationException {
  LocationPermissionDeniedException() : super('Location permission denied');
}

// Notification Exceptions
class NotificationException extends AppException {
  NotificationException(String message) : super(message);
}

// Sync Exceptions
class SyncException extends AppException {
  SyncException(String message) : super(message);
}