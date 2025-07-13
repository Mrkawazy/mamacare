import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/user.dart';

class AuthService extends Cubit<User?> {
  final Box<User> _usersBox;

  AuthService() : _usersBox = Hive.box<User>('users'), super(null);

  Future<void> login(String email, String password) async {
    try {
      final user = _usersBox.values.firstWhere(
        (user) => user.email == email && user.passwordHash == password,
        orElse: () => throw Exception('Invalid credentials'),
      );
      
      if (!user.isActive) {
        throw Exception('Account is not active');
      }
      
      emit(user);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> register(User user) async {
    try {
      // Check if email already exists
      if (_usersBox.values.any((u) => u.email == user.email)) {
        throw Exception('Email already registered');
      }

      // Check if phone already exists
      if (_usersBox.values.any((u) => u.phoneNumber == user.phoneNumber)) {
        throw Exception('Phone number already registered');
      }

      await _usersBox.put(user.id, user);
      emit(user);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    emit(null);
  }

  Future<void> resetPassword(String email) async {
    // TODO: Implement password reset logic
    // This would typically send a reset link to the email
    throw UnimplementedError();
  }

  Future<void> createAdmin(User admin, {required User superuser}) async {
    if (superuser.role != UserRole.superuser) {
      throw Exception('Only superusers can create admins');
    }
    await _usersBox.put(admin.id, admin);
  }
}