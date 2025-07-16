import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/user.dart';
import 'package:mamacare/utils/app_exceptions.dart';

class AuthService extends Cubit<User?> {
  final Box<User> _usersBox;

  AuthService() : _usersBox = Hive.box<User>('users'), super(null);

  Future<void> login(String email, String password) async {
    try {
      final user = _usersBox.values.firstWhere(
        (user) => user.email == email,
        orElse: () => throw UserNotFoundException(),
      );

      if (user.passwordHash != password) { // In production, compare hashed passwords
        throw InvalidCredentialsException();
      }

      if (!user.isActive) {
        throw UserDisabledException();
      }

      emit(user);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> register(User user) async {
    try {
      if (_usersBox.values.any((u) => u.email == user.email)) {
        throw EmailAlreadyExistsException();
      }

      if (_usersBox.values.any((u) => u.phoneNumber == user.phoneNumber)) {
        throw PhoneNumberExistsException();
      }

      await _usersBox.put(user.id, user);
      emit(user);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> logout() async {
    emit(null);
  }

  Future<void> createAdmin(User admin, {required User superuser}) async {
    if (superuser.role != UserRole.superuser) {
      throw InsufficientPermissionsException();
    }

    try {
      await _usersBox.put(admin.id, admin);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _usersBox.values.firstWhere(
        (user) => user.email == email,
        orElse: () => throw UserNotFoundException(),
      );

      // In production: Generate and send reset token
      // await _sendPasswordResetEmail(user.email);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}